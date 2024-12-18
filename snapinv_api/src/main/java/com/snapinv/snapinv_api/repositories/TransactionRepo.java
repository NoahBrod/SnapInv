package com.snapinv.snapinv_api.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.snapinv.snapinv_api.entities.Transaction;

@Repository
public interface TransactionRepo extends JpaRepository<Transaction, Long> {
    
}
