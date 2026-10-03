#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
# Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
# 

if [ -z "$PATH" ]; then
  PATH=/home/filthyfil/Applications/Vivado/2025.1/Vitis/bin:/home/filthyfil/Applications/Vivado/2025.1/Vivado/ids_lite/ISE/bin/lin64:/home/filthyfil/Applications/Vivado/2025.1/Vivado/bin
else
  PATH=/home/filthyfil/Applications/Vivado/2025.1/Vitis/bin:/home/filthyfil/Applications/Vivado/2025.1/Vivado/ids_lite/ISE/bin/lin64:/home/filthyfil/Applications/Vivado/2025.1/Vivado/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=
else
  LD_LIBRARY_PATH=:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='/home/filthyfil/FPGA/square_wave_generator/square_wave_generator.runs/impl_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

# pre-commands:
/bin/touch .write_bitstream.begin.rst
EAStep vivado -log square_wave.vdi -applog -m64 -product Vivado -messageDb vivado.pb -mode batch -source square_wave.tcl -notrace


