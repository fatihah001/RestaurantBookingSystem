package com.savora.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Centralised JDBC connection helper for GlassFish + MySQL.
 *
 * Update DB_URL / DB_USER / DB_PASSWORD below to match your local
 * MySQL setup before deploying.
 */
public class DBConnection {

    private static final String DB_URL =
            "jdbc:mysql://localhost:3306/restaurant_booking_system?useSSL=false&serverTimezone=Asia%2FKuala_Lumpur&allowPublicKeyRetrieval=true";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found on classpath.", e);
        }
    }

    private DBConnection() {
        // utility class - prevent instantiation
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }
}