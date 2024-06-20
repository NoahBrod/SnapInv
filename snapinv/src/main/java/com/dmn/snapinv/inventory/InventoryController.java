package com.dmn.snapinv.inventory;

import java.io.IOException;

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
    public String addBarCode(@RequestParam(required = false) MultipartFile image, @RequestParam(required = false) String code) throws IOException {
        System.out.println(image.isEmpty());
        String result = null;
        if (code != null) {
            System.out.println(code);
            result = code;
        }
        
        if (!image.isEmpty()) {

            /*
             * TO DO:
             * --------------------
             * Move all of the bar code reading to the python server.
             * Python has more libraries for it and is better at it hopefully.
             * Could also try JavaScript in the future.
             */

            result = itemService.findBarCode(image);

            if (result != null)
                itemService.sendBarcode(result);
        }

        System.out.println(result);
        return "redirect:/barcode";
    }
}
