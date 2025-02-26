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

    /**
     * Saves new item to databse.
     * 
     * @param item Item to save.
     */
    public void addItem(Item item) {
        itemRepo.save(item);
    }

    /**
     * Get item by its id.
     * 
     * @param id ID of the specific item.
     * 
     * @return Item if found with with id.
     */
    public Item getItem(Long id) {
        Optional<Item> item = itemRepo.findById(id);
        if (item.isPresent()) {
            return item.get();
        }
        return null;
    }

    /**
     * Returns a list of all items in the databse.
     * 
     * @return List of items.
     */
    public List<Item> allItems() {
        return itemRepo.findAll();
    }

    /**
     * Delete item by its id.
     * 
     * @param id ID of the specific item.
     */
    public void delete(Long id) {
        itemRepo.deleteById(id);
    }

    /**
     * Updates item in database.
     * 
     * @param item Updated item.
     */
    public void updateItem(Item item) {
        itemRepo.save(item);
    }
    
}
