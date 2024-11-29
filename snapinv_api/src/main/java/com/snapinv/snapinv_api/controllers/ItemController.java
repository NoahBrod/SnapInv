package com.snapinv.snapinv_api.controllers;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.snapinv.snapinv_api.entities.Item;
import com.snapinv.snapinv_api.services.ItemService;

import java.util.List;
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

    @GetMapping("/items")
    public List<Item> getItems() {
        System.out.println("RETURNING ITEMS");
        return itemService.allItems();
    }
    

    @PostMapping("/additem")
    public String addItem(
        @RequestParam String name,
        @RequestParam(required = false) String description,
        @RequestParam(required = false) String quantity,
        @RequestParam(required = false) String price
    ) {
        System.out.println("---------DUMMY POST TRIGGERED---------");

        Item newItem = new Item();
        newItem.setName(name);

        if (description != "") {
            newItem.setDescription(description);
        }

        newItem.setQuantity(Integer.parseInt(quantity));

        if (price != null) {
            newItem.setPrice(Double.parseDouble(price));
        }

        System.out.println(newItem.toString());

        itemService.addItem(newItem);

        return "Item Received";
    }
    
}
