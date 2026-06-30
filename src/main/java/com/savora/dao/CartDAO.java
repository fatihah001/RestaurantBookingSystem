package com.savora.dao;

import com.savora.model.CartItem;
import com.savora.util.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for the Cart / Cart_Menu tables.
 * Ensures every user has exactly one active cart row.
 */
public class CartDAO {

    /** Returns the user's CartID, creating a new cart row if one doesn't exist yet. */
    public int getOrCreateCartId(int userId) throws SQLException {
        String findSql = "SELECT CartID FROM Cart WHERE UserID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(findSql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("CartID");
                }
            }
        }

        String insertSql = "INSERT INTO Cart (UserID, TotalPrice) VALUES (?, 0)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(insertSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        throw new SQLException("Unable to create cart for user " + userId);
    }

    public List<CartItem> getCartItems(int cartId) throws SQLException {
        List<CartItem> items = new ArrayList<>();
        String sql = "SELECT cm.*, m.ItemName, m.Category, m.ImageUrl FROM Cart_Menu cm "
                + "JOIN Menu m ON cm.MenuID = m.MenuID WHERE cm.CartID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartItem item = new CartItem();
                    item.setCartId(rs.getInt("CartID"));
                    item.setMenuId(rs.getInt("MenuID"));
                    item.setItemName(rs.getString("ItemName"));
                    item.setCategory(rs.getString("Category"));
                    item.setImageUrl(rs.getString("ImageUrl"));
                    item.setQuantity(rs.getInt("Quantity"));
                    item.setDiningType(rs.getString("DiningType"));
                    item.setTemperature(rs.getString("Temperature"));
                    item.setSubtotal(rs.getBigDecimal("Subtotal"));
                    item.setItemPrice(rs.getBigDecimal("Subtotal")
                            .divide(new BigDecimal(rs.getInt("Quantity")), 2, java.math.RoundingMode.HALF_UP));
                    items.add(item);
                }
            }
        }
        return items;
    }

    /** Adds an item, or increments quantity if it's already in the cart. */
    public void addOrUpdateItem(int cartId, int menuId, int quantity, String diningType, String temperature,
                                 BigDecimal unitPrice) throws SQLException {
        String checkSql = "SELECT Quantity FROM Cart_Menu WHERE CartID = ? AND MenuID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(checkSql)) {
            ps.setInt(1, cartId);
            ps.setInt(2, menuId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int newQty = rs.getInt("Quantity") + quantity;
                    updateItemQuantity(cartId, menuId, newQty, diningType, temperature, unitPrice);
                    return;
                }
            }
        }

        String insertSql = "INSERT INTO Cart_Menu (CartID, MenuID, Quantity, DiningType, Temperature, Subtotal) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(insertSql)) {
            ps.setInt(1, cartId);
            ps.setInt(2, menuId);
            ps.setInt(3, quantity);
            ps.setString(4, diningType);
            if (temperature != null) {
                ps.setString(5, temperature);
            } else {
                ps.setNull(5, java.sql.Types.VARCHAR);
            }
            ps.setBigDecimal(6, unitPrice.multiply(new BigDecimal(quantity)));
            ps.executeUpdate();
        }
        recalculateCartTotal(cartId);
    }

    public void updateItemQuantity(int cartId, int menuId, int quantity, String diningType, String temperature,
                                    BigDecimal unitPrice) throws SQLException {
        if (quantity <= 0) {
            removeItem(cartId, menuId);
            return;
        }
        String sql = "UPDATE Cart_Menu SET Quantity = ?, DiningType = ?, Temperature = ?, Subtotal = ? "
                + "WHERE CartID = ? AND MenuID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setString(2, diningType);
            if (temperature != null) {
                ps.setString(3, temperature);
            } else {
                ps.setNull(3, java.sql.Types.VARCHAR);
            }
            ps.setBigDecimal(4, unitPrice.multiply(new BigDecimal(quantity)));
            ps.setInt(5, cartId);
            ps.setInt(6, menuId);
            ps.executeUpdate();
        }
        recalculateCartTotal(cartId);
    }

    public void removeItem(int cartId, int menuId) throws SQLException {
        String sql = "DELETE FROM Cart_Menu WHERE CartID = ? AND MenuID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            ps.setInt(2, menuId);
            ps.executeUpdate();
        }
        recalculateCartTotal(cartId);
    }

    public void clearCart(int cartId) throws SQLException {
        String sql = "DELETE FROM Cart_Menu WHERE CartID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            ps.executeUpdate();
        }
        recalculateCartTotal(cartId);
    }

    public BigDecimal getCartTotal(int cartId) throws SQLException {
        String sql = "SELECT TotalPrice FROM Cart WHERE CartID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("TotalPrice");
                }
            }
        }
        return BigDecimal.ZERO;
    }

    private void recalculateCartTotal(int cartId) throws SQLException {
        String sumSql = "SELECT COALESCE(SUM(Subtotal), 0) AS Total FROM Cart_Menu WHERE CartID = ?";
        BigDecimal total = BigDecimal.ZERO;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sumSql)) {
            ps.setInt(1, cartId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    total = rs.getBigDecimal("Total");
                }
            }
        }
        String updateSql = "UPDATE Cart SET TotalPrice = ? WHERE CartID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(updateSql)) {
            ps.setBigDecimal(1, total);
            ps.setInt(2, cartId);
            ps.executeUpdate();
        }
    }
}