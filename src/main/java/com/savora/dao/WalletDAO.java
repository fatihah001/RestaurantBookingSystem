package com.savora.dao;

import com.savora.model.Wallet;
import com.savora.model.WalletTransaction;
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
 * Data Access Object for the Wallet / WalletTransaction tables.
 */
public class WalletDAO {

    public Wallet getOrCreateWallet(int userId) throws SQLException {
        String findSql = "SELECT * FROM Wallet WHERE UserID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(findSql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }

        String insertSql = "INSERT INTO Wallet (UserID, Balance) VALUES (?, 0)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(insertSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    Wallet w = new Wallet();
                    w.setWalletId(rs.getInt(1));
                    w.setUserId(userId);
                    w.setBalance(BigDecimal.ZERO);
                    return w;
                }
            }
        }
        throw new SQLException("Unable to create wallet for user " + userId);
    }

    /** Adds funds (top-up or refund) to the wallet and logs the transaction. */
    public void credit(int walletId, BigDecimal amount, String type, String description) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String updateSql = "UPDATE Wallet SET Balance = Balance + ? WHERE WalletID = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setBigDecimal(1, amount);
                ps.setInt(2, walletId);
                ps.executeUpdate();
            }

            String logSql = "INSERT INTO WalletTransaction (WalletID, Amount, TransactionType, Description, TransactionDate) "
                    + "VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(logSql)) {
                ps.setInt(1, walletId);
                ps.setBigDecimal(2, amount);
                ps.setString(3, type);
                ps.setString(4, description);
                ps.setTimestamp(5, Timestamp.valueOf(java.time.LocalDateTime.now()));
                ps.executeUpdate();
            }

            conn.commit();
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

    /** Deducts funds (payment) from the wallet and logs the transaction. */
    public boolean debit(int walletId, BigDecimal amount, String description) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String checkSql = "SELECT Balance FROM Wallet WHERE WalletID = ? FOR UPDATE";
            BigDecimal balance;
            try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                ps.setInt(1, walletId);
                try (ResultSet rs = ps.executeQuery()) {
                    rs.next();
                    balance = rs.getBigDecimal("Balance");
                }
            }

            if (balance.compareTo(amount) < 0) {
                conn.rollback();
                return false; // insufficient balance
            }

            String updateSql = "UPDATE Wallet SET Balance = Balance - ? WHERE WalletID = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setBigDecimal(1, amount);
                ps.setInt(2, walletId);
                ps.executeUpdate();
            }

            String logSql = "INSERT INTO WalletTransaction (WalletID, Amount, TransactionType, Description, TransactionDate) "
                    + "VALUES (?, ?, 'Payment', ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(logSql)) {
                ps.setInt(1, walletId);
                ps.setBigDecimal(2, amount);
                ps.setString(3, description);
                ps.setTimestamp(4, Timestamp.valueOf(java.time.LocalDateTime.now()));
                ps.executeUpdate();
            }

            conn.commit();
            return true;
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

    public List<WalletTransaction> getTransactions(int walletId) throws SQLException {
        List<WalletTransaction> list = new ArrayList<>();
        String sql = "SELECT * FROM WalletTransaction WHERE WalletID = ? ORDER BY TransactionDate DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, walletId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    WalletTransaction t = new WalletTransaction();
                    t.setTransactionId(rs.getInt("TransactionID"));
                    t.setWalletId(rs.getInt("WalletID"));
                    t.setAmount(rs.getBigDecimal("Amount"));
                    t.setTransactionType(rs.getString("TransactionType"));
                    Timestamp ts = rs.getTimestamp("TransactionDate");
                    if (ts != null) {
                        t.setTransactionDate(ts.toLocalDateTime());
                    }
                    t.setDescription(rs.getString("Description"));
                    list.add(t);
                }
            }
        }
        return list;
    }

    private Wallet mapRow(ResultSet rs) throws SQLException {
        Wallet w = new Wallet();
        w.setWalletId(rs.getInt("WalletID"));
        w.setUserId(rs.getInt("UserID"));
        w.setBalance(rs.getBigDecimal("Balance"));
        return w;
    }
}