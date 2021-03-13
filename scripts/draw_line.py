#!/usr/bin/env python3

import sys

def plot(x, y):
    print((x, y))

def plot_line_low(x0, y0, x1, y1):

    dx = x1 - x0
    dy = y1 - y0

    yi = 1

    if dy < 0:
        yi = -1
        dy = -dy

    D = (2 * dy) - dx
    y = y0

    for x in range(x0, x1):
        plot(x, y)

        if D > 0:
            y = y + yi
            D = D + 2*(dy - dx)
        else:
            D = D + 2*dy

def plot_line_high(x0, y0, x1, y1):

    dx = x1 - x0
    dy = y1 - y0

    xi = 1

    if dx < 0:
        xi = -1
        dx = -dx

    D = (2 * dx) - dy
    x = x0

    for y in range(y0, y1):
        plot(x, y)

        if D > 0:
            x = x + xi
            D = D + 2*(dx - dy)
        else:
            D = D + 2*dx

def plot_line_v1(x0, y0, x1, y1):

    if (abs(y1 - y0) < abs(x1 - x0)):
        if x0 > x1:
            plot_line_low(x1, y1, x0, y0)
        else:
            plot_line_low(x0, y0, x1, y1)
    else:
        if y0 > y1:
            plot_line_high(x1, y1, x0, y0)
        else:
            plot_line_high(x0, y0, x1, y1)

def plot_line_v2(x0, y0, x1, y1):

    dx = abs(x1 - x0)
    sx = 1 if x0 < x1 else -1

    dy = -abs(y1 - y0)
    sy = 1 if y0 < y1 else -1

    err = dx + dy

    x = x0
    y = y0

    while True:
        plot(x, y)

        if x == x1 and y == y1:
            break

        e2 = 2 * err # translates to: e2 <= err << 1

        if e2 >= dy:
            err += dy
            x += sx

        if e2 <= dx:
            err += dx
            y += sy

def plot_line_v3(x0, y0, x1, y1):

    dx = x1 - x0

    right = dx > 0
    print("right: {}".format(right))

    if not right:
        dx = -dx

    print("dx: {}".format(dx))

    dy = y1 - y0

    down = dy > 0
    print("down: {}".format(down))

    if down:
        dy = -dy

    print("dy: {}".format(dy))

    err = dx + dy

    x = x0
    y = y0

    while True:
        plot(x, y)

        print("err: {}".format(err))

        if x == x1 and y == y1:
            break

        e2 = err << 1
        print("e2: {}".format(e2))

        if e2 >= dy:
            print("e2 >= dy")
            err += dy
            if right:
                x += 1
            else:
                x -= 1

        if e2 <= dx:
            print("e2 <= dx")
            err += dx
            if down:
                y += 1
            else:
                y -= 1

def main(x0, y0, x1, y1):

    print("v1")
    plot_line_v1(x0, y0, x1, y1)
    print("v2")
    plot_line_v2(x0, y0, x1, y1)
    print("v3")
    plot_line_v3(x0, y0, x1, y1)

if __name__ == '__main__':
    """
    It uses Bresenham's line algorithm to
    draw a line from (x0, y0) to (x1, y1)

    ref: https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm#All_cases
    """

    if len(sys.argv) < 5 or len(sys.argv) > 5:
        print("Usage: ./draw_line.py x0 y0 x1 y1")
        sys.exit(0)

    x0 = int(sys.argv[1])
    y0 = int(sys.argv[2])
    x1 = int(sys.argv[3])
    y1 = int(sys.argv[4])

    main(x0, y0, x1, y1)
