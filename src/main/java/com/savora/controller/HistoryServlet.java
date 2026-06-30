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
 * Controller (Servlet) for the booking History module.
 */
@WebServlet(name = "HistoryServlet", urlPatterns = {"/history"})
public class HistoryServlet extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        try {
            bookingDAO.markPastBookingsCompleted();
            List<Booking> bookings = bookingDAO.findByUserId(userId);
            List<Order> orders = orderDAO.findByUserId(userId);

            for (Booking b : bookings) {
                for (Order o : orders) {
                    if (o.getBookingId() != null && o.getBookingId().intValue() == b.getBookingId()) {
                        b.setOrderId(o.getOrderId());
                        b.setOrderStatus(o.getOrderStatus());
                        break;
                    }
                }
            }

            // Orders placed without a table reservation (takeaway orders) are not
            // linked to any Booking, so they must be listed separately or they
            // would never show up anywhere in the customer's history.
            List<Order> takeawayOrders = new java.util.ArrayList<>();
            for (Order o : orders) {
                if (o.getBookingId() == null) {
                    takeawayOrders.add(o);
                }
            }

            request.setAttribute("bookings", bookings);
            request.setAttribute("takeawayOrders", takeawayOrders);
            request.getRequestDispatcher("/WEB-INF/customer/history.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Error loading booking history", e);
        }
    }
}