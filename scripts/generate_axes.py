#!/usr/bin/env python3

import sys
import numpy as np

WIDTH_RES = 640
HEIGHT_RES = 480
PGM_FILE_PATH = "axes-{}x{}.pgm"
PGM_HEADER = "P2\n640\n480\n255\n"
AXES_FILE_PATH = "axes_std_logic-{}x{}.txt"

def generate_axes(size):
    """
    Generates a "size"x"size" image to
    store in the ROM axes plot memory
    """

    image = np.zeros((size, size))

    half_size = size // 2

    for i in range(size):
        for j in range(size):
            if j == half_size - 1 or j == half_size:
                image[i][j] = 1
            if i == half_size - 1 or i == half_size:
                image[i][j] = 1

    return image

def save_as_bmp(image, size):
    """
    Saves the image generated into a PGM file
    of size 640x480 in the upper left corner
    """

    with open(PGM_FILE_PATH.format(size, size), "w") as f:
        f.write(PGM_HEADER)

        for i in range(HEIGHT_RES):
            for j in range(WIDTH_RES):
                if i < size and j < size:
                    f.write("255" if image[i][j] else "0")
                else:
                    f.write("100")
                f.write("\n")

def main(size):

    img = generate_axes(size)

    save_as_bmp(img, size)

if __name__ == '__main__':

    size = int(sys.argv[1])
 
    main(size)
