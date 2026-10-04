#!/usr/bin/env python3
"""Preview of the Tiny Tapeout beam-racing Mandelbrot (see DESIGN.md).

Models the proposed datapath bit-for-bit at the arithmetic level:
  * QI.F signed fixed point, N = I + F bits (default Q4.F, range [-8, 8))
  * 2xy from squarers: (x+y)^2 - x^2 - y^2
  * escape if |x| >= 2 or |y| >= 2 or x^2 + y^2 > 4
  * K physical stages, each iterating R times per compute pixel -> K*R iterations
  * 640/R x 480/R compute pixels, each shown as an R x R block
  * 2-bit-per-channel TinyVGA palette, 16 colours cycling, inside = black

usage: preview.py [F] [K] [R] [zooms] [out.png|out.gif] [I]
  out.gif renders the palette-cycling animation: colour = (n + phase) mod 16,
  phase stepping through all 16 values (inside the set stays black).
  I = integer bits incl. sign (default 4). With I=3 (range [-4, 4)) an update
      that overflows is treated as an escape (|z| > 2 is already implied).
"""
import sys

import numpy as np
from PIL import Image

F = int(sys.argv[1]) if len(sys.argv) > 1 else 10
K = int(sys.argv[2]) if len(sys.argv) > 2 else 12
R = int(sys.argv[3]) if len(sys.argv) > 3 else 4
ZOOMS = int(sys.argv[4]) if len(sys.argv) > 4 else 0
OUT = sys.argv[5] if len(sys.argv) > 5 else f"preview_F{F}_K{K}_R{R}_z{ZOOMS}.png"
I = int(sys.argv[6]) if len(sys.argv) > 6 else 4

N = I + F
W, H = 640 // R, 480 // R
ITER = K * R
ONE = 1 << F

# 16-entry palette designed in 2-bit-per-channel space (TinyVGA): a closed loop
# navy -> blue -> white -> yellow -> orange -> maroon -> purple -> navy, no black,
# so palette cycling never merges a band with the (black) inside of the set
PAL = [(0, 0, 1), (0, 0, 2), (0, 1, 2), (0, 1, 3), (1, 2, 3), (2, 2, 3), (2, 3, 3), (3, 3, 3),
       (3, 3, 2), (3, 3, 1), (3, 2, 0), (3, 1, 0), (2, 1, 0), (1, 0, 0), (1, 0, 1), (1, 0, 2)]
assert len(set(PAL)) == 16 and (0, 0, 0) not in PAL


def wrap(v):
    v = v & ((1 << N) - 1)
    return np.where(v >> (N - 1), v - (1 << N), v)


def view(zooms, target=(-0.743643887, 0.131825904)):
    """Start corner and step exponent after centre zooms toward target
    (the hardware zooms about the screen centre; panning is assumed)."""
    e = int(round(np.log2(W / 5)))   # step = 2^-e, view ~5 units wide
    if zooms == 0:
        cx, cy = -0.75, 0.0
    else:
        cx, cy = target
        e += zooms
    step = 1 << (F - e)
    assert step >= 1, "zoomed past the fixed-point resolution"
    re0 = int(round(cx * ONE)) - (W // 2) * step
    im0 = int(round(cy * ONE)) + (H // 2) * step
    return re0, im0, step, e


def render(re0, im0, step):
    px = np.arange(W, dtype=np.int64)
    py = np.arange(H, dtype=np.int64)
    cr = wrap(re0 + px[None, :] * step) * np.ones((H, 1), dtype=np.int64)
    ci = wrap(im0 - py[:, None] * step) * np.ones((1, W), dtype=np.int64)
    x = np.zeros((H, W), dtype=np.int64)
    y = np.zeros((H, W), dtype=np.int64)
    n_esc = np.full((H, W), -1, dtype=np.int64)
    for n in range(ITER):
        x2 = (x * x) >> F
        y2 = (y * y) >> F
        s = ((x + y) * (x + y)) >> F
        esc = (np.abs(x) >= 2 * ONE) | (np.abs(y) >= 2 * ONE) | (x2 + y2 > 4 * ONE)
        n_esc = np.where((n_esc < 0) & esc, n, n_esc)
        xw = x2 - y2 + cr
        yw = s - x2 - y2 + ci
        if I == 3:
            # overflow of the update means |z'| >= 4: escaped on the next check
            lim = 1 << (N - 1)
            ovf = (xw >= lim) | (xw < -lim) | (yw >= lim) | (yw < -lim)
            n_esc = np.where((n_esc < 0) & ~esc & ovf, n + 1, n_esc)
        x = wrap(xw)
        y = wrap(yw)
    return n_esc


def colorize(n_esc, phase=0):
    img = np.zeros((H, W, 3), dtype=np.uint8)
    idx = (n_esc + phase) % 16
    for i, (r, g, b) in enumerate(PAL):
        m = (n_esc >= 0) & (idx == i)
        img[m] = (r * 85, g * 85, b * 85)
    return np.repeat(np.repeat(img, R, axis=0), R, axis=1)


def main():
    re0, im0, step, e = view(ZOOMS)
    n_esc = render(re0, im0, step)
    if OUT.endswith(".gif"):
        # phase steps every 4 frames at 60 Hz -> ~67 ms per GIF frame
        frames = [Image.fromarray(colorize(n_esc, p)) for p in range(16)]
        frames[0].save(OUT, save_all=True, append_images=frames[1:], duration=67, loop=0)
    else:
        Image.fromarray(colorize(n_esc)).save(OUT)
    print(f"N={N} (Q{I}.{F}) K={K} R={R} -> {ITER} iterations, {W}x{H} compute, "
          f"step=2^-{e}, wrote {OUT}")


if __name__ == "__main__":
    main()
