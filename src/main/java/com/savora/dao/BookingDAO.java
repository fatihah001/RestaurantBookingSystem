package com.savora.dao;

import com.savora.model.Booking;
import com.savora.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for the Booking table
 * (renamed from Reservation per the corrected ERD).
 */
public class BookingDAO {

    public int create(Booking booking) throws SQLException {
        String sql = "INSERT INTO Booking (UserID, TableID, BookingDate, BookingTime, NoOfPeople, Status) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, booking.getUserId());
            ps.setInt(2, booking.getTableId());
            ps.setObject(3, booking.getBookingDate());
            ps.setObject(4, booking.getBookingTime());
            ps.setInt(5, booking.getNoOfPeople());
            ps.setString(6, booking.getStatus());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1;
    }
    
    public int markPastBookingsCompleted() throws SQLException {
        String sql = "UPDATE Booking SET Status = 'Completed' "
                + "WHERE Status = 'Confirmed' "
                + "AND (BookingDate < CURDATE() OR (BookingDate = CURDATE() AND BookingTime < CURTIME()))";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            return ps.executeUpdate();
        }
    }

    public Booking findById(int bookingId) throws SQLException {
        String sql = "SELECT b.*, t.TableNo, u.Name AS CustomerName FROM Booking b "
                + "JOIN RestaurantTable t ON b.TableID = t.TableID "
                + "JOIN User u ON b.UserID = u.UserID "
                + "WHERE b.BookingID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    public List<Booking> findByUserId(int userId) throws SQLException {
        List<Booking> bookings = new ArrayList<>();

        String sql =
                "SELECT b.*, t.TableNo, u.Name AS CustomerName, " +
                "o.OrderID, o.OrderStatus " +
                "FROM Booking b " +
                "JOIN RestaurantTable t ON b.TableID = t.TableID " +
                "JOIN User u ON b.UserID = u.UserID " +
                "LEFT JOIN Order_ o ON b.BookingID = o.BookingID " +
                "WHERE b.UserID = ? " +
                "ORDER BY b.BookingDate DESC, b.BookingTime DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapRow(rs));
                }
            }
        }

        return bookings;
    }

    public List<Booking> findUpcomingByUserId(int userId) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, t.TableNo, u.Name AS CustomerName FROM Booking b "
                + "JOIN RestaurantTable t ON b.TableID = t.TableID "
                + "JOIN User u ON b.UserID = u.UserID "
                + "WHERE b.UserID = ? AND b.Status = 'Confirmed' "
                + "AND (b.BookingDate > CURDATE() OR (b.BookingDate = CURDATE() AND b.BookingTime >= CURTIME())) "
                + "ORDER BY b.BookingDate ASC, b.BookingTime ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapRow(rs));
                }
            }
        }
        return bookings;
    }

    public List<Booking> findAll() throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, t.TableNo, u.Name AS CustomerName FROM Booking b "
                + "JOIN RestaurantTable t ON b.TableID = t.TableID "
                + "JOIN User u ON b.UserID = u.UserID "
                + "ORDER BY b.BookingDate DESC, b.BookingTime DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                bookings.add(mapRow(rs));
            }
        }
        return bookings;
    }

    public boolean updateStatus(int bookingId, String status) throws SQLException {
        String sql = "UPDATE Booking SET Status = ? WHERE BookingID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean delete(int bookingId) throws SQLException {
        String sql = "DELETE FROM Booking WHERE BookingID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            return ps.executeUpdate() > 0;
        }
    }

    /** Counts confirmed/upcoming bookings for dashboard stats. */
    public int countByUserAndStatus(int userId, String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Booking WHERE UserID = ? AND Status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public int countAllBookings() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Booking";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public java.util.Map<String, Integer> getBookingStatusStats() throws SQLException {
        java.util.Map<String, Integer> stats = new java.util.HashMap<>();
        String sql = "SELECT Status, COUNT(*) AS cnt FROM Booking GROUP BY Status";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                stats.put(rs.getString("Status"), rs.getInt("cnt"));
            }
        }
        return stats;
    }


    private Booking mapRow(ResultSet rs) throws SQLException {

        Booking b = new Booking();

        b.setBookingId(rs.getInt("BookingID"));
        b.setUserId(rs.getInt("UserID"));
        b.setTableId(rs.getInt("TableID"));

        b.setBookingDate(rs.getDate("BookingDate").toLocalDate());
        b.setBookingTime(rs.getTime("BookingTime").toLocalTime());

        b.setNoOfPeople(rs.getInt("NoOfPeople"));
        b.setStatus(rs.getString("Status"));

        Timestamp ts = rs.getTimestamp("CreatedAt");
        if (ts != null) {
            b.setCreatedAt(ts.toLocalDateTime());
        }

        b.setTableNo(rs.getString("TableNo"));
        b.setCustomerName(rs.getString("CustomerName"));

        // OrderID and OrderStatus are only present in queries that JOIN Order_
        try {
            int orderId = rs.getInt("OrderID");
            if (!rs.wasNull()) {
                b.setOrderId(orderId);
            }
            b.setOrderStatus(rs.getString("OrderStatus"));
        } catch (SQLException ignored) {
        }

        return b;
    }
}