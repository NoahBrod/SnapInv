package com.snapinv.snapinv_api.entities;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;

@Entity
public class EmailSignup {
    @Id
    private Long id;
    @Column(nullable = false, unique = true)
    private String email;
}
