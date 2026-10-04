# Mandelbrot for Tiny Tapeout — Design Sketch

Status: sketch. No RTL yet; `preview.py` models the datapath arithmetic and
renders what the chip would put on a monitor. Area and timing numbers are
estimates to be replaced by the Tiny Tapeout (OpenLane) harden results.

## Constraints

| Item | Tiny Tapeout (sky130 shuttles) | FPGA version |
|---|---|---|
| Area | ~1k gates per tile, tile ≈ 161 × 111 µm, common max 8×2 = 16 tiles (check current shuttle) | 32k LUTs, 120 DSPs, 75 BRAM |
| Memory | flip-flops only (~20 µm² each, a few hundred fill a tile) | 76,800 B frame buffer in BRAM |
| I/O | 8 in (`ui_in`), 8 out (`uo_out`), 8 bidir (`uio`), `clk`, `rst_n` | free pin choice |
| Clock | single clock from the demo board, ~25 MHz for VGA | 100 MHz |

A 76,800 B frame buffer is ~600k flip-flops: three orders of magnitude over
budget. So no frame buffer; every pixel is computed while the beam draws it.

## Why "rolled up + no frame buffer" can't be fully rolled

Without storage, the display consumes pixels at a fixed rate, so

    iteration units = iterations per pixel × compute pixels per second / f_clk

At 640×480@60 with a 25 MHz clock, one compute pixel per clock: a single
rolled iteration unit gives **1 iteration per pixel**. The only knobs are:

- **R — horizontal roll:** compute at 640/R wide; each compute pixel lasts R
  clocks, so one unit can iterate R times on it. Area per iteration drops R×,
  resolution drops R×.
- **K — physical stages:** an unrolled pipeline of K units adds K iterations
  per pass.

Total iterations = **K × R**. The design is a K-stage pipeline where each
stage is rolled R times: unrolled only as far as the area budget allows.

## Architecture

```
            ┌────────────────────── vga timing (h, v counters) ─────────────────────┐
            │                                                                        │
 ui_in ─▶ per-frame sampler ─▶ view regs (re0, im0, e) ─▶ c generator (cr, ci)       │
                                                         │                           │
                         ┌───────────────────────────────▼──────────────────────┐    │
                         │ stage 0 ─▶ stage 1 ─▶ ... ─▶ stage K-1                │    │
                         │  each stage holds one pixel for R clocks and          │    │
                         │  iterates it R times, then hands it on                │    │
                         └───────────────────────────────┬──────────────────────┘    │
                                                         ▼                           ▼
                                         escape count ─▶ palette ─▶ uo_out (TinyVGA, syncs delayed K·R)
```

The pipeline starts each line K·R clocks early, inside horizontal blanking
(160 clocks), and the syncs are delayed K·R clocks to match. Requires
K·R ≤ 160.

## Stage datapath

Format: signed Q4.F, N = 4 + F bits, range [-8, 8).

Per clock, on the pixel the stage holds:

```
x2 = (x·x) >> F              squarer
y2 = (y·y) >> F              squarer
s  = ((x+y)·(x+y)) >> F      squarer, N+1 bits in
esc |= |x| ≥ 2  or  |y| ≥ 2  or  x2 + y2 > 4
if !esc:  n++,  x = x2 − y2 + cr,  y = s − x2 − y2 + ci     (2xy without a multiplier)
```

- **Three squarers instead of three multipliers.** A squarer is ~half a
  multiplier (N(N+1)/2 partial products, not N²).
- **No overflow handling needed.** Squares are only used while |x|, |y| < 2 and
  x²+y² ≤ 4, so x2, y2 < 4 and |2xy| ≤ 4. Then |x'|, |y'| ≤ 4 + |c| < 8 for
  any |c| < 4. Q4 covers it, so no saturation logic is needed. The |x| ≥ 2 and
  |y| ≥ 2 tests catch escapes before a square could overflow.
- **Escaped pixels freeze.** `n` stops counting, and x and y are don't-care.

Stage registers: x, y, cr (3N), n (log2(K·R)), esc, line parity → ≈ 50 FFs
at N=14. `ci` is not carried: during a line boundary at most two lines are in
flight, so two broadcast registers (`ci_cur`, `ci_next`) plus a 1-bit parity
per stage select the right one.

All stages run in lockstep: one shared phase counter (0..R-1) decides when
every stage hands its pixel to the next.

## Coordinates, pan and zoom

- **Step is a power of two:** `step = 2^-e`, stored as a 4-bit exponent. Every
  "× step" becomes a shift, so the design needs no multipliers outside the
  stages.
- `cr` steps by `step` once per compute pixel, reloads `re0` at line start;
  `ci` steps every R lines (square pixels).
- **Controls are sampled once per frame at vsync.** That gives 16.7 ms
  between samples, which is longer than contact bounce, so debouncing is free
  and there are no counters.
  - Pan: move `re0`/`im0` by 8·step per frame while a direction is held.
  - Zoom: on a press edge, `e±1`, re-centred on the screen centre:
    `re0 += (W/2)·step/2`, `im0 −= (H/2)·step/2`. With W=160 and H=120 these
    are fixed shift-adds.
- No reticle: zoom is always about the screen centre (pan first). This saves
  the 64×9 multiply and the crosshair logic.

## Pinout

| Pin | Use |
|---|---|
| `ui_in[0..3]` | up, down, left, right (active high, sampled per frame) |
| `ui_in[4]`, `ui_in[5]` | zoom in, zoom out |
| `ui_in[7:6]` | palette select / colour cycling (optional) |
| `uo_out` | TinyVGA PMOD: `[0]` R1 `[1]` G1 `[2]` B1 `[3]` VSYNC `[4]` R0 `[5]` G0 `[6]` B0 `[7]` HSYNC (verify against the PMOD docs) |
| `uio` | unused (or debug: current `e`, frame tick) |
| `clk` | 25.175 MHz (25.0 MHz works on most monitors) |
| `rst_n` | async assert, synchronised deassert |

Colour: 2 bits per channel, 16-entry palette cycling on `n mod 16`, inside
the set black.

## Area budget (rough, sky130 hd)

Per stage at N bits: 3 squarers ≈ 1.5·N² full adders, ~6 N-bit adders
(≈ 6N FA), ≈ 3N+8 FFs, R-way recirculation mux. With FA ≈ FF ≈ 22 µm² and
~55% utilisation of a 17,950 µm² tile:

| N (Q4.F) | ≈ µm² / stage | ≈ tiles / stage |
|---|---|---|
| 12 (Q4.8) | 7,700 | 0.8 |
| 14 (Q4.10) | 10,000 | 1.0 |
| 16 (Q4.12) | 12,600 | 1.3 |

Fixed overhead (VGA timing, view registers, c generator, palette, sampler) is
about 1–1.5 tiles. These estimates could be off by ±50%. **The first real task
is to harden one stage and measure it.**

## Configurations (16 tiles)

| Config | Iterations | Compute res | Deepest zoom* | Preview |
|---|---|---|---|---|
| N=14, K=12, R=4 | 48 | 160×120 | 32× (step 2^-10) | `preview_reset.png`, `preview_zoom3.png` |
| N=16, K=10, R=4 | 40 | 160×120 | 128× | — |
| N=14, K=12, R=2 | 24 | 320×240 | 16× | — |
| N=12, K=16, R=1 | 16 | 640×480 | 2× | `preview_unrolled_r1.png` |

\* Zoom ends when the step reaches 1 LSB. Before that, the fixed iteration
count is the real limit: deep views turn mostly black (`preview_zoom3.png`,
48 iterations at 8×).

**Recommendation: N=14, K=12, R=4.** Blocky 160×120 pixels, but enough
iterations for real structure at the start view and the first few zooms.

Regenerate previews: `python3 preview.py F K R zooms out.png`.

## 1-tile variant: fixed view, colour cycling

One tile (~10,000 µm² usable, ~1k gates) fits one small stage plus a minimal
shell. There is no zoom and no pan. The animation is the colour bands
flowing: colour = `(n + phase) mod 16`, with `phase` advanced by a frame
counter (`preview_1tile_cycle.gif`).

### Datapath tricks

- **Narrow squarers.** Squares are only used while |x|, |y| < 2, so square
  the magnitude: `|x|²` and `|y|²` are (1+F)-bit squarers and `|x+y|²` is
  (2+F)-bit, instead of N-bit signed squarers. That costs 3 abs units
  (~N half adders each).
- **Q3.F, with overflow treated as escape.** An update that overflows
  [-4, 4) means |z'| ≥ 4, so it is an escape. The adder's overflow bit
  becomes the escape flag, which drops an integer bit with no saturation
  logic. (`preview.py ... I=3` models this.)

Config: **Q3.6 (N=9), one stage, R=8 → 80×60 compute**. The core runs at
**50 MHz** with a pixel enable every 2nd clock, which gives 2 iterations per
display clock and **16 iterations** in total.

### c comes straight from the counters

With a fixed view and step = 1/16 (= 4 LSB at F=6), there are no
accumulators and no view registers:

```
cr = (h_compute << 2) − 208        // −3.25 + px/16, h_compute = h_count[9:3]
ci = 120 − (v_compute << 2)        // +1.875 − py/16, v_compute = v_count[8:3]
```

That's a constant add on 7-bit and 6-bit counter fields. The pixel's `c`
only changes when the 8×8 block changes, so the stage simply recomputes
from z = 0 at each block boundary. There are no pipeline registers for c.

**The stage computes one block ahead.** A block's result is ready only at
the end of its 16 clocks, so the stage works on block `h_compute + 1` and
latches `{esc, n}` (5 FFs) into a display register at the block boundary.
Block 0 of each line is computed in the last 8 pixels of horizontal
blanking, using the next line's `v_compute`. Every block row is recomputed
on each of its 8 scanlines, with identical results.

### Colour cycling

- `phase`: 4-bit counter, advanced every `2^s` frames (`s` from `ui_in`),
  stepping up or down. 6–8 FFs plus an incrementer.
- `index = n_escape + phase` (4-bit add), then a 16×6-bit palette ROM.
- Inside the set (no escape after 16 iterations) is always black.
- **The palette is a closed loop with no black entry**
  (navy → blue → white → yellow → orange → maroon → purple → navy). Since 16
  iterations map one-to-one onto 16 colours, each band visits every colour,
  and a band never turns black and merges with the set.

### Pinout (1-tile)

| Pin | Use |
|---|---|
| `ui_in[1:0]` | cycle speed: phase step every 1, 2, 4 or 8 frames |
| `ui_in[2]` | direction (bands flow outward / inward) |
| `ui_in[3]` | pause |
| `ui_in[7:4]` | unused (tie off) |
| `uo_out` | TinyVGA PMOD, as above |
| `clk` | 50.35 MHz (2× pixel clock) |

### Area

| Block | ≈ µm² |
|---|---|
| stage: 3 abs, squarers (7/7/8-bit, ~90 FA), ~6 9-bit adders, x/y/n/esc regs (~25 FF) | 4,500–5,000 |
| VGA timing (h/v counters, syncs, pixel enable) | ~900 |
| c from counters (2 constant adds) | ~300 |
| phase counter, palette add + ROM, output regs | ~600 |
| **total** | **~6,500** (vs ~9–10k usable) |

Dropping zoom and pan removed the coordinate accumulators, the view
registers, the step shifter and the button sampler (~1,500 µm²). The margin
is now ~30%, enough to absorb the ±50% estimate error better, or to spend on
Q3.7 for cleaner band edges.

What you give up: 80×60 resolution in 8×8 blocks (`preview_1tile_r8.png`) and
16 iterations. A 16× roll (40×30) is barely recognisable
(`preview_1tile_r16.png`). The critical timing is one iteration (8-bit
squarer + 3 adds + mux) in 20 ns at the slow corner: plausible, but it must
be measured. At 25 MHz without the 2× clock it drops to 8 iterations.

### Implementation status (1-tile)

**Canonical source: [github.com/filthyfil/tt-mandelbrot](https://github.com/filthyfil/tt-mandelbrot)**
(Tiny Tapeout SKY130 template, cocotb test, datasheet). `src/` and `test/`
here are a synced copy with a standalone Icarus test (`test/run.sh`).

Changes from the sketch above, made while closing timing:

- 2xy = sign(x·y) · ((|x|·|y|) >> 5): one 7×7 magnitude multiplier, not
  (x+y)² − x² − y².
- The escape/overflow flags are registered and folded into `esc`/`n` one
  clock later (same results). The display register loads in clock 0 of the
  next block, and the video timing is delayed one clock to match.
- Syncs reset inactive (high).
- `ui_in[5:4]` selects one of 4 palettes (current, rainbow, fire,
  synthwave), latched per frame.

Hardened results (LibreLane flow in GitHub Actions, commit `32ed0fa`):

| | |
|---|---|
| Tile | 1×1, 75.8% utilisation, 1,427 cells, 83 FFs |
| Timing, typical (sign-off) | +9.8 ns slack at 50.35 MHz |
| Timing, ss 100 °C 1.60 V | −0.71 ns on x → f_overflow (TT does not sign off this corner) |
| DRC / LVS / antenna | 0 / 0 / 0 |
| RTL + gate-level cocotb tests | pass (every pixel of every captured frame vs the model) |

The area and timing estimates earlier in this section were made before
implementation; the table above is measured.

## Differences from the FPGA version

| | FPGA | Tiny Tapeout |
|---|---|---|
| Storage | frame buffer, renders once | none, recomputes every frame (60 fps, zoom/pan are instant) |
| Iterations | up to 1000, data-dependent time | fixed K·R (~48), constant time |
| Precision | Q16.48 (64-bit), ~42 zooms | Q4.10 (14-bit), ~5 zooms |
| Pipeline | 1 loop, slots recirculate, valid/ready, out-of-order tags | linear, lockstep, in-order; no handshake, no tags |
| Multipliers | 3 × 64×64 DSP | 3 squarers per stage, built from standard cells |
| Coordinates | 64-bit adds, arbitrary step | power-of-two step, shifts only |
| Zoom | about reticle, 64×9 multiply | about screen centre, shift-add |
| Debounce | `debounce_edge` per button | per-frame sampling |
| Colour | 4 bits/channel, 32 colours | 2 bits/channel, 16 colours |

## Open questions / next steps

1. Harden a single stage at N=14 in the TT flow to get its real area and
   timing. That calibrates K.
2. Write the RTL (`tt_um_mandelbrot`), reusing `vga_sync` with corrected
   porches, and a testbench using the same capture approach as
   `fractal_renderer/sim`. Compare against `preview.py` (make it bit-exact).
3. Check one-iteration-per-clock timing: 15-bit squarer + 3-input add + mux
   in under 40 ns at the slow corner should be comfortable.
4. Check the TinyVGA pinout and the current shuttle's tile limits and PDK
   (newer shuttles may be on a different process, with different tile area).

## Alternative: fully rolled + external frame buffer

To keep the FPGA architecture (progressive render, deep zoom, many iterations),
move the frame buffer off chip: one rolled iteration unit (digit-serial
multiplier, 32-bit) rendering into a QSPI PSRAM on a PMOD. It's small in
area, but adds a PSRAM controller that has to share the bus between display
reads and pixel writes, and stay within the PSRAM's maximum chip-select time.
Display streaming at 160×120×4 bpp is feasible. It's more risk and more
verification; worth doing after the beam-racer works.
