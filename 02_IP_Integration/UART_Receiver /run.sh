#!/bin/bash
# Compile design and testbench
verilator --binary -j 0 -Wall uart_receiver.v uart_receiver_tb.v \
          --top uart_receiver_tb --timing --trace --CFLAGS "-std=c++20"

# Enter output directory and build
cd obj_dir || { echo "Error: obj_dir not found"; exit 1; }
make -f Vuart_receiver_tb.mk Vuart_receiver_tb || { echo "Compilation failed"; exit 1; }

# Execute simulation
./Vuart_receiver_tb || { echo "Simulation failed"; exit 1; }

# Open waveform in GTKWave
gtkwave uart_receiver_tb.vcd
