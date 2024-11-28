package com.snapinv.snapinv_api.entities;

import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "items")
public class Item {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private String code;
    private String description;
    private int quantity;
    private double price;
    private Date dateAdded;

    public Item(String name, String code, String description, int quantity, double price, Date dateAdded) {
        this.name = name;
        this.code = code;
        this.description = description;
        this.quantity = quantity;
        this.price = price;
        this.dateAdded = Date.valueOf(LocalDate.now());
    }

    public Item() {
    }

    public Long getId() {
        return this.id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCode() {
        return this.code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getDescription() {
        return this.description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getQuantity() {
        return this.quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPrice() {
        return this.price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public Date getDateAdded() {
        return this.dateAdded;
    }

    public void setDateAdded(Date dateAdded) {
        this.dateAdded = dateAdded;
    }

    @Override
    public String toString() {
        return "{" +
            " id='" + getId() + "'" +
            ", name='" + getName() + "'" +
            ", code='" + getCode() + "'" +
            ", description='" + getDescription() + "'" +
            ", quantity='" + getQuantity() + "'" +
            ", price='" + getPrice() + "'" +
            ", dateAdded='" + getDateAdded() + "'" +
            "}";
    }

}
