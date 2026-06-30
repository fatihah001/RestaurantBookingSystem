package com.savora.controller;

import com.savora.dao.CartDAO;
import com.savora.dao.MenuDAO;
import com.savora.model.MenuItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Controller (Servlet) for browsing the menu (Step 1 of the booking flow).
 */
@WebServlet(name = "MenuServlet", urlPatterns = {"/menu"})
public class MenuServlet extends HttpServlet {

    private final MenuDAO menuDAO = new MenuDAO();
    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        try {
            String category = request.getParameter("category");
            List<MenuItem> items = (category != null && !category.equalsIgnoreCase("All"))
                    ? menuDAO.findByCategory(category)
                    : menuDAO.findAll();

            int cartId = cartDAO.getOrCreateCartId(userId);
            int itemsInCart = cartDAO.getCartItems(cartId).stream()
                    .mapToInt(i -> i.getQuantity()).sum();

            request.setAttribute("menuItems", items);
            request.setAttribute("selectedCategory", category != null ? category : "All");
            request.setAttribute("itemsInCart", itemsInCart);
            request.getRequestDispatcher("/WEB-INF/customer/menu.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Error loading menu", e);
        }
    }
}