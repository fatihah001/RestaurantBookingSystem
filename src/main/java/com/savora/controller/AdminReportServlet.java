package com.savora.controller;

import com.savora.dao.BookingDAO;
import com.savora.dao.UserDAO;

import com.savora.model.Booking;
import com.savora.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/reports")
public class AdminReportServlet extends HttpServlet {

    private BookingDAO bookingDAO;
    private UserDAO userDAO;

    @Override
    public void init() {

        bookingDAO = new BookingDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            List<Booking> bookings =
                    bookingDAO.findAll();

            List<User> users =
                    userDAO.findAll();
            
            int confirmed = 0;
            int completed = 0;
            int cancelled = 0;

            for(Booking b : bookings){

                if("Confirmed".equalsIgnoreCase(b.getStatus())){
                    confirmed++;
                }
                else if("Completed".equalsIgnoreCase(b.getStatus())){
                    completed++;
                }
                else if("Cancelled".equalsIgnoreCase(b.getStatus())){
                    cancelled++;
                }
            }

            int adminCount = 0;
            int customerCount = 0;

            for(User u : users){

            if("Admin".equalsIgnoreCase(u.getRole())){
                adminCount++;
            }else{
                customerCount++;
            }
        }

            request.setAttribute("bookingCount", bookings.size());
            request.setAttribute("userCount", users.size());
            request.setAttribute("confirmedCount", confirmed);
            request.setAttribute("completedCount", completed);
            request.setAttribute("cancelledCount", cancelled);
            request.setAttribute("adminCount", adminCount);
            request.setAttribute("customerCount", customerCount);
            request.getRequestDispatcher(
                    "/WEB-INF/admin/report.jsp")
                    .forward(request,response);

        } catch(Exception e){
            throw new ServletException(e);
        }
    }
}