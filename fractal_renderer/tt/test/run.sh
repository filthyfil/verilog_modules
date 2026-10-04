#!/usr/bin/env bash
# Simulate tt_um_filthyfil_mandelbrot with Icarus Verilog and check the frames.
# usage: [OUT=dir] tt/test/run.sh
set -euo pipefail

here=$(cd "$(dirname "$0")" && pwd)
out=${OUT:-$here/out}
mkdir -p "$out"
rm -f "$out"/frame*.ppm "$out"/frame*.png

iverilog -g2005 -Wall -o "$out/tb.vvp" "$here/tb.v" "$here/../src/tt_um_filthyfil_mandelbrot.v"

cd "$out"
vvp -n tb.vvp | tee sim.log
grep -q "TB DONE" sim.log
! grep -q "ERROR" sim.log
python3 "$here/check.py"
