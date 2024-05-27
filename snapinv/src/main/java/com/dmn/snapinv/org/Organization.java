package com.dmn.snapinv.org;

import java.sql.Date;
import java.util.ArrayList;

import com.dmn.snapinv.roles.Role;
import com.dmn.snapinv.user.User;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Entity
@Table(name = "organizations")
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
public class Organization {
    @Id
    private Long id;

    private String name;

    private ArrayList<User> employees;

    private ArrayList<Role> roles;

    private Long inventory;

    private Date dateCreated;

    public Organization(String name, ArrayList<User> employees, ArrayList<Role> roles) {
        this.name = name;
        this.employees = employees;
        this.roles = roles;
    }

    public Organization(String name, ArrayList<Role> roles) {
        this.name = name;
        this.roles = roles;
    }

    public Organization(String name) {
        this.name = name;
    }
}
