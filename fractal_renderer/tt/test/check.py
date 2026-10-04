#!/usr/bin/env python3
"""Check tb.v captures of tt_um_filthyfil_mandelbrot against a bit-level model.

The model follows the spec in ../DESIGN.md (1-tile variant), independently of
the RTL: Q3.6, 16 iterations, c from the block position, overflow = escape,
2xy = sign(x*y) * ((|x|*|y|) >> 5).
For each captured frame, find the colour phase that reproduces it exactly,
then check the phase sequence the testbench requested.
"""
import os
import re
import sys

F = 6
ITER = 16
COLS, ROWS = 80, 60
LIM = 256  # Q3.6 range [-4, 4) = [-256, 256)
SRC = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "src",
                   "tt_um_filthyfil_mandelbrot.v")

# expected phase step between consecutive captures (forward, reverse, pause)
EXPECTED_STEPS = [+1, -1, -1, 0, 0]


def wrap9(v):
    v &= 0x1FF
    return v - 0x200 if v & 0x100 else v


def escape_count(cr, ci):
    """None if inside, else escape iteration mod 16."""
    x = y = 0
    for n in range(ITER):
        x2 = (x * x) >> F
        y2 = (y * y) >> F
        two_xy = (abs(x) * abs(y)) >> (F - 1)
        if (x < 0) != (y < 0):
            two_xy = -two_xy
        if abs(x) >= 2 << F or abs(y) >= 2 << F or x2 + y2 > 4 << F:
            return n % 16
        xw = x2 - y2 + cr
        yw = two_xy + ci
        if not (-LIM <= xw < LIM and -LIM <= yw < LIM):
            return (n + 1) % 16
        x, y = wrap9(xw), wrap9(yw)
    return None


def model():
    return [[escape_count(4 * col - 208, 120 - 4 * row) for col in range(COLS)]
            for row in range(ROWS)]


def load_palette(sel=0):
    """Palette sel (ui_in[5:4]) from the RTL's 64-entry case table."""
    text = open(SRC).read()
    table = {int(i): v.replace("_", "")
             for i, v in re.findall(r"6'd(\d+)\s*: rgb = 6'b([01_]+);", text)}
    assert sorted(table) == list(range(64))
    entries = [(int(v[0:2], 2), int(v[2:4], 2), int(v[4:6], 2)) for _, v in sorted(table.items())]
    return entries[16 * sel:16 * sel + 16]


def expected(blocks, pal, phase):
    img = []
    for y in range(480):
        row = blocks[y // 8]
        for x in range(640):
            n = row[x // 8]
            img.append((0, 0, 0) if n is None else pal[(n + phase) % 16])
    return img


def read_ppm(path):
    tok = open(path).read().split()
    assert tok[:4] == ["P3", "640", "480", "3"], path
    vals = [int(t) for t in tok[4:]]
    return [tuple(vals[i:i + 3]) for i in range(0, len(vals), 3)]


def write_png(img, path):
    from PIL import Image
    im = Image.new("RGB", (640, 480))
    im.putdata([(r * 85, g * 85, b * 85) for r, g, b in img])
    im.save(path)


def main():
    blocks = model()
    pal = load_palette()
    inside = sum(n is None for row in blocks for n in row)
    print(f"model: {inside} of {COLS * ROWS} blocks inside the set")
    refs = [expected(blocks, pal, p) for p in range(16)]

    phases = []
    ok = True
    n = 0
    while os.path.exists(f"frame{n}.ppm"):
        cap = read_ppm(f"frame{n}.ppm")
        match = [p for p in range(16) if cap == refs[p]]
        if match:
            phases.append(match[0])
            print(f"frame{n}: matches model at phase {match[0]}")
        else:
            best = min(range(16), key=lambda p: sum(a != b for a, b in zip(cap, refs[p])))
            bad = [i for i in range(len(cap)) if cap[i] != refs[best][i]]
            print(f"frame{n}: FAIL, closest phase {best}: {len(bad)} pixels differ, first at "
                  f"({bad[0] % 640},{bad[0] // 640}) got {cap[bad[0]]} expected {refs[best][bad[0]]}")
            phases.append(None)
            ok = False
        write_png(cap, f"frame{n}.png")
        n += 1

    if n == 0:
        print("no frames found")
        return 1

    for i, step in enumerate(EXPECTED_STEPS[:n - 1]):
        a, b = phases[i], phases[i + 1]
        if a is None or b is None:
            continue
        if (b - a) % 16 != step % 16:
            print(f"FAIL phase step frame{i} -> frame{i + 1}: {a} -> {b}, expected {step:+d}")
            ok = False
    if ok:
        print(f"phase sequence {phases} matches steps {EXPECTED_STEPS[:n - 1]}")

    print("CHECK PASS" if ok else "CHECK FAIL")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
