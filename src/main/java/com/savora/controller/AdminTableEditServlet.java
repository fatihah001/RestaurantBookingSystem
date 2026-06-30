package com.savora.controller;

import com.savora.dao.TableDAO;
import com.savora.model.RestaurantTable;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/admin/table-edit")
public class AdminTableEditServlet extends HttpServlet {

    private TableDAO tableDAO;

    @Override
    public void init() {
        tableDAO = new TableDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int id = Integer.parseInt(
                    request.getParameter("id"));

            RestaurantTable table =
                    tableDAO.findById(id);

            request.setAttribute("table", table);

            request.getRequestDispatcher(
                    "/WEB-INF/admin/edit-table.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}