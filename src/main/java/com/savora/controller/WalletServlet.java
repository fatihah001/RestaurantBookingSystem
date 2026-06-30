package com.savora.controller;

import com.savora.dao.WalletDAO;
import com.savora.model.Wallet;
import com.savora.model.WalletTransaction;
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
 * Controller (Servlet) for the My Wallet module: view balance and
 * transaction history, and top up via online banking or debit card.
 */
@WebServlet(name = "WalletServlet", urlPatterns = {"/wallet", "/wallet/topup"})
public class WalletServlet extends HttpServlet {

    private final WalletDAO walletDAO = new WalletDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        try {
            Wallet wallet = walletDAO.getOrCreateWallet(userId);
            List<WalletTransaction> transactions = walletDAO.getTransactions(wallet.getWalletId());

            request.setAttribute("wallet", wallet);
            request.setAttribute("transactions", transactions);
            request.getRequestDispatcher("/WEB-INF/customer/wallet.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Error loading wallet", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        String amountStr = request.getParameter("amount");
        String method = request.getParameter("topupMethod"); // Online Banking | Debit Card

        try {
            BigDecimal amount = new BigDecimal(amountStr);

            if (amount.compareTo(BigDecimal.ZERO) <= 0) {
                request.setAttribute("error", "Top-up amount must be greater than zero.");
                doGet(request, response);
                return;
            }

            if (method == null || method.trim().isEmpty()) {
                request.setAttribute("error", "Please select a payment method for top up.");
                doGet(request, response);
                return;
            }

            Wallet wallet = walletDAO.getOrCreateWallet(userId);
            String description = "Wallet top-up of RM" + amount.setScale(2) + " via " + method;
            walletDAO.credit(wallet.getWalletId(), amount, "TopUp", description);

            response.sendRedirect(request.getContextPath() + "/wallet?success=true");
        } catch (NumberFormatException | SQLException e) {
            throw new ServletException("Error processing top-up", e);
        }
    }
}