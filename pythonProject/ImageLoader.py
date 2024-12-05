from PIL import Image
import numpy as np

# Cargar la imagen
ruta_imagen = "D:/CARRERA/Tercer año - Curso 24_25/download.jpeg"
imagen = Image.open(ruta_imagen).convert("RGB")  # Convertir a RGB si no lo está

# Convertir la imagen a un array NumPy
array_rgb = np.array(imagen)

# Cambiar de RGB a BGR
array_bgr = array_rgb[:, :, ::-1]

# Convertir a hexadecimal y agregar los dos ceros delante
# Ejemplo: Para un píxel [255, 0, 128] en BGR => "00FF0080"
array_hex = np.apply_along_axis(
    lambda pixel: f"00{pixel[0]:02X}{pixel[1]:02X}{pixel[2]:02X}", axis=2, arr=array_bgr
)

# Guardar en un archivo de texto
ruta_txt = "salida3.txt"
with open(ruta_txt, "w") as archivo:
    for fila in array_hex:
        archivo.write("".join(fila))
