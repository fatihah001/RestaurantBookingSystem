package com.savora.controller;

import com.savora.dao.UserDAO;
import com.savora.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

/**
 * Controller (Servlet) for viewing and updating the logged-in user's profile
 * (Update operation of the Information Management module for User).
 */
@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        try {
            User user = userDAO.findById(userId);
            request.setAttribute("user", user);
            request.getRequestDispatcher("/WEB-INF/customer/profile.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Error loading profile", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phoneNumber");

        try {
            User user = userDAO.findById(userId);
            user.setName(name);
            user.setEmail(email);
            user.setPhoneNumber(phone);

            boolean updated = userDAO.updateProfile(user);

            if (updated) {
                session.setAttribute("user", user); // keep session bean in sync
                request.setAttribute("success", "Profile updated successfully.");
            } else {
                request.setAttribute("error", "Unable to update profile.");
            }

            request.setAttribute("user", user);
            request.getRequestDispatcher("/WEB-INF/customer/profile.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Error updating profile", e);
        }
    }
}