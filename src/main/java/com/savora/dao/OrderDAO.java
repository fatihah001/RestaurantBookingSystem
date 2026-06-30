package com.savora.dao;

import com.savora.model.CartItem;
import com.savora.model.Order;
import com.savora.util.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for the Order_ / Order_Menu tables.
 * Order_ is suffixed with an underscore to avoid the reserved SQL keyword.
 */
public class OrderDAO {

    /**
     * Places an order from a list of cart items inside a single transaction.
     * Returns the generated OrderID.
     */
    public int placeOrder(int userId, Integer bookingId, List<CartItem> items,
                           BigDecimal subtotal, BigDecimal tax, BigDecimal total,
                           String paymentMethod) throws SQLException {
        return placeOrder(userId, bookingId, items, subtotal, tax, total, paymentMethod, null);
    }

    public int placeOrder(int userId, Integer bookingId, List<CartItem> items,
                           BigDecimal subtotal, BigDecimal tax, BigDecimal total,
                           String paymentMethod, java.sql.Timestamp customOrderDate) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String orderSql = "INSERT INTO Order_ (UserID, BookingID, OrderDate, Subtotal, Tax, TotalAmount, OrderStatus) "
                    + "VALUES (?, ?, ?, ?, ?, ?, 'Confirmed')";
            int orderId;
            try (PreparedStatement ps = conn.prepareStatement(orderSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, userId);
                if (bookingId != null) {
                    ps.setInt(2, bookingId);
                } else {
                    ps.setNull(2, java.sql.Types.INTEGER);
                }
                if (customOrderDate != null) {
                    ps.setTimestamp(3, customOrderDate);
                } else {
                    ps.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
                }
                ps.setBigDecimal(4, subtotal);
                ps.setBigDecimal(5, tax);
                ps.setBigDecimal(6, total);
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    rs.next();
                    orderId = rs.getInt(1);
                }
            }

            String itemSql = "INSERT INTO Order_Menu (OrderID, MenuID, Quantity, DiningType, Temperature, ItemPrice) "
                    + "VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(itemSql)) {
                for (CartItem item : items) {
                    ps.setInt(1, orderId);
                    ps.setInt(2, item.getMenuId());
                    ps.setInt(3, item.getQuantity());
                    ps.setString(4, item.getDiningType());
                    if (item.getTemperature() != null) {
                        ps.setString(5, item.getTemperature());
                    } else {
                        ps.setNull(5, java.sql.Types.VARCHAR);
                    }
                    ps.setBigDecimal(6, item.getItemPrice());
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            String paymentSql = "INSERT INTO Payment (OrderID, PaymentMethod, Amount, PaymentStatus) "
                    + "VALUES (?, ?, ?, 'Paid')";
            try (PreparedStatement ps = conn.prepareStatement(paymentSql)) {
                ps.setInt(1, orderId);
                ps.setString(2, paymentMethod);
                ps.setBigDecimal(3, total);
                ps.executeUpdate();
            }

            conn.commit();
            return orderId;
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    public Order findById(int orderId) throws SQLException {
        String sql = "SELECT o.*, u.Name AS CustomerName, p.PaymentMethod, b.TableID, t.TableNo FROM Order_ o "
                + "JOIN User u ON o.UserID = u.UserID "
                + "LEFT JOIN Payment p ON p.OrderID = o.OrderID "
                + "LEFT JOIN Booking b ON o.BookingID = b.BookingID "
                + "LEFT JOIN RestaurantTable t ON b.TableID = t.TableID "
                + "WHERE o.OrderID = ?";
        Order order = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    order = mapRow(rs);
                }
            }
        }
        if (order != null) {
            order.setItems(findOrderItems(orderId));
        }
        return order;
    }

    public List<Order> findByUserId(int userId) throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.Name AS CustomerName, p.PaymentMethod, b.TableID, t.TableNo FROM Order_ o "
                + "JOIN User u ON o.UserID = u.UserID "
                + "LEFT JOIN Payment p ON p.OrderID = o.OrderID "
                + "LEFT JOIN Booking b ON o.BookingID = b.BookingID "
                + "LEFT JOIN RestaurantTable t ON b.TableID = t.TableID "
                + "WHERE o.UserID = ? ORDER BY o.OrderDate DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapRow(rs));
                }
            }
        }
        return orders;
    }

    public List<CartItem> findOrderItems(int orderId) throws SQLException {
        List<CartItem> items = new ArrayList<>();
        String sql = "SELECT om.*, m.ItemName, m.Category FROM Order_Menu om "
                + "JOIN Menu m ON om.MenuID = m.MenuID WHERE om.OrderID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartItem item = new CartItem();
                    item.setMenuId(rs.getInt("MenuID"));
                    item.setItemName(rs.getString("ItemName"));
                    item.setCategory(rs.getString("Category"));
                    item.setQuantity(rs.getInt("Quantity"));
                    item.setDiningType(rs.getString("DiningType"));
                    item.setTemperature(rs.getString("Temperature"));
                    item.setItemPrice(rs.getBigDecimal("ItemPrice"));
                    item.setSubtotal(rs.getBigDecimal("ItemPrice")
                            .multiply(new BigDecimal(rs.getInt("Quantity"))));
                    items.add(item);
                }
            }
        }
        return items;
    }

    public boolean updateStatus(int orderId, String status) throws SQLException {
        String sql = "UPDATE Order_ SET OrderStatus = ? WHERE OrderID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        }
    }

    public BigDecimal getTotalSpentByUser(int userId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(TotalAmount), 0) AS Total FROM Order_ "
                + "WHERE UserID = ? AND OrderStatus != 'Cancelled'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("Total");
                }
            }
        }
        return BigDecimal.ZERO;
    }

    public int countAllOrders() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Order_ WHERE OrderStatus != 'Cancelled'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public BigDecimal getTotalSales() throws SQLException {
        String sql = "SELECT COALESCE(SUM(TotalAmount), 0) AS Total FROM Order_ WHERE OrderStatus != 'Cancelled'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getBigDecimal("Total");
            }
        }
        return BigDecimal.ZERO;
    }


    public List<Order> findOrdersByDate(String date) throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.Name AS CustomerName, p.PaymentMethod, b.TableID, t.TableNo FROM Order_ o "
                + "JOIN User u ON o.UserID = u.UserID "
                + "LEFT JOIN Payment p ON p.OrderID = o.OrderID "
                + "LEFT JOIN Booking b ON o.BookingID = b.BookingID "
                + "LEFT JOIN RestaurantTable t ON b.TableID = t.TableID "
                + "WHERE DATE(o.OrderDate) = ? "
                + "ORDER BY o.OrderDate DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, date);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapRow(rs));
                }
            }
        }
        for (Order o : orders) {
            o.setItems(findOrderItems(o.getOrderId()));
        }
        return orders;
    }
 
    public List<Order> findAllOrders() throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.Name AS CustomerName, p.PaymentMethod, b.TableID, t.TableNo FROM Order_ o "
                + "JOIN User u ON o.UserID = u.UserID "
                + "LEFT JOIN Payment p ON p.OrderID = o.OrderID "
                + "LEFT JOIN Booking b ON o.BookingID = b.BookingID "
                + "LEFT JOIN RestaurantTable t ON b.TableID = t.TableID "
                + "ORDER BY o.OrderDate DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                orders.add(mapRow(rs));
            }
        }
        for (Order o : orders) {
            o.setItems(findOrderItems(o.getOrderId()));
        }
        return orders;
    }

    public List<Order> findTodaysOrders() throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.Name AS CustomerName, p.PaymentMethod, b.TableID, t.TableNo FROM Order_ o "
                + "JOIN User u ON o.UserID = u.UserID "
                + "LEFT JOIN Payment p ON p.OrderID = o.OrderID "
                + "LEFT JOIN Booking b ON o.BookingID = b.BookingID "
                + "LEFT JOIN RestaurantTable t ON b.TableID = t.TableID "
                + "WHERE DATE(o.OrderDate) = CURDATE() "
                + "ORDER BY o.OrderDate DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                orders.add(mapRow(rs));
            }
        }
        for (Order o : orders) {
            o.setItems(findOrderItems(o.getOrderId()));
        }
        return orders;
    }

    public java.util.Map<String, Integer> getOrderCountByStatusToday() throws SQLException {
        java.util.Map<String, Integer> counts = new java.util.HashMap<>();
        String sql = "SELECT OrderStatus, COUNT(*) AS cnt FROM Order_ "
                + "WHERE DATE(OrderDate) = CURDATE() GROUP BY OrderStatus";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                counts.put(rs.getString("OrderStatus"), rs.getInt("cnt"));
            }
        }
        return counts;
    }

    public java.util.Map<String, Integer> getOrderCountByCategoryToday() throws SQLException {
        java.util.Map<String, Integer> counts = new java.util.HashMap<>();
        String sql = "SELECT m.Category, SUM(om.Quantity) AS qty FROM Order_Menu om "
                + "JOIN Menu m ON om.MenuID = m.MenuID "
                + "JOIN Order_ o ON om.OrderID = o.OrderID "
                + "WHERE DATE(o.OrderDate) = CURDATE() AND o.OrderStatus != 'Cancelled' "
                + "GROUP BY m.Category";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                counts.put(rs.getString("Category"), rs.getInt("qty"));
            }
        }
        return counts;
    }

    public java.util.Map<String, Integer> getOrderCountByStatusLast7Days() throws SQLException {
        java.util.Map<String, Integer> counts = new java.util.HashMap<>();
        String sql = "SELECT OrderStatus, COUNT(*) AS cnt FROM Order_ "
                + "WHERE OrderDate >= DATE_SUB(CURDATE(), INTERVAL 6 DAY) GROUP BY OrderStatus";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                counts.put(rs.getString("OrderStatus"), rs.getInt("cnt"));
            }
        }
        return counts;
    }

    public java.util.Map<String, Integer> getOrderCountByCategoryLast7Days() throws SQLException {
        java.util.Map<String, Integer> counts = new java.util.HashMap<>();
        String sql = "SELECT m.Category, SUM(om.Quantity) AS qty FROM Order_Menu om "
                + "JOIN Menu m ON om.MenuID = m.MenuID "
                + "JOIN Order_ o ON om.OrderID = o.OrderID "
                + "WHERE o.OrderDate >= DATE_SUB(CURDATE(), INTERVAL 6 DAY) AND o.OrderStatus != 'Cancelled' "
                + "GROUP BY m.Category";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                counts.put(rs.getString("Category"), rs.getInt("qty"));
            }
        }
        return counts;
    }

    public java.util.List<java.util.Map<String, Object>> getSalesDataLast7Days() throws SQLException {
        java.util.List<java.util.Map<String, Object>> data = new java.util.ArrayList<>();
        String sql = "SELECT DATE(OrderDate) AS odate, SUM(TotalAmount) AS total FROM Order_ "
                + "WHERE OrderDate >= DATE_SUB(CURDATE(), INTERVAL 6 DAY) AND OrderStatus != 'Cancelled' "
                + "GROUP BY DATE(OrderDate) ORDER BY odate ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                java.util.Map<String, Object> row = new java.util.HashMap<>();
                row.put("date", rs.getDate("odate").toString());
                row.put("sales", rs.getBigDecimal("total"));
                data.add(row);
            }
        }
        return data;
    }

    private Order mapRow(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setOrderId(rs.getInt("OrderID"));
        o.setUserId(rs.getInt("UserID"));
        int bookingId = rs.getInt("BookingID");
        o.setBookingId(rs.wasNull() ? null : bookingId);
        Timestamp ts = rs.getTimestamp("OrderDate");
        if (ts != null) {
            o.setOrderDate(ts.toLocalDateTime());
        }
        o.setSubtotal(rs.getBigDecimal("Subtotal"));
        o.setTax(rs.getBigDecimal("Tax"));
        o.setTotalAmount(rs.getBigDecimal("TotalAmount"));
        o.setOrderStatus(rs.getString("OrderStatus"));
        o.setPaymentMethod(rs.getString("PaymentMethod"));
        o.setCustomerName(rs.getString("CustomerName"));
        
        try {
            o.setTableNo(rs.getString("TableNo"));
        } catch (SQLException ignored) {}
        try {
            int tableId = rs.getInt("TableID");
            o.setTableId(rs.wasNull() ? null : tableId);
        } catch (SQLException ignored) {}
        
        return o;
    }
}