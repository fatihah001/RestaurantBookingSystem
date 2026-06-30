package com.savora.controller;

import com.savora.dao.UserDAO;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/admin/user-delete")
public class UserDeleteServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        try {

            int userId =
                    Integer.parseInt(
                            request.getParameter("id"));

            userDAO.delete(userId);

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/users");

        } catch(Exception e){
            e.printStackTrace();
        }
    }
}