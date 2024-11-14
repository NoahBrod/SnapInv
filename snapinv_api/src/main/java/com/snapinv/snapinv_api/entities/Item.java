package com.snapinv.snapinv_api.entities;

import java.sql.Date;
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
    private Long itemId;
    private String name;
    private ArrayList<Descriptor> descriptors;
    private Date dateAdded;

    public Item(String name, ArrayList<Descriptor> descriptors, Date dateAdded) {
        this.name = name;
        this.descriptors = descriptors;
        this.dateAdded = dateAdded;
    }

    public Item() {
    }

    public String getName() {
        return this.name;
    }
    public void setName(String name) {
        this.name = name;
    }

    public ArrayList<Descriptor> getDescriptors() {
        return this.descriptors;
    }
    public void setDescriptors(ArrayList<Descriptor> descriptors) {
        this.descriptors = descriptors;
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
                " name='" + getName() + "'" +
                ", descriptors='" + getDescriptors() + "'" +
                ", dateAdded='" + getDateAdded() + "'" +
                "}";
    }
}
