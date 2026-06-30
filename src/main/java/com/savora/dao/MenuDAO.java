package com.savora.dao;

import com.savora.model.MenuItem;
import com.savora.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for the Menu table.
 */
public class MenuDAO {

    public List<MenuItem> findAll() throws SQLException {
        List<MenuItem> items = new ArrayList<>();
        String sql = "SELECT * FROM Menu ORDER BY Category, ItemName";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                items.add(mapRow(rs));
            }
        }
        return items;
    }

    public List<MenuItem> findByCategory(String category) throws SQLException {
        List<MenuItem> items = new ArrayList<>();
        String sql = "SELECT * FROM Menu WHERE Category = ? ORDER BY ItemName";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, category);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    items.add(mapRow(rs));
                }
            }
        }
        return items;
    }

    public MenuItem findById(int menuId) throws SQLException {
        String sql = "SELECT * FROM Menu WHERE MenuID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, menuId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    public int create(MenuItem item) throws SQLException {
        String sql = "INSERT INTO Menu (ItemName, Category, ItemPrice, Description, ImageUrl, IsAvailable) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, item.getItemName());
            ps.setString(2, item.getCategory());
            ps.setBigDecimal(3, item.getItemPrice());
            ps.setString(4, item.getDescription());
            ps.setString(5, item.getImageUrl());
            ps.setBoolean(6, item.isAvailable());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1;
    }

    public boolean update(MenuItem item) throws SQLException {
        String sql = "UPDATE Menu SET ItemName=?, Category=?, ItemPrice=?, Description=?, "
                + "ImageUrl=?, IsAvailable=? WHERE MenuID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, item.getItemName());
            ps.setString(2, item.getCategory());
            ps.setBigDecimal(3, item.getItemPrice());
            ps.setString(4, item.getDescription());
            ps.setString(5, item.getImageUrl());
            ps.setBoolean(6, item.isAvailable());
            ps.setInt(7, item.getMenuId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean delete(int menuId) throws SQLException {
        String sql = "DELETE FROM Menu WHERE MenuID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, menuId);
            return ps.executeUpdate() > 0;
        }
    }

    private MenuItem mapRow(ResultSet rs) throws SQLException {
        MenuItem item = new MenuItem();
        item.setMenuId(rs.getInt("MenuID"));
        item.setItemName(rs.getString("ItemName"));
        item.setCategory(rs.getString("Category"));
        item.setItemPrice(rs.getBigDecimal("ItemPrice"));
        item.setDescription(rs.getString("Description"));
        item.setImageUrl(rs.getString("ImageUrl"));
        item.setAvailable(rs.getBoolean("IsAvailable"));
        return item;
    }
}