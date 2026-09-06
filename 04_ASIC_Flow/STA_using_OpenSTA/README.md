
# Static Timing Analysis using OpenSTA

## Overview

Designed and verified the timing behavior of a synthesized **2x1 Multiplexer** gate-level netlist using the sign-off level tool **OpenSTA**. This project demonstrates how static timing analysis (STA) is applied to verify combinational propagation delays, setup/hold margins, and slack behavior against custom Synopsys Design Constraints (SDC) under different operating frequencies (10ns and 5ns clock periods).

## Description

Static Timing Analysis (STA) verifies that a digital design meets all timing constraints across various operating conditions without performing costly dynamic gate-level simulations. 

For combinational circuits like the 2x1 Multiplexer, the timing path flows from the input ports (`a`, `b`, and `sel`) to the output port (`out`). OpenSTA evaluates:
* **Data Arrival Time**: The time taken for a signal to propagate from an input port, through the internal logic gates (e.g., `INVX1`, `NAND2X1`, and `OAI21X1` cells), to the output.
* **Data Required Time**: The timing window bounded by clock edges and constraint margins.
* **Slack**: The difference between the Data Required Time and the Data Arrival Time.
  * **Positive Slack (MET)**: Indicates the signal arrives before its deadline, ensuring reliable operation.
  * **Negative Slack (VIOLATED)**: Highlights timing violations where logic propagation delays exceed the clock boundary, causing potential circuit failure.

---

## Files

* `mux_2x1.v` - Original behavioral Verilog RTL design file.
* `mux_2x1_synth.v` - Technology-mapped, gate-level Verilog netlist generated during Yosys synthesis.
* `osu018_stdcells.lib` - Oklahoma State University (OSU) 0.18µm standard cell library containing timing models and gate delays.
* `mux_2x1.sdc` - Synopsys Design Constraints (SDC) file defining clocks, delays, and pin load parameters.

---

## Tools Used

* **OpenSTA** (Industrial-grade, extensible Static Timing Analysis engine)
* **Yosys** (To supply the synthesized gate-level input netlist)
* **GVim** (Editing and viewing constraints/reports)

---

## SDC and Script Implementation

### 1. Synopsys Design Constraints (`mux_2x1.sdc`)
This file guides OpenSTA by modeling realistic physical environment conditions, clock periods, and input/output delays:
```tcl
# Define a virtual system clock with a 10ns period (100 MHz)
create_clock -period 10 -name clk [get_ports clk]

# Define input timing delays and signal slew transitions
set_input_delay 5 -min -rise [get_ports clk] -clock clk
set_input_delay 5 -max -fall [get_ports {a b sel}] -clock clk
set_input_transition 5 -min -rise [get_ports {a b sel}] -clock clk
set_input_transition 5 -max -fall [get_ports clk] -clock clk

# Model a physical load of 4 fF on the output port
set_load -pin_load 4 [get_ports out]

# Define output timing delays relative to virtual clock boundary
set_output_delay 2 -min -rise [get_ports out] -clock clk
```
*Note: To evaluate timing closure at double the frequency (200 MHz), the clock period is updated to `5` ns inside this constraint file.*

### 2. Interactive STA Execution Commands
Static timing checks are executed by invoking the `sta` shell interpreter in the terminal and running the following commands:
```tcl
# 1. Load liberty cell delays from the standard library
read_liberty osu018_stdcells.lib

# 2. Read the gate-level synthesized netlist
read_verilog mux_2x1_synth.v

# 3. Link the cell library and netlist to the top-level design module
link_design mux_2x1

# 4. Ingest SDC environment and timing constraints
read_sdc mux_2x1.sdc

# 5. Generate setup and hold timing check reports
report_checks
```

---

## Results and Timing Closure Analysis

### Slack Results Comparison
Changing the clock constraint changes the required arrival window for data, shifting slack margins:

| Timing Parameter | Setup Slack (ns) | Hold Slack (ns) | Timing Closure Status |
|---|---|---|---|
| **10ns Clock Period** (100 MHz) | `3.22` (MET) | `10.55` (MET) | **PASS** — Both timing requirements met successfully. |
| **5ns Clock Period** (200 MHz) | `-46.78` (VIOLATED) | `10.55` (MET) | **FAIL** — Setup path fails to close. |

### Setup Slack Report (At 10ns Clock Constraints)
for setup:-
<img width="387" height="253" alt="image" src="https://github.com/user-attachments/assets/d50bef8e-df61-49a9-8450-e4febce3d79e" />
for hold:-
<img width="371" height="242" alt="image" src="https://github.com/user-attachments/assets/212ac4dd-088c-4f49-9bde-af13f687811c" />

```text
OpenSTA> report_checks -path_delay max
Startpoint: sel (input port clocked by clk)
Endpoint: out (output port clocked by clk)
Path Group: clk
Path Type: max

Delay     Time     Description
---------------------------------------------------------
 0.00     0.00     clock clk (rise edge)
 0.00     0.00     clock network delay (ideal)
 5.00     5.00 v   input external delay
 0.00     5.00 v   sel (in)
86.78    91.78 ^   _4_/Y (OAI21X1)
 0.00    91.78 ^   out (out)
         91.78     data arrival time

100.00  100.00     clock clk (rise edge)
 0.00   100.00     clock network delay (ideal)
 0.00   100.00     clock reconvergence pessimism
-5.00    95.00     output external delay
         95.00     data required time
---------------------------------------------------------
          3.22     slack (MET)
```

### Setup Slack Report (At 5ns Clock Constraints)
for setup:-
<img width="387" height="264" alt="image" src="https://github.com/user-attachments/assets/b111fca3-65b3-402d-98df-3c3f547d9a41" />
for hold:-
<img width="353" height="204" alt="image" src="https://github.com/user-attachments/assets/e8d15caf-2b56-4944-9c52-7fa14f72b229" />

```text
OpenSTA> report_checks -path_delay max
Startpoint: sel (input port clocked by clk)
Endpoint: out (output port clocked by clk)
Path Group: clk
Path Type: max

Delay     Time     Description
---------------------------------------------------------
 0.00     0.00     clock clk (rise edge)
 0.00     0.00     clock network delay (ideal)
 5.00     5.00 v   input external delay
 0.00     5.00 v   sel (in)
86.78    91.78 ^   _4_/Y (OAI21X1)
 0.00    91.78 ^   out (out)
         91.78     data arrival time

50.00    50.00     clock clk (rise edge)
 0.00    50.00     clock network delay (ideal)
 0.00    50.00     clock reconvergence pessimism
-5.00    45.00     output external delay
         45.00     data required time
---------------------------------------------------------
        -46.78     slack (VIOLATED)
```



## Learning Outcome

* **Sign-off STA Fundamentals**: Gained experience running Static Timing Analysis to check physical design timing parameters at the sign-off level.
* **Constraint Engineering (SDC)**: Authored constraint files using SDC formatting to describe virtual clock frequencies, input/output delays, and load configurations.
* **Critical Path Extraction**: Tracked Worst Slack paths, learning how logic cell transitions (`INVX1`, `OAI21X1`) and physical routing contribute to timing delays.
* **Slack Diagnostics**: Analyzed positive vs negative slacks to verify timing closure margins under varying frequencies (10ns setup met, 5ns setup violated).
* **Multi-Tool Integration Flow**: Developed a professional digital design bridge by feeding synthesized gate netlists from Yosys directly into OpenSTA for verification.
