#!/usr/bin/env python3

import sys

from numpy import sqrt, power, sin, cos, deg2rad

def rotate(x, y, angle):

    _x = x * cos(angle) - y * sin(angle)
    _y = x * sin(angle) + y * cos(angle)

    return _x, _y

def vector_length(x, y, z):
    return sqrt(power(x, 2) + power(y, 2) + power(z, 2))

def main(x, y, z, alpha, beta, gamma):

    # rotate in X axes
    y_rx, z_rx = rotate(y, z, alpha)

    # rotate in Y axes
    z_ry, x_ry = rotate(z_rx, x, beta)

    # rotate in Z axes
    x_rz, y_rz = rotate(x_ry, y_rx, gamma)

    print("x: {}".format(x_rz))
    print("y: {}".format(y_rz))
    print("z: {}".format(z_ry))

    print("lenght: {}".format(vector_length(x_rz, y_rz, z_ry)))

if __name__ == '__main__':

    if len(sys.argv) < 7:
        print("Usage: ./rotate.py x y z alpha beta gamma")
        print("alpha | beta | gamma are angles in degrees")
        sys.exit(0)

    x = float(sys.argv[1])
    y = float(sys.argv[2])
    z = float(sys.argv[3])
    alpha = deg2rad(float(sys.argv[4]))
    beta = deg2rad(float(sys.argv[5]))
    gamma = deg2rad(float(sys.argv[6]))

    main(x, y, z, alpha, beta, gamma)
