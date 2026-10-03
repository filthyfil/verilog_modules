#!/usr/bin/env bash
# Simulate the renderer with Icarus Verilog and check/render the frames.
# usage: [OUT=dir] sim/run.sh [MAX_ITERATION] [NUM_ZOOMS]
set -euo pipefail

MAX_ITERATION=${1:-256}
NUM_ZOOMS=${2:-8}

here=$(cd "$(dirname "$0")" && pwd)
src=$here/../fractal_renderer.srcs
out=${OUT:-$here/out}
mkdir -p "$out"
rm -f "$out"/view*.txt "$out"/fb*.hex "$out"/frame*.ppm "$out"/frame*.png

iverilog -g2005 -o "$out/tb.vvp" \
    -P tb_top.MAX_ITERATION="$MAX_ITERATION" -P tb_top.NUM_ZOOMS="$NUM_ZOOMS" \
    "$src"/sim_1/new/tb_top.v \
    "$src"/sources_1/new/{top,pixel,zoom,memory,vga_sync,debounce_edge}.v

cd "$out"
vvp -n tb.vvp | tee sim.log
grep -q "TB PASS" sim.log
python3 "$here/check.py"
