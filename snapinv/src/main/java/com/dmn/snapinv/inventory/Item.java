package com.dmn.snapinv.inventory;

import jakarta.persistence.Entity;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity
@Getter
@Setter
@ToString
public class Item {
    private Long id;

    private String name;

    private int quantity;
}
