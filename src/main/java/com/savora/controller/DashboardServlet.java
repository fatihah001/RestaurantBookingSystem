package com.savora.controller;

import com.savora.dao.BookingDAO;
import com.savora.dao.OrderDAO;
import com.savora.dao.WalletDAO;
import com.savora.model.Booking;
import com.savora.model.Order;
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
import java.sql.SQLException;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Controller (Servlet) for the customer Dashboard module.
 * Provides an overview of the user's bookings/orders via different
 * data representations (stat cards, countdown timer, upcoming list).
 */
@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    private final WalletDAO walletDAO = new WalletDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        User user = (User) session.getAttribute("user");

        try {
            bookingDAO.markPastBookingsCompleted();

            int upcomingCount = bookingDAO.countByUserAndStatus(userId, "Confirmed");
            int completedCount = bookingDAO.countByUserAndStatus(userId, "Completed");
            int cancelledCount = bookingDAO.countByUserAndStatus(userId, "Cancelled");
            BigDecimal totalSpent = orderDAO.getTotalSpentByUser(userId);

            Wallet wallet = walletDAO.getOrCreateWallet(userId);

            List<Booking> upcomingBookings = bookingDAO.findUpcomingByUserId(userId);

            // Countdown timer target: nearest upcoming booking (days/hours/min/sec)
            long days = 0, hours = 0, minutes = 0, seconds = 0;
            Booking nextBooking = upcomingBookings.isEmpty() ? null : upcomingBookings.get(0);
            if (nextBooking != null) {
                LocalDateTime target = LocalDateTime.of(nextBooking.getBookingDate(), nextBooking.getBookingTime());
                Duration duration = Duration.between(LocalDateTime.now(), target);
                if (!duration.isNegative()) {
                    days = duration.toDays();
                    hours = duration.toHoursPart();
                    minutes = duration.toMinutesPart();
                    seconds = duration.toSecondsPart();
                }
            }

            request.setAttribute("user", user);
            request.setAttribute("upcomingCount", upcomingCount);
            request.setAttribute("completedCount", completedCount);
            request.setAttribute("cancelledCount", cancelledCount);
            request.setAttribute("totalSpent", totalSpent);
            request.setAttribute("wallet", wallet);
            request.setAttribute("upcomingBookings", upcomingBookings);
            request.setAttribute("nextBooking", nextBooking);
            request.setAttribute("countdownDays", days);
            request.setAttribute("countdownHours", hours);
            request.setAttribute("countdownMinutes", minutes);
            request.setAttribute("countdownSeconds", seconds);


            request.getRequestDispatcher("/WEB-INF/customer/dashboard.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Error loading dashboard", e);
        }
    }
}