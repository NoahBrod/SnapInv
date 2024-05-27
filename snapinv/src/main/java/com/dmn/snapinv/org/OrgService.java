package com.dmn.snapinv.org;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class OrgService {
    @Autowired
    private OrgRepo orgRepo;

    public void createOrg(Organization org) {
        orgRepo.save(org);
    }

    public Organization findOrgById(Long id) {
        Optional<Organization> org = orgRepo.findById(id);
        if (org.isPresent())
            return org.get();
        return null;
    }
}
