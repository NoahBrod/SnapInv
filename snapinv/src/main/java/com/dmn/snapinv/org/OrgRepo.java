package com.dmn.snapinv.org;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface OrgRepo extends JpaRepository<Organization, Long> {
    
}
