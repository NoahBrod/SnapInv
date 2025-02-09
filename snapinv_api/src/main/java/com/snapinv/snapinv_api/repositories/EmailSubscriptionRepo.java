package com.snapinv.snapinv_api.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.snapinv.snapinv_api.entities.EmailSubscription;

@Repository
public interface EmailSubscriptionRepo extends JpaRepository<EmailSubscription, Long> {
    
}
