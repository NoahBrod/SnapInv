package com.dmn.snapinv.inventory;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

@Service
public class ItemService {
    @Autowired
    private ItemRepo itemRepo;
    
    public List<Item> findAllItems() {
        return itemRepo.findAll();
    }

    public List<Item> itemSearch(Specification<Item> spec) {
        return itemRepo.findAll(spec);
    }

    public void save(Item item) {
        Item newItem;
        Specification<Item> spec = Specification.where(null);

        if (item.getName() != null) {
            spec = spec.and((root, query, cb) -> cb.like(root.get("name"), "%" + item.getName() + "%"));
        }

        List<Item> items = itemRepo.findAll(spec);
        if (items.size() > 0) {
            newItem = items.get(0);
            newItem.setQuantity(newItem.getQuantity() + item.getQuantity());
            itemRepo.save(newItem);
            return;
        }

        itemRepo.save(item);
    }

    public boolean delete(Specification<Item> spec) {
        try {
            itemRepo.delete(spec);
            return true;
        } catch (Exception e) {
            System.out.println("Error deleting item");
            e.printStackTrace();
            return false;
        }
    }
}
