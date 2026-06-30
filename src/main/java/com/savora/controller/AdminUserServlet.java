package com.savora.controller;

import com.savora.dao.UserDAO;
import com.savora.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            List<User> users = userDAO.findAll();

            int adminCount = 0;
            int staffCount = 0;
            int customerCount = 0;

            for(User u : users){
                if("Admin".equalsIgnoreCase(u.getRole())){
                    adminCount++;
                } else if("Staff".equalsIgnoreCase(u.getRole())){
                    staffCount++;
                } else {
                    customerCount++;
                }
            }

            request.setAttribute("users", users);
            request.setAttribute("adminCount", adminCount);
            request.setAttribute("staffCount", staffCount);
            request.setAttribute("customerCount", customerCount);

            request.getRequestDispatcher(
                    "/WEB-INF/admin/user.jsp")
                    .forward(request,response);

        } catch(Exception e){
            throw new ServletException(e);
        }
    }
}