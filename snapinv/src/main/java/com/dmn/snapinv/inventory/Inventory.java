package com.dmn.snapinv.inventory;

import java.util.ArrayList;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity
@Table(name = "inventories")
@Getter
@Setter
@ToString
public class Inventory {
    @Id
    private Long id;

    private ArrayList<Item> items;
}
