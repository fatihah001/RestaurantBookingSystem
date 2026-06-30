package com.savora.controller;

import com.savora.dao.BookingDAO;
import com.savora.model.Booking;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/bookings")
public class AdminBookingServlet extends HttpServlet {

    private BookingDAO bookingDAO;

    @Override
    public void init() {
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        try {

            List<Booking> bookings =
                    bookingDAO.findAll();

            request.setAttribute(
                    "bookings",
                    bookings);

            request.getRequestDispatcher(
                    "/WEB-INF/admin/booking.jsp")
                    .forward(request,response);

        } catch(Exception e){
            throw new ServletException(e);
        }
    }
}