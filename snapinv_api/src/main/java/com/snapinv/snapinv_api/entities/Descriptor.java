package com.snapinv.snapinv_api.entities;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;

@Entity
public class Descriptor {
    @Id
    private Long id;
    private String title;
    private String value;
}
