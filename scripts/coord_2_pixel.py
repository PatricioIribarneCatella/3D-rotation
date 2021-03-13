#!/usr/bin/env python3

import sys
import numpy as np

def main():

    x = 0.8750
    y = 0.6250

    pixel_size = 3

    xp = np.floor((x + 1) * 2**(pixel_size - 1))
    yp = np.floor(-(y - 1) * 2**(pixel_size - 1))

    print('pixel_x: {}'.format(xp))
    print('pixel_y: {}'.format(yp))

if __name__ == '__main__':
    main()
