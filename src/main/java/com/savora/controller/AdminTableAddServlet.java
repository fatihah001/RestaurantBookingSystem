package com.savora.controller;


import com.savora.dao.TableDAO;
import com.savora.model.RestaurantTable;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/table-add")
public class AdminTableAddServlet extends HttpServlet {

    private TableDAO tableDAO;

    public void init() {
        tableDAO = new TableDAO();
    }

    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        try {

            RestaurantTable table =
                    new RestaurantTable();

            table.setTableNo(
                    request.getParameter("tableNo"));

            table.setCapacity(
                    Integer.parseInt(
                    request.getParameter("capacity")));

            table.setLocation(
                    request.getParameter("location"));

            table.setTableStatus(
                    request.getParameter("status"));

            tableDAO.create(table);

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/tables");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}