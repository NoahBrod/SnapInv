package com.snapinv.snapinv_api.controllers;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.snapinv.snapinv_api.entities.Item;
import com.snapinv.snapinv_api.services.ItemService;

import java.io.IOException;
import java.util.Base64;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PostMapping;

@RestController
@RequestMapping(value = "/api/v1/item")
public class ItemController {
    @Autowired
    private ItemService itemService;

    @GetMapping("/{id}")
    public Item getItem(@PathVariable Long id) {
        Item item = itemService.getItem(id);
        return item;
    }

    @GetMapping("/items")
    public List<Item> getItems() {
        return itemService.allItems();
    }

    @PostMapping("/additem")
    public String addItem(
            @RequestParam(required = false) MultipartFile image,
            @RequestParam String name,
            @RequestParam(required = false) String code,
            @RequestParam(required = false) String description,
            @RequestParam(required = false) String quantity,
            @RequestParam(required = false) String price) {

        Item newItem = new Item();

        if (image != null) {
            try {
                newItem.setImage(Base64.getEncoder().encodeToString(image.getBytes()));
            } catch (IOException e) {
                e.printStackTrace();
                return "couldn't add image";
            }
        }

        newItem.setName(name);

        if (description != null) {
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

    @PostMapping("/update/{id}")
    public String updateItem(
            @PathVariable Long id,
            @RequestParam(required = false) MultipartFile image,
            @RequestParam(required = false) String name,
            @RequestParam(required = false) String code,
            @RequestParam(required = false) String description,
            @RequestParam(required = false) String quantity,
            @RequestParam(required = false) String price
        ) {
        Item item = itemService.getItem(id);

        if (item == null) {
            return "Could not update item.";
        }

        if (image != null) {
            try {
                item.setImage(Base64.getEncoder().encodeToString(image.getBytes()));
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        
        if (name != null) {
            item.setName(name);
        }

        if (code != null) {
            item.setCode(code);
        }
        
        if (description != null) {
            item.setDescription(description);
        }

        if (quantity != null) {
            item.setQuantity(Integer.parseInt(quantity));
        }

        if (price != null) {
            item.setPrice(Double.parseDouble(price));
        }

        return "Successfully update item.";
    }

    @DeleteMapping("/delete")
    public String deleteItem(@RequestParam String id) {
        itemService.delete(Long.parseLong(id));
        return "successful";
    }

}
