import cv2
from PIL import Image
import os

img_path = "barcodes_dad/IMG_20240606_134849765.jpg"

img = cv2.imread(img_path)
bd = cv2.barcode.BarcodeDetector()

retval, decoded_info, decoded_type = bd.detectAndDecode(img)

print(retval)

pil_img = Image.open(img_path)
pil_img.show()
# print(decoded_info)


