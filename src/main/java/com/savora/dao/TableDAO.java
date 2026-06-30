package com.savora.dao;

import com.savora.model.RestaurantTable;
import com.savora.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TableDAO {

    public List<RestaurantTable> findAll() throws SQLException {
        List<RestaurantTable> tables = new ArrayList<>();
        String sql = "SELECT * FROM RestaurantTable ORDER BY TableID";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                tables.add(mapRow(rs));
            }
        }
        return tables;
    }

    public List<RestaurantTable> findByLocation(String location) throws SQLException {
        List<RestaurantTable> tables = new ArrayList<>();
        String sql = "SELECT * FROM RestaurantTable WHERE Location = ? ORDER BY TableID";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, location);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    tables.add(mapRow(rs));
                }
            }
        }
        return tables;
    }

    public RestaurantTable findById(int tableId) throws SQLException {
        String sql = "SELECT * FROM RestaurantTable WHERE TableID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tableId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    /**
     * Checks whether a table already has a confirmed booking that clashes
     * with the requested date/time (within a 2-hour seating window).
     */
    public boolean isTableBooked(int tableId, String bookingDate, String bookingTime) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Booking "
                + "WHERE TableID = ? AND BookingDate = ? AND Status = 'Confirmed' "
                + "AND ABS(TIME_TO_SEC(TIMEDIFF(BookingTime, ?))) < 7200";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tableId);
            ps.setString(2, bookingDate);
            ps.setString(3, bookingTime);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public int create(RestaurantTable table) throws SQLException {
        String sql = "INSERT INTO RestaurantTable (TableNo, Capacity, Location, TableStatus) "
                + "VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, table.getTableNo());
            ps.setInt(2, table.getCapacity());
            ps.setString(3, table.getLocation());
            ps.setString(4, table.getTableStatus());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1;
    }

    public boolean update(RestaurantTable table) throws SQLException {
        String sql = "UPDATE RestaurantTable SET TableNo=?, Capacity=?, Location=?, TableStatus=? WHERE TableID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, table.getTableNo());
            ps.setInt(2, table.getCapacity());
            ps.setString(3, table.getLocation());
            ps.setString(4, table.getTableStatus());
            ps.setInt(5, table.getTableId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateStatus(int tableId, String status) throws SQLException {
        String sql = "UPDATE RestaurantTable SET TableStatus=? WHERE TableID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, tableId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean delete(int tableId) throws SQLException {
        String sql = "DELETE FROM RestaurantTable WHERE TableID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tableId);
            return ps.executeUpdate() > 0;
        }
    }

    private RestaurantTable mapRow(ResultSet rs) throws SQLException {
        RestaurantTable t = new RestaurantTable();
        t.setTableId(rs.getInt("TableID"));
        t.setTableNo(rs.getString("TableNo"));
        t.setCapacity(rs.getInt("Capacity"));
        t.setLocation(rs.getString("Location"));
        t.setTableStatus(rs.getString("TableStatus"));
        return t;
    }
}