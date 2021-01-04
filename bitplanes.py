#!/usr/bin/env python3

# 0 1
# 2 3

rows = """
00607675
00767676
00077776
00667733
00767332
00073322
22223322
33332231

65654445
76555544
76665554
76554455
26776545
11727654
21112264
12111204

02323322
00233223
00022324
00003322
000c0032
00000eb3
bb899a8b
8bb89998

11111212
31113232
23134220
11211200
13312c00
11120000
333d0000
bbd787b0
""".splitlines()

rows = [r for r in rows if r]

def chunk8(rows):
    x = 0
    while x < len(rows):
        yield rows[x:x+8]
        x = x + 8

chunks = chunk8(rows)

def fourbits(byte):
    return "{0:04b}".format(int(byte, 16))

def to_plane(rows, start):
    for row in rows:
        if not row:
            continue
        plane = [] # will have same as number of rows
        for byte in row:
            bits = fourbits(byte)
            plane.append(bits)
        for i in (0, -1):
            bitplane = ''.join([x[start + i] for x in plane])
            byte = int(bitplane, 2)
            yield byte.to_bytes(1, byteorder='little')

with open('Sprites.vra', 'wb') as f:
    for chunk in chunks:
        print(chunk)
        for byte in to_plane(chunk, 3):
            f.write(byte)
        for byte in to_plane(chunk, 1):
            f.write(byte)
