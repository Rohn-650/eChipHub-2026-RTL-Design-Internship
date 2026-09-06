
# RISC-V Processor Architecture

## Overview

Configured and simulated a parameterized **PicoRV32 RISC-V CPU** core to execute bare-metal instructions. This project validates base-level execution and instruction fetches in an in-order RTL processing environment.

## Description

The PicoRV32 CPU core implements the **RV32I Base Integer Instruction Set**:
* **32 General-Purpose Registers** (`x0`–`x31`), where `x0` is hardwired to constant zero.
* Support for **6 core instruction formats** (R, I, S, B, U, J).
* **Native Memory Interface**: Speaks a simple, stall-based handshake protocol using output signal `mem_valid` (valid request) and input `mem_ready` (target ready).
* **Boot Sequence**: Execution begins at physical address `0x00000000` (`PROGADDR_RESET`).

## Files

* `rtl/PicoRV32/picorv32.v` - Main PicoRV32 CPU RTL processor module.
* `rtl/PicoRV32/Memory.v` - Simple instruction and data memory model.
* `rtl/PicoRV32/tb_processor.v` - Testbench verifying execution and dumping waveforms.

## Tools Used

* Verilog HDL
* Verilator
* GTKWave

## Results

### Simulation Trace Log
```text
[ROM] loaded from parameter: ...
-- Simulation Complete --
```

### Waveform

The standalone testbench outputs `tb_picorv32.vcd` which tracks the step-by-step CPU instruction fetches.

<img width="832" height="365" alt="image" src="https://github.com/user-attachments/assets/f43edc68-a6e7-4f3b-bc7b-690a95320c68" />


**GTKWave Analysis:**
* **Instruction Fetch**: When `mem_valid` and `mem_instr` assert high, the CPU fetches an instruction from memory.
* **Sequential PC Increment**: The address bus `mem_addr[31:0]` increments by `4` on successive cycles (`0x00000000` \\(\rightarrow\\) `0x00000004` \\(\rightarrow\\) `0x00000008`), demonstrating correct PC increment behavior.
* **Stall-Free Handshake**: The internal testbench memory asserts `mem_ready` high on the same cycle as `mem_valid`, proving zero-wait-state instruction processing. At boot (`mem_addr = 0x00`), the read data output `mem_rdata` returns the instruction word `0x00020137` (decoding to `LUI x2, 0x20` to initialize the stack pointer).

## Learning Outcomes

* **RV32I Architecture**: Mastered register file structures, fixed 32-bit instruction formats, and the RISC processor design model.
* **Stall-Based Handshaking**: Handled CPU-to-memory transactions using a stall-based memory interface (`mem_valid`/`mem_ready`).
* **Instruction Parsing**: Tracked software program counter updates and instruction memory fetches inside waveform displays.

