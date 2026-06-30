package com.savora.controller;

import com.savora.dao.TableDAO;
import com.savora.model.RestaurantTable;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/tables")
public class AdminTableServlet extends HttpServlet {

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

            List<RestaurantTable> tables =
                    tableDAO.findAll();

            request.setAttribute("tables", tables);

            request.getRequestDispatcher(
                    "/WEB-INF/admin/table.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}