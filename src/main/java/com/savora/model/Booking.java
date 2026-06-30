package com.savora.model;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

/**
 * Model (JavaBean) representing a table booking.
 * Renamed from "Reservation" per the corrected ERD; attributes adjusted
 * (BookingID / BookingDate / BookingTime).
 */
public class Booking implements Serializable {

    private int bookingId;
    private int userId;
    private int tableId;
    private LocalDate bookingDate;
    private LocalTime bookingTime;
    private int noOfPeople;
    private String status; // Confirmed | Completed | Cancelled
    private LocalDateTime createdAt;

    // Convenience fields populated by joined queries (not DB columns)
    private String tableNo;
    private String customerName;

    public Booking() {
    }

    public Booking(int userId, int tableId, LocalDate bookingDate,
                    LocalTime bookingTime, int noOfPeople, String status) {
        this.userId = userId;
        this.tableId = tableId;
        this.bookingDate = bookingDate;
        this.bookingTime = bookingTime;
        this.noOfPeople = noOfPeople;
        this.status = status;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getTableId() {
        return tableId;
    }

    public void setTableId(int tableId) {
        this.tableId = tableId;
    }

    public LocalDate getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(LocalDate bookingDate) {
        this.bookingDate = bookingDate;
    }

    public LocalTime getBookingTime() {
        return bookingTime;
    }

    public void setBookingTime(LocalTime bookingTime) {
        this.bookingTime = bookingTime;
    }

    public int getNoOfPeople() {
        return noOfPeople;
    }

    public void setNoOfPeople(int noOfPeople) {
        this.noOfPeople = noOfPeople;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getTableNo() {
        return tableNo;
    }

    public void setTableNo(String tableNo) {
        this.tableNo = tableNo;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    private Integer orderId;
    private String orderStatus;

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }

   public String getFormattedCreatedAt() {
    if (createdAt == null) return "";
    return createdAt.format(DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a"));
}

    public String getFormattedBookingDate() {
        if (bookingDate == null) return "";
        return bookingDate.format(DateTimeFormatter.ofPattern("dd MMM yyyy"));
    }

    public String getFormattedBookingTime() {
        if (bookingTime == null) return "";
        return bookingTime.format(DateTimeFormatter.ofPattern("hh:mm a"));
    }
}