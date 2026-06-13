# 4x1 Multiplexer

## Overview

Designed and verified a 4x1 Multiplexer using Verilog HDL. The design was implemented using Gate-Level Modeling and verified through simulation using Verilator.

## Description

A 4x1 Multiplexer selects one of four input signals based on a 2-bit select line and forwards the selected input to the output.

## Files

* mux4x1_gatelevel.v
* mux_gatelevel_tb.v

## Tools Used

* Verilog HDL
* Verilator
* GTKWave

## Results

The multiplexer was successfully simulated for different select inputs, and the output correctly reflected the selected input signal.

### Simulation Output

<img width="1092" height="261" alt="mux sim" src="https://github.com/user-attachments/assets/60a2fff0-a238-4418-a57f-b7e4cd7a1788" />

### Waveform

<img width="1293" height="746" alt="mux wave" src="https://github.com/user-attachments/assets/92911b8b-9ef9-45e7-a334-e044b456ac64" />


## Learning Outcome

* Gate-Level Modeling in Verilog
* Multiplexer design concepts
* Testbench development
* RTL simulation using Verilator
* Waveform analysis using GTKWave
