package com.savora.controller;

import com.savora.dao.BookingDAO;
import com.savora.dao.OrderDAO;
import com.savora.dao.TableDAO;
import com.savora.dao.WalletDAO;
import com.savora.model.Booking;
import com.savora.model.Order;
import com.savora.model.Wallet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Controller (Servlet) for the Cancel Booking module.
 * On cancellation, marks the booking as Cancelled, frees up the table,
 * and refunds any wallet-paid order linked to that booking.
 */
@WebServlet(name = "CancelBookingServlet", urlPatterns = {"/booking/cancel"})
public class CancelBookingServlet extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();
    private final TableDAO tableDAO = new TableDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    private final WalletDAO walletDAO = new WalletDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        try {
            bookingDAO.markPastBookingsCompleted();

            List<Booking> bookings = bookingDAO.findByUserId(userId);
            // Only show bookings that can still be cancelled
            bookings.removeIf(b -> !"Confirmed".equals(b.getStatus()));

            request.setAttribute("bookings", bookings);
            request.getRequestDispatcher("/WEB-INF/customer/cancel_booking.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Error loading bookings", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String bookingIdParam = request.getParameter("bookingId");

        try {
            bookingDAO.markPastBookingsCompleted();

            int bookingId = Integer.parseInt(bookingIdParam);
            Booking booking = bookingDAO.findById(bookingId);

            if (booking == null || booking.getUserId() != userId) {
                request.setAttribute("error", "Booking not found.");
                doGet(request, response);
                return;
            }

            if (!"Confirmed".equals(booking.getStatus())) {
                request.setAttribute("error", "This booking can no longer be cancelled.");
                doGet(request, response);
                return;
            }

            // 1. Mark booking as cancelled
            bookingDAO.updateStatus(bookingId, "Cancelled");

            // 2. Free up the table
            tableDAO.updateStatus(booking.getTableId(), "Available");

            // 3. Refund any wallet-paid order tied to this booking
            for (Order order : orderDAO.findByUserId(userId)) {
                if (order.getBookingId() != null && order.getBookingId() == bookingId
                        && "Wallet".equals(order.getPaymentMethod())
                        && !"Cancelled".equals(order.getOrderStatus())) {

                    Wallet wallet = walletDAO.getOrCreateWallet(userId);
                    walletDAO.credit(wallet.getWalletId(), order.getTotalAmount(), "Refund",
                            "Refund for cancelled booking #" + bookingId);
                    orderDAO.updateStatus(order.getOrderId(), "Cancelled");
                }
            }

            response.sendRedirect(request.getContextPath() + "/booking/cancel?success=true");
        } catch (NumberFormatException | SQLException e) {
            throw new ServletException("Error cancelling booking", e);
        }
    }
}