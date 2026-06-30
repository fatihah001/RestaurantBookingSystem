package com.savora.model;

import java.io.Serializable;

/**
 * Model (JavaBean) representing a dine-in table or booth.
 */
public class RestaurantTable implements Serializable {

    private int tableId;
    private String tableNo;
    private int capacity;
    private String location;     
    private String tableStatus;  

    public RestaurantTable() {
    }

    public RestaurantTable(int tableId, String tableNo, int capacity,
                            String location, String tableStatus) {
        this.tableId = tableId;
        this.tableNo = tableNo;
        this.capacity = capacity;
        this.location = location;
        this.tableStatus = tableStatus;
    }

    public int getTableId() {
        return tableId;
    }

    public void setTableId(int tableId) {
        this.tableId = tableId;
    }

    public String getTableNo() {
        return tableNo;
    }

    public void setTableNo(String tableNo) {
        this.tableNo = tableNo;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getTableStatus() {
        return tableStatus;
    }

    public void setTableStatus(String tableStatus) {
        this.tableStatus = tableStatus;
    }
}