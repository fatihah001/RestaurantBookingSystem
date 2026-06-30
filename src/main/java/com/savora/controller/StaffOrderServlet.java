package com.savora.controller;
 
import com.savora.dao.OrderDAO;
import com.savora.dao.TableDAO;
import com.savora.model.Order;
import com.savora.model.RestaurantTable;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
 
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
 
@WebServlet("/staff/orders")
public class StaffOrderServlet extends HttpServlet {
 
    private final OrderDAO orderDAO = new OrderDAO();
    private final TableDAO tableDAO = new TableDAO();
 
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
 
        String filter = request.getParameter("filter");
        if (filter == null || filter.trim().isEmpty()) {
            filter = "today";
        }
 
        String tableIdParam  = request.getParameter("tableId");
        String statusParam   = request.getParameter("status");
        // NEW: date param — only used when filter == "all"
        String dateParam     = request.getParameter("date");
 
        try {
            List<Order> orders;
            if ("all".equalsIgnoreCase(filter)) {
                // If a specific date is chosen, fetch orders for that date only
                if (dateParam != null && !dateParam.trim().isEmpty()) {
                    orders = orderDAO.findOrdersByDate(dateParam.trim());
                } else {
                    orders = orderDAO.findAllOrders();
                }
            } else {
                orders = orderDAO.findTodaysOrders();
                dateParam = null; // not relevant for today view
            }
 
            // Apply in-memory filters for table and status
            List<Order> filteredOrders = new ArrayList<>();
            for (Order o : orders) {
                boolean matchTable  = true;
                boolean matchStatus = true;
 
                if (tableIdParam != null && !tableIdParam.trim().isEmpty()) {
                    try {
                        int filterTableId = Integer.parseInt(tableIdParam);
                        if (o.getTableId() == null || o.getTableId() != filterTableId) {
                            matchTable = false;
                        }
                    } catch (NumberFormatException e) { /* ignore */ }
                }
 
                if (statusParam != null && !statusParam.trim().isEmpty()) {
                    if (!statusParam.equalsIgnoreCase(o.getOrderStatus())) {
                        matchStatus = false;
                    }
                }
 
                if (matchTable && matchStatus) {
                    filteredOrders.add(o);
                }
            }
 
            List<RestaurantTable> tables = tableDAO.findAll();
 
            request.setAttribute("orders",           filteredOrders);
            request.setAttribute("tables",           tables);
            request.setAttribute("filter",           filter);
            request.setAttribute("selectedTableId",  tableIdParam);
            request.setAttribute("selectedStatus",   statusParam);
            request.setAttribute("selectedDate",     dateParam);
 
            request.getRequestDispatcher("/WEB-INF/staff/orders.jsp").forward(request, response);
 
        } catch (SQLException e) {
            throw new ServletException("Error loading orders list for staff", e);
        }
    }
}