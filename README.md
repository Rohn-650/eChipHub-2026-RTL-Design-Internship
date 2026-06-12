# eChipHub Summer 2026 Internship

## RTL Design, Verification and SoC Design Flow

This repository contains my work and learning outcomes from the **eChipHub Internship Program (Summer 2026)**, an 8-week instructor-guided program focused on semiconductor design, RTL development, verification, synthesis and SoC implementation flow.

The internship provided practical exposure to the complete digital IC design flow starting from RTL development to physical design concepts.

---

## Internship Overview

**Program:** eChipHub Internship Program (Summer 2026)
**Duration:** 8 Weeks
**Domain:** RTL Design | Verification | SoC Design | ASIC Flow

---
## Development Environment

The internship activities were performed using the ChipCraft Virtual Lab environment, providing a Linux-based semiconductor design workspace with open-source EDA tools.
<img width="960" height="540" alt="Screenshot 2026-06-05 140330" src="https://github.com/user-attachments/assets/d2c17981-0363-4b5a-96f9-3ba878a7501e" />

# Objectives

* Understand digital IC design methodology
* Develop synthesizable RTL using Verilog
* Learn RTL verification using open-source tools
* Explore IP design and integration concepts
* Understand CDC/RDC challenges in multi-clock systems
* Learn RTL synthesis and timing analysis
* Explore RTL-to-GDSII ASIC flow
* Understand RISC-V based SoC subsystem integration

---

# Tools Used

| Tool        | Purpose                         |
| ----------- | ------------------------------- |
| Verilator   | RTL simulation and verification |
| Yosys       | RTL synthesis                   |
| OpenSTA     | Static Timing Analysis          |
| OpenLane    | RTL-to-GDSII flow exploration   |
| GTKWave     | Waveform analysis               |
| Linux / Vim | Development environment         |

---

# Topics Covered

## 1. Verilog and RTL Fundamentals

Implemented and verified basic digital blocks:

* AND Gate
* 4x1 Multiplexer
* Half Adder
* Flip-Flop based designs
* Counter designs
* UART Receiver

Concepts covered:

* Verilog syntax
* Module hierarchy
* Behavioral modeling
* Structural modeling
* Synthesizable RTL coding style

---

# 2. RTL Design and Verification

Worked on RTL development following:

Specification → RTL Design → Verification

Verification activities included:

* Testbench development
* Simulation using Verilator
* Waveform debugging
* Functional checking

---

# 3. Bus Interfaces and IP Integration

Explored subsystem level integration concepts:

* APB protocol basics
* Signal interfacing
* Peripheral communication
* UART based IP integration

---

# 4. Clock Domain Crossing (CDC) and Reset Domain Crossing (RDC)

Studied reliability challenges in multi-clock systems.

Topics:

* Metastability
* Synchronization techniques
* Multi-stage synchronizers
* Reset synchronization
* Asynchronous FIFO concepts

---

# 5. RTL Synthesis using Yosys

Explored RTL-to-netlist conversion.

Covered:

* RTL parsing
* Elaboration
* Optimization
* Technology mapping
* Synthesis reports
* Coding style impact on hardware

---

# 6. Static Timing Analysis

Explored timing analysis concepts:

* Setup time
* Hold time
* Clock skew
* Timing constraints
* Liberty (.lib) files
* Timing reports using OpenSTA

---

# 7. Physical Design Flow

Studied the complete ASIC implementation flow:

RTL
↓
Synthesis
↓
Floorplanning
↓
Placement
↓
Clock Tree Synthesis
↓
Routing
↓
GDSII Generation

Concepts covered:

* Standard cells
* LEF/DEF formats
* Parasitics
* DRC/LVS concepts
* Physical design awareness

---

# 8. RISC-V SoC Design Exploration

Explored integration of processor based systems.

Topics:

* RISC-V ISA basics
* AXI4-Lite communication
* UART peripheral integration
* Memory mapped interfaces
* SoC subsystem architecture
* RTL verification approach

---

# Repository Structure

```
01_Verilog_Fundamentals
02_RTL_Design
03_APB_Interface
04_CDC_RDC
05_Yosys_Synthesis
06_OpenSTA_Timing
07_OpenLane_Physical_Design
08_RISC-V_SoC
```

---

# Key Learning Outcomes

* Improved RTL coding skills using Verilog
* Understanding of digital IP development flow
* Hands-on exposure to open-source semiconductor tools
* Better understanding of verification methodology
* Familiarity with ASIC design flow
* Understanding of SoC level integration concepts

---

## Acknowledgement

Thanks to the eChipHub team for providing structured hands-on exposure to semiconductor design methodologies and open-source EDA tools.

---

**Author:** Rohn Eldho
**Domain:** Electronics and Communication Engineering
