from PIL import Image # https://pypi.org/project/Pillow/
import os
import mif # https://pypi.org/project/mif/
import numpy as np

image_source = 'spaceinvadersbis.gif' # image source .gif
mif_file = 'spaceinvadersbis.mif'           # fichier mif

dir_path = os.path.dirname(os.path.abspath(__file__)) # chemin complet du répertoire de travail
image_source = dir_path + '\\' + image_source
mif_file = dir_path + '\\' + mif_file

RED, GREEN, BLUE = 4, 2, 1

im = Image.open(image_source)
im = im.convert('RGB')
#im.show()
L, H = im.size

tab = np.empty((0,1) , dtype=np.uint8) # tableau 2D vide

for y in range(H):
    for x in range(L):
        r, g, b = im.getpixel((x,y))
        color_pixel = (RED if r > 128 else 0) + (GREEN if g > 128 else 0) + (BLUE if b > 128 else 0)
        tab = np.append(tab, np.uint8([[color_pixel]]), axis=0)

mem = np.unpackbits(tab, axis = 1, bitorder = 'little')

#print(mif.dumps(mem, packed = False, width = 3))
fp = open(mif_file, 'w')
mif.dump(mem, fp, packed = False, width = 3)