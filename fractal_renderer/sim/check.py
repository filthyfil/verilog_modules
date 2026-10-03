#!/usr/bin/env python3
"""Check tb_top output against a bit-exact model and render PNGs.

For each N with viewN.txt / fbN.hex / frameN.ppm in the working directory:
  * recompute every pixel with the same Q16.48 arithmetic as pixel.v and
    compare against the frame buffer dump
  * rebuild the expected 640x480 VGA image (2x scale, palette, crosshair)
    from the frame buffer and compare against the captured frame
  * write frameN.png (the captured VGA frame)
"""
import os
import re
import sys

W, F = 64, 48
H, V = 320, 240
MASK = (1 << W) - 1
FOUR = 4 << F
SRC = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                   "..", "fractal_renderer.srcs", "sources_1", "new", "top.v")


def wrap(v):
    """Truncate to a signed FP_WIDTH-bit value."""
    v &= MASK
    return v - (1 << W) if v >> (W - 1) else v


def iterate(cr, ci, max_iter):
    x = y = 0
    n = 0
    while True:
        x2 = wrap((x * x) >> F)
        y2 = wrap((y * y) >> F)
        two_xy = wrap((x * y) >> (F - 1))
        if n == max_iter:
            return 0
        if wrap(x2 + y2) > FOUR:
            return 0x80 | (n & 0x7F)
        x = wrap(x2 - y2 + cr)
        y = wrap(two_xy + ci)
        n += 1


def model(re_start, im_start, step, max_iter):
    fb = []
    im = im_start
    for _ in range(V):
        re = re_start
        for _ in range(H):
            fb.append(iterate(re, im, max_iter))
            re = wrap(re + step)
        im = wrap(im - step)
    return fb


def load_palette():
    text = open(SRC).read()
    pal = {int(i): int(c, 16) for i, c in re.findall(r"5'd(\d+)\s*: palette = 12'h([0-9A-Fa-f]{3})", text)}
    pal[31] = int(re.search(r"default: palette = 12'h([0-9A-Fa-f]{3})", text).group(1), 16)
    assert len(pal) == 32
    return [((c >> 8) & 15, (c >> 4) & 15, c & 15) for _, c in sorted(pal.items())]


def expected_frame(fb, rx, ry, pal):
    img = []
    for y in range(480):
        for x in range(640):
            dx, dy = x - 2 * rx, y - 2 * ry
            if (dy == 0 and -8 <= dx <= 8) or (dx == 0 and -8 <= dy <= 8):
                img.append((15, 15, 15))
                continue
            v = fb[(y >> 1) * H + (x >> 1)]
            img.append(pal[v & 31] if v & 0x80 else (0, 0, 0))
    return img


def read_ppm(path):
    tok = open(path).read().split()
    assert tok[0] == "P3" and tok[1:4] == ["640", "480", "15"], path
    vals = [int(t) for t in tok[4:]]
    return [tuple(vals[i:i + 3]) for i in range(0, len(vals), 3)]


def read_fb(path):
    vals = []
    for line in open(path):
        line = line.strip()
        if line and not line.startswith("//"):
            vals.extend(int(t, 16) for t in line.split())
    return vals


def write_png(img, path):
    from PIL import Image
    im = Image.new("RGB", (640, 480))
    im.putdata([(r * 17, g * 17, b * 17) for r, g, b in img])
    im.save(path)


def main():
    pal = load_palette()
    failures = 0
    n = 0
    while os.path.exists(f"view{n}.txt"):
        re_s, im_s, step, rx, ry, max_iter = (int(t) for t in open(f"view{n}.txt").read().split())
        print(f"view {n}: re_start={re_s / 2**F:.12f} im_start={im_s / 2**F:.12f} "
              f"step=2^{step.bit_length() - 1 - F} reticle=({rx},{ry}) max_iter={max_iter}")

        fb = read_fb(f"fb{n}.hex")
        ref = model(re_s, im_s, step, max_iter)
        bad = [i for i in range(H * V) if fb[i] != ref[i]]
        if bad:
            failures += 1
            print(f"  FAIL frame buffer: {len(bad)} pixels differ, first at "
                  f"({bad[0] % H},{bad[0] // H}): got {fb[bad[0]]:#04x} expected {ref[bad[0]]:#04x}")
        else:
            inside = sum(v == 0 for v in fb)
            print(f"  frame buffer matches model ({inside} pixels inside the set)")

        cap = read_ppm(f"frame{n}.ppm")
        exp = expected_frame(fb, rx, ry, pal)
        bad = [i for i in range(640 * 480) if cap[i] != exp[i]]
        if bad:
            failures += 1
            print(f"  FAIL VGA capture: {len(bad)} pixels differ, first at "
                  f"({bad[0] % 640},{bad[0] // 640}): got {cap[bad[0]]} expected {exp[bad[0]]}")
        else:
            print("  VGA capture matches frame buffer + palette + crosshair")

        write_png(cap, f"frame{n}.png")
        print(f"  wrote frame{n}.png")
        n += 1

    if n == 0:
        print("no view*.txt found")
        return 1
    print("CHECK PASS" if failures == 0 else f"CHECK FAIL ({failures})")
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
