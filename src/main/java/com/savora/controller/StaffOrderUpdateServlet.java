package com.savora.controller;
 
import com.savora.dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
 
import java.io.IOException;
import java.sql.SQLException;
 
@WebServlet("/staff/order-update")
public class StaffOrderUpdateServlet extends HttpServlet {
 
    private final OrderDAO orderDAO = new OrderDAO();
 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
 
        String orderIdParam  = request.getParameter("orderId");
        String status        = request.getParameter("status");
        String filter        = request.getParameter("filter");
        String tableId       = request.getParameter("tableId");
        String statusFilter  = request.getParameter("statusFilter");
        String dateParam     = request.getParameter("date"); // NEW: preserve date filter
 
        if (orderIdParam == null || status == null) {
            response.sendRedirect(request.getContextPath() + "/staff/orders");
            return;
        }
 
        try {
            int orderId = Integer.parseInt(orderIdParam);
            orderDAO.updateStatus(orderId, status);
 
            // Reconstruct redirect URL preserving all active filters
            StringBuilder redirectUrl = new StringBuilder(
                request.getContextPath() + "/staff/orders?filter=" + (filter != null ? filter : "today")
            );
            if (tableId != null && !tableId.trim().isEmpty()) {
                redirectUrl.append("&tableId=").append(tableId);
            }
            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                redirectUrl.append("&status=").append(statusFilter);
            }
            // Preserve date filter so staff stays on the same date view
            if (dateParam != null && !dateParam.trim().isEmpty()) {
                redirectUrl.append("&date=").append(dateParam);
            }
 
            response.sendRedirect(redirectUrl.toString());
 
        } catch (NumberFormatException | SQLException e) {
            throw new ServletException("Error updating order status", e);
        }
    }
}