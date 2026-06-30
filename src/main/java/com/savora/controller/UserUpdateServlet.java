package com.savora.controller;

import com.savora.dao.UserDAO;
import com.savora.model.User;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/admin/user-update")
public class UserUpdateServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        try {

            User user = new User();

            user.setUserId(
                    Integer.parseInt(
                            request.getParameter("userId")));

            user.setName(
                    request.getParameter("name"));

            user.setEmail(
                    request.getParameter("email"));

            user.setPhoneNumber(
                    request.getParameter("phone"));

            user.setRole(
                    request.getParameter("role"));

            userDAO.updateProfile(user);

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/users");

        } catch(Exception e){
            e.printStackTrace();
        }
    }
}