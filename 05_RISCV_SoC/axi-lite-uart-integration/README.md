

# AXI-Lite Interconnect

## Overview

Designed and verified an **AXI4-Lite Interconnect Bridge** in Verilog HDL. This bridge acts as a protocol converter, translating native processor memory handshakes into five-channel AMBA AXI-Lite system transactions.

## Description

Because the PicoRV32's native interface uses a single, simple channel with one valid/ready pair, it cannot connect directly to AXI peripherals. The bridge translates CPU requests using a **5-State Finite State Machine (FSM)**:
1. **`ST_IDLE`**: Waits for the CPU memory transaction trigger.
2. **`ST_WR_AW` / `ST_RD_AR`**: Initiates corresponding AXI address and write channels.
3. **`ST_WR_B` / `ST_RD_R`**: Handshakes completion and returns read data (`mem_rdata`) to the CPU.

The system decodes addresses to partition ROM (`0x0000_0000`), SRAM (`0x0001_0000`), and UART (`0x1000_0000`) targets.

## Files

* `rtl/top.v` - Top-level module housing the CPU-to-AXI bridge.
* `rtl/axi_lite_interconnect.v` - Manages crossbar interconnect operations.
* `tb/tb_riscv_axi_lite.v` - Self-contained testbench demonstrating step-by-step AXI handshakes.

## Tools Used

* Verilog HDL
* Verilator
* GTKWave

## Results

### Simulation Console Log
Executing `make riscv_axi` launches simulation verification, capturing write handshakes (`awvalid` & `awready`) and read back data transactions cleanly:
```text
-------------------------------
[50 ns] AXI WRITE TRANSACTION
-------------------------------
AWADDR  = 0x10000000   AWVALID = 1 -> AWREADY = 1
WDATA   = 0x000000A5   WVALID  = 1 -> WREADY  = 1
Result: Data 0xA5 successfully written to address 0x10000000
```

### Waveform

The generated timing trace file `tb_riscv_axi_lite.vcd` displays the precise coordination across five independent AXI channels.

<img width="772" height="363" alt="image" src="https://github.com/user-attachments/assets/303bf223-3f56-4d81-af2d-614acc4e2063" />


**GTKWave Analysis:**
* **Write Transaction (50 ns)**: The bridge asserts `m_awvalid` and `m_wvalid` simultaneously to post address `0x10000000` and payload data `0x000000A5`. Channel handshakes complete in 1 clock cycle as the slave returns both `s_awready = 1` and `s_wready = 1`. 
* **Response Channel (B)**: The transaction finishes when the slave asserts `s_bvalid = 1`, prompting the master to acknowledge with `m_bready = 1` and transition back to idle.
* **Read Transaction (110 ns)**: Initiated by asserting `m_arvalid` to transmit address `0x10000000`. The slave handshakes the read request via `s_arready = 1`, and serves the parallel read value `s_rdata = 0xA5` while asserting `s_rvalid = 1`.

## Learning Outcomes

* **Protocol Bridges**: Modeled complex, multi-channel state machines to bridge incompatible processor buses.
* **AXI4-Lite Handshaking**: Mastered the five independent address, data, and response channel handshakes.
* **Dynamic Interconnect Routing**: Routed standard master transactions to distinct slave blocks using custom address decoders.

***

# UART Peripheral Integration

## Overview

Integrated an **AXI4-Lite UART Peripheral** into the RISC-V SoC system. This establishes a hardware-software interface allowing bare-metal C programs to execute serial communications via memory-mapped I/O (MMIO) registers.

## Description

The AXI-UART wrapper (`uart_axi.v`) acts as an adapter, translating parallel AXI register reads/writes into physical asynchronous serial bitstreams (`tx_out` / `uart_rx`):
* **TX Register (`0x1000_0000`)**: A write to this offset buffers data and triggers physical serialization.
* **RX Register (`0x1000_0004`)**: Read transaction retrieves received parallel bytes.
* **Status Register (`0x1000_0008`)**: Reads current UART flags (bit `1` indicates `rx_buf_valid` status).

To prevent silent byte loss, a physical write backpressure mechanism drops `s_axi_awready` and `s_axi_wready` low when the transmitter buffer (`buf_valid`) is busy, stalling the CPU until the port clears.

## Files

* `rtl/uart_axi.v` - AXI4-Lite slave wrapper for the underlying UART core.
* `fw/main.c` - Bare-metal C firmware driving the serial peripheral via pointers.
* `tb/tb_axi_lite.v` - End-to-end SoC verification testbench.

## Tools Used

* GCC RISC-V Toolchain (for compiling bare-metal C programs to target memory hex files)
* Verilator
* GTKWave

## Results

### Simulation Console Log
```text
[AXI WRITE] addr=0x10000000 data=0x48 ('H') → Writing to UART TX
[UART TX] Transmitting: 0x48 ('H')
[AXI READ] addr=0x10000008 → Reading UART status: RX data available
[AXI READ] addr=0x10000004 → Reading UART RX data: rx_data=0x48 ('H')
[TEST] Loopback data matches → PASS
```

### Waveform

The loopback testbench records transactions in `tb_axi_lite.vcd`, tracking parallel system writes converting to physical serial lines.

<img width="767" height="381" alt="image" src="https://github.com/user-attachments/assets/b4803539-2dc9-4818-82f1-cd5fb4286d3d" />


**GTKWave Analysis:**
* **TX Capture**: Writing `0x48 ('H')` to the transmitter address `0x10000000` causes the AXI wrapper to capture the write data and toggle `uart_axi.buf_valid` high.
* **Serial Encoding**: When `buf_valid` goes high, the internal transmitter shifts state from `IDLE` to `START`. The output pin `tx_out` pulls low for 1 start bit period (approx 8.68 µs at 115200 baud), followed by the 8-bit serial payload `01001000` (LSB first for character `H`).
* **RX Buffer Handshake**: The serial line loops back to `uart_rx`, shifting serial data back into a parallel block. On compiling the stop bit, `uart_axi.rx_buf_valid` pulls high. An AXI read transaction to the data register (`0x10000004`) pulls `rx_buf_valid` low again, resetting the receiver buffers.

## Learning Outcomes

* **Memory-Mapped I/O (MMIO)**: Exceeded basic circuit designs by mapping system addresses directly to control registers.
* **Flow Backpressure Control**: Implemented zero-byte-loss handshakes using hardware write stalls.
* **Bare-metal C Drivers**: Programmed efficient hardware loops and register manipulation structures directly in low-level firmware.
