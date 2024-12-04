package com.snapinv.snapinv_api.services;

import java.util.List;
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

    public Item getItem(Long id) {
        Optional<Item> item = itemRepo.findById(id);
        if (item.isPresent()) {
            return item.get();
        }
        return null;
    }

    public List<Item> allItems() {
        return itemRepo.findAll();
    }

    public void delete(Long id) {
        itemRepo.deleteById(id);
    }
    
}
