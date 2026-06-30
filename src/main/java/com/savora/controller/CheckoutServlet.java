package com.savora.controller;

import com.savora.dao.BookingDAO;
import com.savora.dao.CartDAO;
import com.savora.dao.OrderDAO;
import com.savora.dao.TableDAO;
import com.savora.dao.WalletDAO;
import com.savora.model.Booking;
import com.savora.model.CartItem;
import com.savora.model.User;
import com.savora.model.Wallet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

/**
 * Controller (Servlet) for the checkout step (Step 4): contact info,
 * order summary, and payment method, finalised into Booking + Order_ rows.
 */
@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout"})
public class CheckoutServlet extends HttpServlet {

    private static final BigDecimal TAX_RATE = new BigDecimal("0.08"); // 8%

    private final CartDAO cartDAO = new CartDAO();
    private final BookingDAO bookingDAO = new BookingDAO();
    private final TableDAO tableDAO = new TableDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    private final WalletDAO walletDAO = new WalletDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        try {
            int cartId = cartDAO.getOrCreateCartId(userId);
            List<CartItem> items = cartDAO.getCartItems(cartId);

            if (items.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/menu");
                return;
            }

            BigDecimal subtotal = cartDAO.getCartTotal(cartId);
            BigDecimal tax = subtotal.multiply(TAX_RATE).setScale(2, RoundingMode.HALF_UP);
            BigDecimal total = subtotal.add(tax);

            Wallet wallet = walletDAO.getOrCreateWallet(userId);

            Integer pendingTableId = (Integer) session.getAttribute("pendingTableId");

            request.setAttribute("cartItems", items);
            request.setAttribute("subtotal", subtotal);
            request.setAttribute("tax", tax);
            request.setAttribute("total", total);
            request.setAttribute("wallet", wallet);
            request.setAttribute("hasTableSelected", pendingTableId != null);
            request.setAttribute("user", user);

            request.getRequestDispatcher("/WEB-INF/customer/checkout.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Error loading checkout", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = user.getUserId();

        String paymentMethod = request.getParameter("paymentMethod");
        String takeawayDateStr = request.getParameter("takeawayDate");
        String takeawayTimeStr = request.getParameter("takeawayTime");

        try {
            int cartId = cartDAO.getOrCreateCartId(userId);
            List<CartItem> items = cartDAO.getCartItems(cartId);

            if (items.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/menu");
                return;
            }

            BigDecimal subtotal = cartDAO.getCartTotal(cartId);
            BigDecimal tax = subtotal.multiply(TAX_RATE).setScale(2, RoundingMode.HALF_UP);
            BigDecimal total = subtotal.add(tax);

            // If wallet payment, verify and debit funds
            if ("Wallet".equals(paymentMethod)) {
                Wallet wallet = walletDAO.getOrCreateWallet(userId);
                if (wallet.getBalance().compareTo(total) < 0) {
                    request.setAttribute("error", "Insufficient wallet balance. Please top up or choose another payment method.");
                    doGet(request, response);
                    return;
                }
                boolean debited = walletDAO.debit(wallet.getWalletId(), total, "Order payment");
                if (!debited) {
                    request.setAttribute("error", "Payment failed. Please try again.");
                    doGet(request, response);
                    return;
                }
            }

            // Finalise booking if a table was selected in Step 3
            Integer pendingTableId = (Integer) session.getAttribute("pendingTableId");
            Integer bookingId = null;
            boolean walletDebited = "Wallet".equals(paymentMethod);

            if (pendingTableId != null) {
                LocalDate bookingDate = (LocalDate) session.getAttribute("pendingBookingDate");
                LocalTime bookingTime = (LocalTime) session.getAttribute("pendingBookingTime");
                Integer numGuests = (Integer) session.getAttribute("pendingNumGuests");

                LocalDate finalBookingDate = bookingDate != null ? bookingDate : LocalDate.now();
                LocalTime finalBookingTime = bookingTime != null ? bookingTime : LocalTime.now();

                // Final guard: re-check right before committing, in case another
                // device booked this exact table/date/time in the meantime
                // (the earlier check on the booking-selection page can go stale
                // while this customer was browsing the menu / cart).
                if (tableDAO.isTableBooked(pendingTableId, finalBookingDate.toString(), finalBookingTime.toString())) {
                    if (walletDebited) {
                        refundWallet(userId, total);
                    }
                    session.removeAttribute("pendingTableId");
                    session.removeAttribute("pendingBookingDate");
                    session.removeAttribute("pendingBookingTime");
                    session.removeAttribute("pendingNumGuests");
                    request.setAttribute("error",
                            "Sorry, that table was just booked by someone else for this date/time. "
                            + "Please choose another table or time slot.");
                    response.sendRedirect(request.getContextPath() + "/booking");
                    return;
                }

                Booking booking = new Booking();
                booking.setUserId(userId);
                booking.setTableId(pendingTableId);
                booking.setBookingDate(finalBookingDate);
                booking.setBookingTime(finalBookingTime);
                booking.setNoOfPeople(numGuests != null ? numGuests : 2);
                booking.setStatus("Confirmed");

                try {
                    bookingId = bookingDAO.create(booking);
                } catch (SQLIntegrityConstraintViolationException dupe) {
                    // Belt-and-suspenders: even if the re-check above passed, a
                    // concurrent insert from another device could still win the
                    // race a split second later. The DB-level UNIQUE constraint
                    // on (TableID, BookingDate, BookingTime) is what actually
                    // guarantees no double-booking; this just turns that DB
                    // rejection into a friendly message instead of a 500 error.
                    if (walletDebited) {
                        refundWallet(userId, total);
                    }
                    session.removeAttribute("pendingTableId");
                    session.removeAttribute("pendingBookingDate");
                    session.removeAttribute("pendingBookingTime");
                    session.removeAttribute("pendingNumGuests");
                    request.setAttribute("error",
                            "Sorry, that table was just booked by someone else for this date/time. "
                            + "Please choose another table or time slot.");
                    response.sendRedirect(request.getContextPath() + "/booking");
                    return;
                }

                session.removeAttribute("pendingTableId");
                session.removeAttribute("pendingBookingDate");
                session.removeAttribute("pendingBookingTime");
                session.removeAttribute("pendingNumGuests");
            }

            java.sql.Timestamp customOrderDate = null;
            if (pendingTableId == null) {
                if (takeawayDateStr != null && !takeawayDateStr.isEmpty() && takeawayTimeStr != null && !takeawayTimeStr.isEmpty()) {
                    try {
                        LocalDate pDate = LocalDate.parse(takeawayDateStr);
                        LocalTime pTime = LocalTime.parse(takeawayTimeStr);
                        customOrderDate = java.sql.Timestamp.valueOf(pDate.atTime(pTime));
                    } catch (Exception e) {
                        // ignore or fallback to null
                    }
                }
            }

            int orderId = orderDAO.placeOrder(userId, bookingId, items, subtotal, tax, total, paymentMethod, customOrderDate);

            cartDAO.clearCart(cartId);
            session.setAttribute("itemsInCart", 0);

            response.sendRedirect(request.getContextPath() + "/order/confirmation?orderId=" + orderId);
        } catch (SQLException e) {
            throw new ServletException("Error placing order", e);
        }
    }

    /**
     * Credits back a previously-debited wallet amount when a booking fails
     * to commit (e.g. lost a race to another device), so the customer is
     * never charged for a table they didn't actually get.
     */
    private void refundWallet(int userId, BigDecimal amount) throws SQLException {
        Wallet wallet = walletDAO.getOrCreateWallet(userId);
        walletDAO.credit(wallet.getWalletId(), amount, "Refund",
                "Refund: table booking conflict during checkout");
    }
}