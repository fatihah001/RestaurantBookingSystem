package com.savora.controller;

import com.savora.dao.BookingDAO;
import com.savora.dao.OrderDAO;
import com.savora.model.Booking;
import com.savora.model.Order;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet("/staff/dashboard")
public class StaffDashboardServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 1. Fetch all orders to compute active kitchen queue
            List<Order> allOrders = orderDAO.findAllOrders();
            int activeOrdersCount = 0;
            List<Order> activeQueue = new ArrayList<>();
            
            for (Order o : allOrders) {
                if ("Confirmed".equals(o.getOrderStatus()) || "In Preparation".equals(o.getOrderStatus())) {
                    activeOrdersCount++;
                    // Populate up to 8 active orders in the immediate dashboard table queue
                    if (activeQueue.size() < 8) {
                        activeQueue.add(o);
                    }
                }
            }

            // 2. Compute Weekly Completed Sales
            List<Map<String, Object>> weeklySalesData = orderDAO.getSalesDataLast7Days();
            BigDecimal weeklySales = BigDecimal.ZERO;
            for (Map<String, Object> day : weeklySalesData) {
                if (day.get("sales") != null) {
                    weeklySales = weeklySales.add((BigDecimal) day.get("sales"));
                }
            }

            // 3. Process bookings metrics & schedule
            List<Booking> allBookings = bookingDAO.findAll();
            int todaysBookings = 0;
            int pendingBookings = 0;
            LocalDate today = LocalDate.now();
            List<Booking> todaysSchedule = new ArrayList<>();

            for (Booking b : allBookings) {
                if (b.getBookingDate().equals(today)) {
                    todaysBookings++;
                    todaysSchedule.add(b);
                }
                if ("Confirmed".equals(b.getStatus())) {
                    pendingBookings++;
                }
            }

            // 4. Generate Chart.js JSON aggregates (Last 7 Days)
            Gson gson = new Gson();
            String statusJson = gson.toJson(orderDAO.getOrderCountByStatusLast7Days());
            String categoryJson = gson.toJson(orderDAO.getOrderCountByCategoryLast7Days());

            // 5. Set attributes
            request.setAttribute("activeOrders", activeOrdersCount);
            request.setAttribute("weeklySales", weeklySales);
            request.setAttribute("todaysBookings", todaysBookings);
            request.setAttribute("pendingBookings", pendingBookings);
            request.setAttribute("statusJson", statusJson);
            request.setAttribute("categoryJson", categoryJson);
            request.setAttribute("activeQueue", activeQueue);
            request.setAttribute("todaysSchedule", todaysSchedule);

            request.getRequestDispatcher("/WEB-INF/staff/dashboard.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Error loading staff dashboard stats", e);
        }
    }
}
