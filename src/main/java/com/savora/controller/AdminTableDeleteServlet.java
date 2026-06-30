package com.savora.controller;


import com.savora.dao.TableDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/table-delete")
public class AdminTableDeleteServlet extends HttpServlet {

    private TableDAO tableDAO;

    public void init() {
        tableDAO = new TableDAO();
    }

    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        try {

            int id = Integer.parseInt(
                    request.getParameter("id"));

            tableDAO.delete(id);

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/tables");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}