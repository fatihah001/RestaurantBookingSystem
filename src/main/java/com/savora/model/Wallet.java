package com.savora.model;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * Model (JavaBean) representing a user's e-wallet.
 */
public class Wallet implements Serializable {

    private int walletId;
    private int userId;
    private BigDecimal balance;

    public Wallet() {
    }

    public Wallet(int walletId, int userId, BigDecimal balance) {
        this.walletId = walletId;
        this.userId = userId;
        this.balance = balance;
    }

    public int getWalletId() {
        return walletId;
    }

    public void setWalletId(int walletId) {
        this.walletId = walletId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public BigDecimal getBalance() {
        return balance;
    }

    public void setBalance(BigDecimal balance) {
        this.balance = balance;
    }
}