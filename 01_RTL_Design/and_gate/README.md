# AND Gate Implementation

## Overview

Designed and verified a 2-input AND gate using Verilog HDL. The design was simulated using Verilator and analyzed using GTKWave.

## Boolean Expression

Y = A & B

## Truth Table

| A | B | Y |
| - | - | - |
| 0 | 0 | 0 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 1 |

## RTL Design

Files included:

* and_gate_design.v
* and_gate_tb.v

## Simulation Result

The design was verified by applying all possible input combinations through a Verilog testbench.

### Terminal Output

<img width="426" height="178" alt="and sim" src="https://github.com/user-attachments/assets/21dca298-83e8-467a-b804-85a30feb920a" />


### Waveform

<img width="1294" height="706" alt="and wave" src="https://github.com/user-attachments/assets/0e108b9b-c64f-48a1-b920-23f4be4137b0" />


## Tools Used

* Verilog HDL
* Verilator
* GTKWave

## Learning Outcome

* Basic combinational logic design
* Verilog RTL implementation
* Testbench development
* Functional verification using Verilator
* Waveform analysis using GTKWave
