package com.dmn.snapinv.inventory;

import java.io.IOException;
import java.util.EnumMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.BinaryBitmap;
import com.google.zxing.DecodeHintType;
import com.google.zxing.MultiFormatReader;
import com.google.zxing.NotFoundException;
import com.google.zxing.Result;
import com.google.zxing.ResultPoint;
import com.google.zxing.client.j2se.BufferedImageLuminanceSource;
import com.google.zxing.common.HybridBinarizer;

@Service
public class ItemService {
    @Autowired
    private ItemRepo itemRepo;

    @Autowired
    private RestTemplate restTemplate;

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

    public String findBarCode(MultipartFile image) {
        try {
            // Convert MultipartFile to BufferedImage
            BufferedImage bufferedImage = ImageIO.read(image.getInputStream());

            // Convert the image to a binary bitmap source
            BufferedImageLuminanceSource source = new BufferedImageLuminanceSource(bufferedImage);
            BinaryBitmap bitmap = new BinaryBitmap(new HybridBinarizer(source));
            Map<DecodeHintType, Object> hints = new EnumMap<>(DecodeHintType.class);
            hints.put(DecodeHintType.POSSIBLE_FORMATS,
                    java.util.Arrays.asList(BarcodeFormat.QR_CODE, BarcodeFormat.CODE_39, BarcodeFormat.CODE_128));

            // Decode the barcode using the MultiFormatReader
            Result result = new MultiFormatReader().decode(bitmap);

            // Return the decoded barcode text
            return result.getText();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (NotFoundException e) {
            e.printStackTrace();
        }

        return null;
    }

    public void sendBarcode(String data) throws IOException {
        // turn string to json for python
        ObjectMapper objectMapper = new ObjectMapper();
        String jsonString = objectMapper.writeValueAsString(data);
        // 
        RestTemplate restTemplate = new RestTemplate();

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<String> requestEntity = new HttpEntity<>(jsonString, headers);

        String url = "http://127.0.0.1:5000/receive_code";

        ResponseEntity<String> responseEntity = restTemplate.postForEntity(url, requestEntity, String.class);

        String responseBody = responseEntity.getBody();
        
        System.out.println(responseBody);
        // return responseBody;
    }
}
