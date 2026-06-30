package com.savora.controller;

import com.savora.dao.CartDAO;
import com.savora.dao.TableDAO;
import com.savora.model.RestaurantTable;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "BookingServlet", urlPatterns = { "/booking", "/booking/*" })
public class BookingServlet extends HttpServlet {

    private final TableDAO tableDAO = new TableDAO();
    private final CartDAO cartDAO = new CartDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        try {
            if ("/availability".equals(pathInfo)) {
                String date = request.getParameter("date");
                String time = request.getParameter("time");
                List<RestaurantTable> tables = tableDAO.findAll();
                if (date != null && !date.trim().isEmpty() && time != null && !time.trim().isEmpty()) {
                    for (RestaurantTable t : tables) {
                        if (tableDAO.isTableBooked(t.getTableId(), date, time)) {
                            t.setTableStatus("Reserved");
                        } else {
                            t.setTableStatus("Available");
                        }
                    }
                }
                response.setContentType("application/json");
                response.getWriter().write(gson.toJson(tables));
                return;
            }

            int cartId = cartDAO.getOrCreateCartId(userId);
            int itemCount = cartDAO.getCartItems(cartId).stream()
                    .mapToInt(i -> i.getQuantity()).sum();

            if (itemCount == 0) {
                request.setAttribute("emptyCart", true);
            }

            List<RestaurantTable> indoorTables = tableDAO.findByLocation("Indoor");
            List<RestaurantTable> outdoorTables = tableDAO.findByLocation("Outdoor");

            String defaultDate = LocalDate.now().toString();
            String defaultTime = "18:00";

            for (RestaurantTable t : indoorTables) {
                if (tableDAO.isTableBooked(t.getTableId(), defaultDate, defaultTime)) {
                    t.setTableStatus("Reserved");
                } else {
                    t.setTableStatus("Available");
                }
            }
            for (RestaurantTable t : outdoorTables) {
                if (tableDAO.isTableBooked(t.getTableId(), defaultDate, defaultTime)) {
                    t.setTableStatus("Reserved");
                } else {
                    t.setTableStatus("Available");
                }
            }

            request.setAttribute("indoorTables", indoorTables);
            request.setAttribute("outdoorTables", outdoorTables);
            request.getRequestDispatcher("/WEB-INF/customer/booking.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Error loading tables", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        String tableIdStr = request.getParameter("tableId");
        String date = request.getParameter("bookingDate");
        String time = request.getParameter("bookingTime");
        String guests = request.getParameter("numGuests");

        if (tableIdStr == null || date == null || time == null) {
            request.setAttribute("error", "Please select a table, date, and time.");
            doGet(request, response);
            return;
        }

        try {
            int tableId = Integer.parseInt(tableIdStr);
            LocalDate bookingDate = LocalDate.parse(date);
            LocalTime bookingTime = LocalTime.parse(time);

            try {
                if (tableDAO.isTableBooked(tableId, date, time)) {
                    request.setAttribute("error",
                            "This table is no longer available for the chosen time. Please pick another.");
                    doGet(request, response);
                    return;
                }
            } catch (SQLException ex) {
                Logger.getLogger(BookingServlet.class.getName()).log(Level.SEVERE, null, ex);
            }

            session.setAttribute("pendingTableId", tableId);
            session.setAttribute("pendingBookingDate", bookingDate);
            session.setAttribute("pendingBookingTime", bookingTime);
            session.setAttribute("pendingNumGuests",
                    guests != null ? Integer.parseInt(guests) : 2);

            response.sendRedirect(request.getContextPath() + "/checkout");
        } catch (NumberFormatException | java.time.format.DateTimeParseException e) {
            request.setAttribute("error", "Invalid booking details. Please try again.");
            doGet(request, response);
        }
    }
}