package com.dmn.snapinv.inventory;

import java.io.IOException;
import java.util.EnumMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

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

            String barcodeText = result.getText();
            BarcodeFormat barcodeFormat = result.getBarcodeFormat();
            ResultPoint[] resultPoints = result.getResultPoints();

            StringBuilder response = new StringBuilder();
            response.append("Barcode text: ").append(barcodeText).append("\n");
            response.append("Barcode format: ").append(barcodeFormat).append("\n");
            response.append("Result points: ");
            for (ResultPoint point : resultPoints) {
                response.append("(").append(point.getX()).append(", ").append(point.getY()).append(") ");
            }

            System.out.println(response.toString());
            // Return the decoded barcode text
            return "Barcode text: " + result.getText();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (NotFoundException e) {
            e.printStackTrace();
        }

        return null;
    }
}
