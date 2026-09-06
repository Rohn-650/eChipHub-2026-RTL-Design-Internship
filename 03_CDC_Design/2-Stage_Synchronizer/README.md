
# Two-Stage Synchronizer (CDC Synchronizer)

## Overview

Designed and verified a **Two-Stage Synchronizer** module in Verilog HDL to handle asynchronous clock inputs and mitigate **Metastability** risks. The design was verified via simulation under **Verilator** and timing waveforms were validated using **GTKWave**.

## Description

Metastability is a hardware reliability hazard that occurs when an asynchronous signal is directly sampled by synchronous sequential logic (violating setup and hold timing requirements). This can result in unstable, intermediate, or oscillating voltage levels on a register's output, potentially propagating logical corruption throughout the rest of your system.

A **Two-Stage Synchronizer** (or dual flip-flop synchronizer) is the industry-standard solution for safely transferring a slow asynchronous signal into a fast destination clock domain:
1. **First-Stage Flip-Flop (`stage1`)**: Samples the asynchronous input on the rising edge of the local clock. While its output might occasionally enter a metastable state due to setup/hold violations, it is given a full clock period to resolve.
2. **Second-Stage Flip-Flop (`synced`)**: Samples the output of the first stage on the next clock edge. By this point, any metastable fluctuations have (with extremely high probability) resolved into a stable logic `0` or `1`.
3. **Outcome**: The synced output is safe, stable, and synchronous to the destination clock domain, introduced with a deterministic **one-cycle latency delay**.

### Key Applications
* Interfacing external asynchronous I/O signals (like push-buttons, switches, or asynchronous UART Rx streams) with high-speed system clocks.
* Safe Clock Domain Crossing (CDC) data transitions in FPGA, ASIC, and SoC architectures.

## Files

* `cdc_sync.v` - RTL design file implementing the two-stage synchronizer.
* `cdc_sync_tb.v` - Testbench applying non-clock-aligned asynchronous stimulus to stress-test the synchronizer.
* `run.sh` - Automated bash script to compile and run the simulation using Verilator and launch GTKWave.

## Tools Used

* Verilog HDL
* Verilator (Simulation engine)
* GTKWave (Waveform viewer)

---

## Verilog Code Implementation

### 1. Design File (`cdc_sync.v`)
```verilog
// 2-stage synchronizer module to handle asynchronous input
// Clock Domain Crossing (CDC) mitigation
`timescale 1ns/1ps

module cdc_synchronizer (
    input  wire clk,       // Destination clock input
    input  wire async_in,  // Asynchronous input signal
    output reg  synced     // Synchronized output signal
);

    reg stage1;            // First-stage flip-flop register

    // Two-stage D Flip-Flop chain clocked by the destination domain
    always @(posedge clk) begin
        stage1 <= async_in; // Sample asynchronous input
        synced <= stage1;   // Shift to second stage (output is stable)
    end

endmodule
```

### 2. Testbench File (`cdc_sync_tb.v`)
```verilog
// Testbench for CDC synchronizer
`timescale 1ns/1ps

module cdc_sync_tb;
    reg clk = 0;           // Destination clock signal
    reg async_in = 0;      // Asynchronous input stimulus
    wire synced;           // Output from synchronizer

    // Clock generation (10ns period -> 100 MHz clock domain)
    always #5 clk = ~clk;

    // Instantiate the Unit Under Test (UUT)
    cdc_synchronizer uut (
        .clk(clk),
        .async_in(async_in),
        .synced(synced)
    );

    // Apply transitions NOT aligned to clock edges (simulating asynchronous inputs)
    initial begin
        \$dumpfile("dump.vcd");
        \$dumpvars(0, cdc_sync_tb);

        #12 async_in = 1;  // Toggles mid-cycle
        #7  async_in = 0;  // Toggles mid-cycle
        #6  async_in = 1;  // Toggles mid-cycle
        #9  async_in = 0;  // Toggles mid-cycle
        
        #50 \$finish;       // Ends the simulation
    end
endmodule
```

### 3. Automation Script (`run.sh`)
```bash
#!/bin/bash
# 1. Run Verilator to compile RTL and Testbench files
verilator --binary -j 0 -Wall cdc_sync.v cdc_sync_tb.v \
          --top cdc_sync_tb --timing --CFLAGS "-std=c++20" --trace

# 2. Navigate into compilation directory
cd obj_dir || { echo "Error: obj_dir not found"; exit 1; }

# 3. Build the testbench simulation binary
make -f Vcdc_sync_tb.mk Vcdc_sync_tb || { echo "Compilation failed"; exit 1; }

# 4. Run the simulation
./Vcdc_sync_tb || { echo "Simulation failed"; exit 1; }

# 5. Launch GTKWave waveform viewer
gtkwave dump.vcd
```

---

## Results

The design compiled successfully under Verilator without warnings. Running the simulation confirmed that the testbench successfully generated asynchronous transitions.

### Waveform Analysis

Using GTKWave to analyze `dump.vcd` confirms:
* **Stable Clock (clk)**: Operates with a regular 10ns period.
* **Asynchronous Input (async_in)**: Toggles at times not aligned to clock boundaries (e.g., at 12ns, 19ns, 25ns).
* **Clean Synchronization (synced)**: Outputs transition cleanly on the active rising edges of `clk` with exactly a one-clock-cycle propagation delay relative to `stage1`. No glitches, clock-jitter, or metastable states propagate to the output.

<img width="461" height="110" alt="image" src="https://github.com/user-attachments/assets/b521d6f5-ed47-426d-9234-a3f6e9291d08" />


---

## Learning Outcome

* **Understanding Metastability**: Studied how asynchronous inputs violate setup and hold timing windows, creating metastable hazards in sequential logic.
* **Clock Domain Crossing (CDC) Protection**: Successfully implemented a synchronized two-register D Flip-Flop pipeline to absorb asynchronous inputs.
* **Timing-Stress Testbenches**: Designed clock-independent stimulus transitions to verify synchronization efficacy under severe timing variations.
* **Simulation Verification**: Compiled and simulated CDC behaviors using Verilator and performed waveform analysis inside GTKWave.
