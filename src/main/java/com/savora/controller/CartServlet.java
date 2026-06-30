package com.savora.controller;

import com.savora.dao.CartDAO;
import com.savora.dao.MenuDAO;
import com.savora.model.CartItem;
import com.savora.model.MenuItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

/**
 * Controller (Servlet) for cart management (Step 2 of the booking flow).
 * Handles add / update-quantity / remove actions plus the cart view.
 */
@WebServlet(name = "CartServlet", urlPatterns = {"/cart", "/cart/*"})
public class CartServlet extends HttpServlet {

    private final CartDAO cartDAO = new CartDAO();
    private final MenuDAO menuDAO = new MenuDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        try {
            int cartId = cartDAO.getOrCreateCartId(userId);
            List<CartItem> items = cartDAO.getCartItems(cartId);
            BigDecimal total = cartDAO.getCartTotal(cartId);

            request.setAttribute("cartItems", items);
            request.setAttribute("cartTotal", total);
            request.setAttribute("itemCount", items.stream().mapToInt(CartItem::getQuantity).sum());
            request.getRequestDispatcher("/WEB-INF/customer/cart.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Error loading cart", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String action = request.getParameter("action");

        try {
            int cartId = cartDAO.getOrCreateCartId(userId);

            switch (action == null ? "" : action) {
                case "add": {
                    int menuId = Integer.parseInt(request.getParameter("menuId"));
                    int quantity = Integer.parseInt(request.getParameter("quantity"));
                    String diningType = request.getParameter("diningType");
                    if (diningType == null) {
                        diningType = "Dine In";
                    }
                    String temperature = request.getParameter("temperature"); // null for non-beverages
                    if (temperature != null && temperature.trim().isEmpty()) {
                        temperature = null; // Temperature column is an ENUM; '' is not a valid value
                    }
                    MenuItem item = menuDAO.findById(menuId);
                    if (item != null) {
                        cartDAO.addOrUpdateItem(cartId, menuId, quantity, diningType, temperature, item.getItemPrice());
                    }
                    break;
                }
                case "updateQuantity": {
                    int menuId = Integer.parseInt(request.getParameter("menuId"));
                    int quantity = Integer.parseInt(request.getParameter("quantity"));
                    String diningType = request.getParameter("diningType");
                    String temperature = request.getParameter("temperature");
                    if (temperature != null && temperature.trim().isEmpty()) {
                        temperature = null; // hidden field in cart.jsp renders null as "" for non-beverage items
                    }
                    MenuItem item = menuDAO.findById(menuId);
                    if (item != null) {
                        cartDAO.updateItemQuantity(cartId, menuId, quantity, diningType, temperature, item.getItemPrice());
                    }
                    break;
                }
                case "remove": {
                    int menuId = Integer.parseInt(request.getParameter("menuId"));
                    cartDAO.removeItem(cartId, menuId);
                    break;
                }
                case "clear": {
                    cartDAO.clearCart(cartId);
                    break;
                }
                default:
                    break;
            }
            List<CartItem> updatedItems = cartDAO.getCartItems(cartId);

            int totalItems = 0;
            for (CartItem i : updatedItems) {
                totalItems += i.getQuantity();
            }

            session.setAttribute("itemsInCart", totalItems);
            String redirectTo = request.getParameter("redirect");
            if (redirectTo == null) {
                redirectTo = "cart";
            }
            response.sendRedirect(request.getContextPath() + "/" + redirectTo);
        } catch (SQLException | NumberFormatException e) {
            throw new ServletException("Error updating cart", e);
        }
    }
}