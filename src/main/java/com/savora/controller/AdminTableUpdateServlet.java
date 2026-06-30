package com.savora.controller;

import com.savora.dao.TableDAO;
import com.savora.model.RestaurantTable;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/admin/table-update")
public class AdminTableUpdateServlet extends HttpServlet {

    private TableDAO tableDAO;

    @Override
    public void init() {
        tableDAO = new TableDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        try {

            RestaurantTable table =
                    new RestaurantTable();

            table.setTableId(
                    Integer.parseInt(
                    request.getParameter("tableId")));

            table.setTableNo(
                    request.getParameter("tableNo"));

            table.setCapacity(
                    Integer.parseInt(
                    request.getParameter("capacity")));

            table.setLocation(
                    request.getParameter("location"));

            table.setTableStatus(
                    request.getParameter("status"));

            tableDAO.update(table);

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/tables");

        } catch(Exception e) {
            e.printStackTrace();
        }
    }
}