package com.savora.controller;
 
import com.savora.dao.BookingDAO;
import com.savora.dao.OrderDAO;
import com.savora.model.Booking;
import com.savora.model.Order;
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
 * Controller (Servlet) for tracking food order preparation status by booking.
 */
@WebServlet(name = "TrackOrderServlet", urlPatterns = {"/order/track"})
public class TrackOrderServlet extends HttpServlet {
 
    private final BookingDAO bookingDAO = new BookingDAO();
    private final OrderDAO orderDAO = new OrderDAO();
 
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
 
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
 
        try {
            bookingDAO.markPastBookingsCompleted();
            java.time.LocalDate today = java.time.LocalDate.now();
 
            List<Booking> allBookings = bookingDAO.findByUserId(userId);
            List<Order> orders = orderDAO.findByUserId(userId); // already sorted by OrderDate DESC
 
            // Only today's reservations can be selected/tracked; once the
            // reservation date has passed it drops out of the selector.
            List<Booking> bookings = new java.util.ArrayList<>();
            for (Booking b : allBookings) {
                if (today.equals(b.getBookingDate())) {
                    bookings.add(b);
                }
            }
 
            // Link bookings to their respective dine-in orders
            for (Booking b : bookings) {
                for (Order o : orders) {
                    if (o.getBookingId() != null && o.getBookingId().intValue() == b.getBookingId()) {
                        b.setOrderId(o.getOrderId());
                        b.setOrderStatus(o.getOrderStatus());
                        break;
                    }
                }
            }
 
            // Orders placed without a table reservation (takeaway) aren't linked to
            // any Booking, so they need to be tracked as their own list of items.
            // Likewise, only keep takeaway orders placed today in the selector.
            List<Order> takeawayOrders = new java.util.ArrayList<>();
            for (Order o : orders) {
                if (o.getBookingId() == null && o.getOrderDate() != null
                        && today.equals(o.getOrderDate().toLocalDate())) {
                    takeawayOrders.add(o);
                }
            }
 
            Booking selectedBooking = null;
            Order selectedTakeawayOrder = null;
 
            // trackId identifies the chosen item from the combined dropdown, e.g.
            // "B12" for Booking #12 or "O7" for takeaway Order #7.
            String trackId = request.getParameter("trackId");
            if (trackId == null) {
                // Backward compatible with the old bookingId-only parameter
                String bookingIdParam = request.getParameter("bookingId");
                if (bookingIdParam != null && !bookingIdParam.isEmpty()) {
                    trackId = "B" + bookingIdParam;
                }
            }
 
            if (trackId != null && trackId.length() > 1) {
                char type = trackId.charAt(0);
                try {
                    int id = Integer.parseInt(trackId.substring(1));
                    if (type == 'B') {
                        for (Booking b : bookings) {
                            if (b.getBookingId() == id) {
                                selectedBooking = b;
                                break;
                            }
                        }
                    } else if (type == 'O') {
                        for (Order o : takeawayOrders) {
                            if (o.getOrderId() == id) {
                                selectedTakeawayOrder = o;
                                break;
                            }
                        }
                    }
                } catch (NumberFormatException ignored) {}
            }
 
            // If nothing was explicitly selected, default to the most recent
            // *today's* order overall (dine-in or takeaway).
            if (selectedBooking == null && selectedTakeawayOrder == null) {
                for (Order o : orders) {
                    if (o.getBookingId() == null) {
                        for (Order t : takeawayOrders) {
                            if (t.getOrderId() == o.getOrderId()) {
                                selectedTakeawayOrder = t;
                                break;
                            }
                        }
                    } else {
                        for (Booking b : bookings) {
                            if (b.getOrderId() != null && b.getOrderId() == o.getOrderId()) {
                                selectedBooking = b;
                                break;
                            }
                        }
                    }
                    if (selectedBooking != null || selectedTakeawayOrder != null) {
                        break;
                    }
                }
                // Still nothing with an order today; fall back to the first
                // unordered reservation for today, if any.
                if (selectedBooking == null && selectedTakeawayOrder == null && !bookings.isEmpty()) {
                    selectedBooking = bookings.get(0);
                }
            }
 
            Order selectedOrder = null;
            if (selectedTakeawayOrder != null) {
                selectedOrder = orderDAO.findById(selectedTakeawayOrder.getOrderId());
            } else if (selectedBooking != null && selectedBooking.getOrderId() != null) {
                selectedOrder = orderDAO.findById(selectedBooking.getOrderId());
            }
 
            request.setAttribute("bookings", bookings);
            request.setAttribute("takeawayOrders", takeawayOrders);
            request.setAttribute("selectedBooking", selectedBooking);
            request.setAttribute("selectedTakeawayOrder", selectedTakeawayOrder);
            request.setAttribute("selectedOrder", selectedOrder);
 
            request.getRequestDispatcher("/WEB-INF/customer/track_order.jsp").forward(request, response);
 
        } catch (SQLException e) {
            throw new ServletException("Error retrieving order status tracking data", e);
        }
    }
}