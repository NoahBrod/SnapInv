package com.snapinv.snapinv_api.controllers;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.snapinv.snapinv_api.entities.Item;
import com.snapinv.snapinv_api.services.ItemService;

import java.io.IOException;
import java.util.Base64;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
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
        return itemService.allItems();
    }
    

    @PostMapping("/additem")
    public String addItem(
        @RequestParam(required = false) String image,
        @RequestParam String name,
        @RequestParam(required = false) String code,
        @RequestParam(required = false) String description,
        @RequestParam(required = false) String quantity,
        @RequestParam(required = false) String price
    ) {

        Item newItem = new Item();

        if (image != null) {
            // try {
            //     System.out.println("SIZE OF IMAGE: " + image.getSize());
            //     newItem.setImage(Base64.getEncoder().encodeToString(image.getBytes()));
            // } catch (IOException e) {
            //     e.printStackTrace();
            //     return "couldn't add image";
            // }
            newItem.setImage(image);
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

    @DeleteMapping("/delete")
    public String deleteItem(@RequestParam String id) {
        itemService.delete(Long.parseLong(id));
        return "successful";
    }
    
}
