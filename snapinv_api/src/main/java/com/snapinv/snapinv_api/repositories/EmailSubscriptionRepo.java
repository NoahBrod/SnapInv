package com.snapinv.snapinv_api.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.snapinv.snapinv_api.entities.EmailSubscription;
import java.util.Optional;


@Repository
public interface EmailSubscriptionRepo extends JpaRepository<EmailSubscription, Long> {
    Optional<EmailSubscription> findByEmail(String email);

}
