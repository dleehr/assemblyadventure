#!/usr/bin/env python3

colors = """
7f7f7f
f0c8e8
c078b8
784090
f8f8f8
c0f8d8
50e0d0
4890c0
205870
003858
001830
c02008
f8a018
f04810
600800
000000
""".splitlines()

def to_components(hex_color):
    return hex_color[0:2], hex_color[2:4], hex_color[4:6]

def fivebits(byte):
    return "{0:05b}".format(byte)


def five_msb(byte_str):
    byte = int(byte_str, 16)
    byte = int(byte / 8)
    return byte

with open('SpriteColors.pal', 'wb') as f:
    for color in colors:
        if not color:
            continue
        # split apart 123456 to [12,34,56]
        comps = to_components(color)
        # get the 5 msb of each component and recompose to a 15-bit
        joined = ''.join([fivebits(five_msb(f)) for f in comps[::-1]])
        # now parse back to int

        rgb555 = int(joined, 2)
        print(hex(rgb555))
        to_write = rgb555.to_bytes(2, byteorder='little')
        f.write(to_write)







# take the 5 most significant bits
# of each color component and reverse their order
