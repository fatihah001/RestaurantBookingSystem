package com.savora.controller;

import com.savora.dao.BookingDAO;
import com.savora.dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int totalOrders = orderDAO.countAllOrders();
            BigDecimal totalSales = orderDAO.getTotalSales();
            int totalReservations = bookingDAO.countAllBookings();

            com.google.gson.Gson gson = new com.google.gson.Gson();
            String salesJson = gson.toJson(orderDAO.getSalesDataLast7Days());
            String bookingJson = gson.toJson(bookingDAO.getBookingStatusStats());

            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("totalSales", totalSales);
            request.setAttribute("totalReservations", totalReservations);
            request.setAttribute("salesJson", salesJson);
            request.setAttribute("bookingJson", bookingJson);

            request.getRequestDispatcher("/WEB-INF/admin/dashboard.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Error loading admin dashboard stats", e);
        }
    }
}