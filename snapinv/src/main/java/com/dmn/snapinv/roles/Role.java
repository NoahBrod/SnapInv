package com.dmn.snapinv.roles;

import java.util.ArrayList;

import jakarta.persistence.Entity;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

// @Entity
@Getter
@Setter
@ToString
public class Role {
    private Long id;

    private ArrayList<String> permissions;

    private Long userId;
}
