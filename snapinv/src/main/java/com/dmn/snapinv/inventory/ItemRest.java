package com.dmn.snapinv.inventory;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;



@RestController
@RequestMapping("/api/v1/item")
public class ItemRest {
    @Autowired
    private ItemService itemService;

    @GetMapping("/get")
    public List<Item> getItem(@RequestParam String item) {
        Specification<Item> spec = Specification.where(null);

        spec = spec.and((root, query, cb) -> cb.like(root.get("name"), "%" + item + "%"));

        return itemService.itemSearch(spec);
    }
    

    @PostMapping("/add")
    public Item addItem(@RequestBody Item item) {
        System.out.println(item);

        // itemService.save(item);
        
        return item;
    }
    
    @DeleteMapping("/delete")
    public boolean deleteItem(@RequestParam(required = false)Long id, @RequestParam(required = false) String item) {
        Specification<Item> spec = Specification.where(null);
        
        if (id != null) {
            spec = spec.and((root, query, cb) -> cb.equal(root.get("id"), id));
        }

        if (item != null) {
            spec = spec.and((root, query, cb) -> cb.like(root.get("name"), "%" + item + "%"));
        }

        return itemService.delete(spec);
    }

    @PostMapping("/sendData")
    public String sendData(@RequestBody Map<String, Object> data) throws IOException {
        //TODO: process POST request
        return "entity";
    }
    
}
