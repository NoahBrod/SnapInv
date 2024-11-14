package com.snapinv.snapinv_api.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.snapinv.snapinv_api.entities.Item;

@Repository
public interface ItemRepo extends JpaRepository<Item, Long> {
    
}
