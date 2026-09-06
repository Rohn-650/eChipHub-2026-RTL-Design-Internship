# UART Receiver

## Overview

Designed and verified a **UART (Universal Asynchronous Receiver Transmitter) Receiver** module using Verilog HDL. The design was implemented using a **Finite State Machine (FSM)** with a synchronous clock and validated through simulation with **Verilator**.

## Description

A UART Receiver converts asynchronous serial data stream into 8-bit parallel data. It operates based on a standard UART frame containing **1 start bit (logic 0)**, **8 data bits**, and **1 stop bit (logic 1)**. 

To prevent metastability issues arising from asynchronous inputs, the serial input line is first passed through a **two-stage synchronizer**. The receiver detects the falling edge of the start bit, waits until the middle of the bit period to validate it, and then samples consecutive bits at the center of each bit window before asserting a completion flag.

### Finite State Machine (FSM) States

* **IDLE**: Initial state where the system waits for the input line to drop low, indicating a start bit.
* **START**: Waits for half of a bit period to validate the start bit. If validated, transitions to `RECV`; otherwise, returns to `IDLE`.
* **RECV**: Samples the 8 incoming data bits (LSB first) at regular baud intervals and stores them in a buffer.
* **STOP**: Waits for one full bit period to receive the stop bit, copies the buffer contents to parallel data output, and asserts the `data_ready` signal.

### Design Specifications

* **System Clock Frequency**: 25 MHz (40 ns clock period)
* **Baud Rate**: 115200 bps
* **Clocks Per Bit**: 217 cycles (25,000,000 / 115,200)
* **Bit Period**: 8.68 µs

## Files

* `uart_receiver.v` - UART Receiver design file incorporating the 2-stage synchronizer and FSM controller.
* `uart_receiver_tb.v` - Testbench file that generates a 25 MHz clock and transmits two test bytes (`0x3C` and `0x2F`) serially.
* `run.sh` - Bash script to automate compiling, building, and launching GTKWave.

## Tools Used

* Verilog HDL
* Verilator
* GTKWave



# Open waveform in GTKWave
gtkwave uart_receiver_tb.vcd
Results
The design compiled successfully with Verilator and passed the timing and logical constraints. The testbench correctly transmitted two frames (0x3C and 0x2F) consecutively, which were both fully reconstructed.
Simulation Output

RX[8] @ 83220000 ns = 3c

RX[9] @ 178700000 ns = 2f

Final data_out = 2f

PASS: Two bytes received successfully

Waveform

<img width="790" height="131" alt="image" src="https://github.com/user-attachments/assets/00cb7db2-bb8d-4ea2-a312-fef0fdf5fc1e" />

The generated waveform file uart_receiver_tb.vcd displays the transition states from IDLE through to the active processing of START, RECV (shifting 8 data bits), and the asserting of data_ready upon matching the STOP bit.
