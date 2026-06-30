package com.savora.controller;

import com.savora.dao.BookingDAO;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/admin/booking-status")
public class BookingStatusServlet extends HttpServlet {

    private BookingDAO bookingDAO;

    @Override
    public void init() {
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        try {

            int bookingId =
                    Integer.parseInt(
                            request.getParameter("bookingId"));

            String status =
                    request.getParameter("status");

            bookingDAO.updateStatus(
                    bookingId,
                    status);

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/bookings");

        } catch(Exception e){
            e.printStackTrace();
        }
    }
}