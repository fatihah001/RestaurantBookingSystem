package com.savora.controller;

import com.savora.dao.BookingDAO;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/admin/booking-delete")
public class BookingDeleteServlet extends HttpServlet {

    private BookingDAO bookingDAO;

    @Override
    public void init() {
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        try {

            int bookingId =
                    Integer.parseInt(
                            request.getParameter("id"));

            bookingDAO.delete(bookingId);

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/bookings");

        } catch(Exception e){
            e.printStackTrace();
        }
    }
}