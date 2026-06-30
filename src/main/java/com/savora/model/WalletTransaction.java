package com.savora.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Model (JavaBean) representing a single wallet transaction
 * (top-up, payment, or refund).
 */
public class WalletTransaction implements Serializable {

    private int transactionId;
    private int walletId;
    private BigDecimal amount;
    private String transactionType; 
    private LocalDateTime transactionDate;
    private String description;

    public WalletTransaction() {
    }

    public int getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(int transactionId) {
        this.transactionId = transactionId;
    }

    public int getWalletId() {
        return walletId;
    }

    public void setWalletId(int walletId) {
        this.walletId = walletId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getTransactionType() {
        return transactionType;
    }

    public void setTransactionType(String transactionType) {
        this.transactionType = transactionType;
    }

    public LocalDateTime getTransactionDate() {
        return transactionDate;
    }

    public void setTransactionDate(LocalDateTime transactionDate) {
        this.transactionDate = transactionDate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isCredit() {
        return "TopUp".equals(transactionType) || "Refund".equals(transactionType);
    }

    public String getFormattedTransactionDate() {
        if (transactionDate == null) return "";
        return transactionDate.format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
    }
}