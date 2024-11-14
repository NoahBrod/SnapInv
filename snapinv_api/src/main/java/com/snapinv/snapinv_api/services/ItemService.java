package com.snapinv.snapinv_api.services;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.snapinv.snapinv_api.entities.Item;
import com.snapinv.snapinv_api.repositories.ItemRepo;

@Service
public class ItemService {
    @Autowired
    private ItemRepo itemRepo;

    public void addItem(Item item) {
        itemRepo.save(item);
    }

    public Optional<Item> getItem(Long id) {
        return itemRepo.findById(id);
    }
    
}
