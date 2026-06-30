package com.savora.model;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * Model (JavaBean) representing a menu item.
 * Named MenuItem in Java to avoid colliding with java.awt.Menu.
 */
public class MenuItem implements Serializable {

    private int menuId;
    private String itemName;
    private String category;  
    private BigDecimal itemPrice;
    private String description;
    private String imageUrl;
    private boolean available;

    public MenuItem() {
    }

    public MenuItem(int menuId, String itemName, String category,
                     BigDecimal itemPrice, String description, boolean available) {
        this.menuId = menuId;
        this.itemName = itemName;
        this.category = category;
        this.itemPrice = itemPrice;
        this.description = description;
        this.available = available;
    }

    public int getMenuId() {
        return menuId;
    }

    public void setMenuId(int menuId) {
        this.menuId = menuId;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public BigDecimal getItemPrice() {
        return itemPrice;
    }

    public void setItemPrice(BigDecimal itemPrice) {
        this.itemPrice = itemPrice;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }
}