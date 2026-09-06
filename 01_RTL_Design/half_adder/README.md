# Half Adder (Behavioral Modeling)

## Overview

Designed and verified a 1-bit Half Adder using Verilog HDL [1]. The design was implemented using **Behavioral Modeling** and verified through RTL simulation using **Verilator** [1].

## Description

A Half Adder is a basic combinational logic circuit that performs the addition of two 1-bit binary inputs (`a` and `b`) [2]. It calculates the sum and the carry bits according to the following Boolean equations:
* **Sum** = a ^ b (implemented using the XOR operation) 
* **Carry** = a & b (implemented using the AND operation) 

## Files

* `half_adder_behavioral.v` - Behavioral Verilog design file 
* `half_adder_behavioral_tb.v` - Testbench file for verifying the adder's logic 

## Tools Used

* Verilog HDL
* Verilator (Simulation engine) 
* GTKWave (Waveform viewer) 


Results
The design compiled successfully using Verilator, and running the simulation verified the logical accuracy of the Behavioral Half Adder under all input conditions
Waveform
The simulation generated a Value Change Dump (half_adder_behavioral.vcd) file
. Opening this file in GTKWave shows the transitions of sum and carry outputs in alignment with changes to inputs a and b
<img width="454" height="149" alt="image" src="https://github.com/user-attachments/assets/5a4f0f0b-4f9f-43a9-bf80-f16c9b059218" />

Learning Outcome
Behavioral Modeling concepts in Verilog using procedural assignment blocks (always)
Designing combinational logic systems triggered on a sensitivity list (always @(a or b))
Developing a robust self-checking simulation environment (Testbench) in Verilog
Simulating and compiling hardware descriptions using Verilator
Outputting, reading, and verifying simulation data using GTKWave

***
