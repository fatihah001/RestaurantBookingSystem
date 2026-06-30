package com.savora.controller;

import com.savora.dao.OrderDAO;
import com.savora.model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

/**
 * Controller (Servlet) for displaying the order confirmation page
 * (Step 5: "Done") and order history details.
 */
@WebServlet(name = "OrderServlet", urlPatterns = {"/order/confirmation", "/order/view"})
public class OrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String orderIdParam = request.getParameter("orderId");

        if (orderIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdParam);
            Order order = orderDAO.findById(orderId);

            if (order == null) {
                if ("true".equals(request.getParameter("ajax"))) {
                    response.setContentType("application/json");
                    response.getWriter().write("{\"error\": \"Order not found\"}");
                } else {
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                }
                return;
            }

            if ("true".equals(request.getParameter("ajax"))) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"orderStatus\": \"" + order.getOrderStatus() + "\"}");
                return;
            }

            request.setAttribute("order", order);

            String path = request.getServletPath();
            if ("/order/confirmation".equals(path)) {
                request.getRequestDispatcher("/WEB-INF/customer/order_confirmation.jsp")
                        .forward(request, response);
            } else {
                request.getRequestDispatcher("/WEB-INF/customer/order_view.jsp")
                        .forward(request, response);
            }
        } catch (NumberFormatException | SQLException e) {
            throw new ServletException("Error loading order", e);
        }
    }
}