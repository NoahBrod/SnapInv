package com.dmn.snapinv.inventory;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface ItemRepo extends JpaRepository<Item, Long>, JpaSpecificationExecutor<Item> {
    // @Query("SELECT u FROM Item u WHERE u.name = ?1")
    // Optional<Item> findItem(String name);
}
