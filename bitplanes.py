#!/usr/bin/env python3
rows = """00607675
00767676
00077776
00667733
00767332
00073322
22223322
33332231""".splitlines()


def fourbits(byte):
    return "{0:04b}".format(int(byte))

def to_plane(rows, start=3):
    for row in rows:
        plane = [] # will have same as number of rows
        for byte in row:
            bits = fourbits(byte)
            plane.append(bits)
        for i in range(2):
            bitplane = ''.join([x[start-i] for x in plane])
            byte = int(bitplane, 2)
            yield byte.to_bytes(1, byteorder='little')

with open('Sprites.vra', 'wb') as f:
    for byte in to_plane(rows):
        f.write(byte)

    for byte in to_plane(rows, 1):
        f.write(byte)
