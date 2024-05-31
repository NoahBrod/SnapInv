package com.dmn.snapinv.inventory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;


@Controller
public class InventoryController {
    @Autowired
    private ItemService itemService;

    @GetMapping("/add_item")
    public String addItemPage(@RequestParam(required = false) String error, Model model) {
        model.addAttribute("error", error);
        model.addAttribute("item", new Item());

        return "/item/add_item";
    }
    
    @PostMapping("/add_item")
    public String addItemPage(Item item) {
        System.out.println(item.toString());
        
        itemService.save(item);

        return "redirect:/";
    }

    @GetMapping("/items")
    public String getItems(Model model) {
        model.addAttribute("items", itemService.findAllItems());
        return "/item/items";
    }
    
    @GetMapping("/barcode")
    public String barCodeUpload() {
        return "/item/barcode_add";
    }

    @PostMapping("/barcode")
    public String addBarCode(@RequestParam MultipartFile image) {
        System.out.println(image);
        String result = itemService.findBarCode(image);
        System.out.println(result);
        return "/item/barcode_add";
    }
}
