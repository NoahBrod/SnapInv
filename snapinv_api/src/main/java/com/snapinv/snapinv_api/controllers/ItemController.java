package com.snapinv.snapinv_api.controllers;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.snapinv.snapinv_api.entities.Item;
import com.snapinv.snapinv_api.services.ItemService;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;



@RestController
@RequestMapping(value = "/api/v1/item")
public class ItemController {
    @Autowired
    private ItemService itemService;

    @GetMapping("/{id}")
    public Item getItem(@RequestParam Long id) {
        Optional<Item> item = itemService.getItem(id);
        return item.isPresent() ? item.get() : null;
    }
    
    @PostMapping("/additem")
    public String addItem(@RequestBody Item item) {
        itemService.addItem(item);
        return "Item Processed";
    }
    
}
