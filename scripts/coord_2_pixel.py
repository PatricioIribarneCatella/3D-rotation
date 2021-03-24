#!/usr/bin/env python3

import sys
import numpy as np

def main(x, y, pixel_size):

    xp = np.floor((x + 1) * 2**(pixel_size - 1))
    yp = np.floor(-(y - 1) * 2**(pixel_size - 1))

    print('pixel_x: {}'.format(xp))
    print('pixel_y: {}'.format(yp))

if __name__ == '__main__':

    if len(sys.argv) < 4:
        print("Usage: ./coord_2_pixel.py x y pixel_size")
        sys.exit(0)

    x = float(sys.argv[1])
    y = float(sys.argv[2])
    pixel_size = int(sys.argv[3])

    main(x, y, pixel_size)
