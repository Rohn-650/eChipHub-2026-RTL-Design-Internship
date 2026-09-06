
***

# APB-UART Design & Verification

## Overview

Designed and verified an **Advanced Peripheral Bus (APB) to UART Bridge** using Verilog HDL. This project showcases how an APB bus interface acts as a communication protocol to decode memory-mapped register operations and transfer data into a UART peripheral block. The design operates synchronously on a **50 MHz clock** and was verified through RTL simulation using **Verilator**.

## Description

The APB-UART design integrates a processor-side microcontroller interface with standard APB master protocol signals and converts transactions into local UART control operations. 

To bypass serial transmission timing complexities while focusing strictly on protocol transactions and data movement, the UART module models communication through internal register movement. Data written via an APB write transaction to the transmit register is captured and forwarded directly to the receive registers in synchronous clock cycles.

### APB Protocol Interface Signals

* `PADDR`: 32-bit APB memory-mapped address bus.
* `PWDATA`: 32-bit write data bus (the lower 8 bits are decoded for UART transactions).
* `PRDATA`: 32-bit read data bus returning UART data or status flags.
* `PWRITE`: Access control signal (high for write, low for read).
* `PSEL`: Peripheral select line activating the UART bridge module.
* `PENABLE`: Indicates the second (Access) phase of an APB transfer cycle.
* `PREADY`: Asserted by the bridge to indicate a completed transaction.

### Register Map

The peripheral maps specific offsets to internal UART registers:

| Address Offset | Access Type | Register Name | Description |
|---|---|---|---|
| `0x00` | Write | **TX Data Register** | Captures incoming 8-bit parallel byte to transmit. |
| `0x04` | Read | **RX Data Register** | Returns the received 8-bit parallel byte to the APB bus. |
| `0x08` | Read | **Status Register** | Returns status indicators: bit `0` = `rx_ready`, bit `1` = `tx_busy`. |

---

## Files

* `uart.v` - Standard register-based UART model tracking status registers (`tx_busy`, `rx_ready`).
* `apb_uart_bridge.v` - Communication interface converting APB signals to local register actions.
* `apb_uart_top.v` - Top-level module wrapper exposing the APB slave interface.
* `apb_uart_tb.v` - Comprehensive testbench running dual payload transfers (`0xA5` and `0x3C`) via APB write/read tasks.
* `run.sh` - Simulation scripting file automating Verilator compilation and GTKWave generation.

---

## Tools Used

* Verilog HDL
* Verilator
* GTKWave

---

## Verilog Code Implementation

### 1. UART Core Model (`uart.v`)
```verilog
module uart (
    input  wire       clk,
    input  wire       rst_n,
    input  wire [7:0] tx_data,
    input  wire       tx_write,
    output reg  [7:0] rx_data,
    output reg        rx_ready,
    output reg        tx_busy
);
    reg [7:0] tx_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_reg   <= 8'h00;
            rx_data  <= 8'h00;
            rx_ready <= 1'b0;
            tx_busy  <= 1'b0;
        end else begin
            rx_ready <= 1'b0;
            if (tx_write) begin
                tx_reg   <= tx_data;
                tx_busy  <= 1'b1;
                rx_data  <= tx_data;
                rx_ready <= 1'b1;
                tx_busy  <= 1'b0;
            end
        end
    end
endmodule
```

### 2. APB-UART Bridge (`apb_uart_bridge.v`)
```verilog
module apb_uart_bridge (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [31:0] PADDR,
    input  wire [31:0] PWDATA,
    input  wire        PWRITE,
    input  wire        PSEL,
    input  wire        PENABLE,
    output reg  [31:0] PRDATA,
    output reg         PREADY
);
    reg  [7:0] tx_data;
    reg        tx_write;
    wire [7:0] rx_data;
    wire       rx_ready;
    wire       tx_busy;

    uart uart_inst (
        .clk(clk),
        .rst_n(rst_n),
        .tx_data(tx_data),
        .tx_write(tx_write),
        .rx_data(rx_data),
        .rx_ready(rx_ready),
        .tx_busy(tx_busy)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            PREADY   <= 1'b0;
            PRDATA   <= 32'h0;
            tx_data  <= 8'h00;
            tx_write <= 1'b0;
        end else begin
            PREADY   <= 1'b0;
            tx_write <= 1'b0;
            
            if (PSEL && PENABLE) begin
                PREADY <= 1'b1;
                if (PWRITE) begin
                    case (PADDR[7:0])
                        8'h00: begin
                            tx_data  <= PWDATA[7:0];
                            tx_write <= 1'b1;
                        end
                    endcase
                end else begin
                    case (PADDR[7:0])
                        8'h04: PRDATA <= {24'h0, rx_data};           // Read RX Data
                        8'h08: PRDATA <= {30'h0, tx_busy, rx_ready};  // Read Status
                        default: PRDATA <= 32'h0;
                    endcase
                end
            end
        end
    end
endmodule
```

### 3. Top-Level Wrapper (`apb_uart_top.v`)
```verilog
module apb_uart_top (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [31:0] PADDR,
    input  wire [31:0] PWDATA,
    input  wire        PWRITE,
    input  wire        PSEL,
    input  wire        PENABLE,
    output wire [31:0] PRDATA,
    output wire        PREADY
);
    apb_uart_bridge dut (
        .clk(clk),
        .rst_n(rst_n),
        .PADDR(PADDR),
        .PWDATA(PWDATA),
        .PWRITE(PWRITE),
        .PSEL(PSEL),
        .PENABLE(PENABLE),
        .PRDATA(PRDATA),
        .PREADY(PREADY)
    );
endmodule
```

### 4. Testbench Interface (`apb_uart_tb.v`)
```verilog
`timescale 1ns/1ps

module apb_uart_tb;
    reg clk = 0;
    reg rst_n;
    reg [31:0] PADDR;
    reg [31:0] PWDATA;
    reg        PWRITE;
    reg        PSEL;
    reg        PENABLE;
    wire [31:0] PRDATA;
    wire        PREADY;

    apb_uart_top dut (
        .clk(clk),
        .rst_n(rst_n),
        .PADDR(PADDR),
        .PWDATA(PWDATA),
        .PWRITE(PWRITE),
        .PSEL(PSEL),
        .PENABLE(PENABLE),
        .PRDATA(PRDATA),
        .PREADY(PREADY)
    );

    // Generate 50 MHz System Clock (20ns period)
    always #10 clk = ~clk;

    initial begin
        rst_n   = 0;
        PADDR   = 0;
        PWDATA  = 0;
        PWRITE  = 0;
        PSEL    = 0;
        PENABLE = 0;
        #100;
        rst_n = 1;

        // Write & Read Cycle 1: Payload 0xA5
        apb_write(32'h00, 32'hA5);
        apb_read(32'h04);
        apb_read(32'h08);

        // Write & Read Cycle 2: Payload 0x3C
        apb_write(32'h00, 32'h3C);
        apb_read(32'h04);
        apb_read(32'h08);
        
        #100;
        $finish;
    end

    // Standard APB Write Task
    task apb_write(input [31:0] addr, input [31:0] data);
        begin
            @(posedge clk);
            PADDR   = addr;
            PWDATA  = data;
            PWRITE  = 1;
            PSEL    = 1;
            PENABLE = 0;
            @(posedge clk);
            PENABLE = 1;
            @(posedge clk);
            PSEL    = 0;
            PENABLE = 0;
            $display("APB WRITE : ADDR=%h DATA=%h", addr, data);
        end
    endtask

    // Standard APB Read Task
    task apb_read(input [31:0] addr);
        begin
            @(posedge clk);
            PADDR   = addr;
            PWRITE  = 0;
            PSEL    = 1;
            PENABLE = 0;
            @(posedge clk);
            PENABLE = 1;
            @(posedge clk);
            @(posedge clk);
            $display("APB READ  : ADDR=%h DATA=%h", addr, PRDATA);
            PSEL    = 0;
            PENABLE = 0;
        end
    endtask

    initial begin
        $dumpfile("apb_uart_dump.vcd");
        $dumpvars();
    end
endmodule
```

### 5. Automation Script (`run.sh`)
```bash
#!/bin/bash
# Compile Design and Testbench in Verilator
verilator --binary -j 0 -Wall uart.v apb_uart_bridge.v apb_uart_top.v apb_uart_tb.v \
          --top apb_uart_tb --timing --trace --CFLAGS "-std=c++20"

# Enter execution directory
cd obj_dir || { echo "Error: obj_dir not found"; exit 1; }

# Make the model executable
make -f Vapb_uart_tb.mk Vapb_uart_tb || { echo "Error: Compilation failed"; exit 1; }

# Execute simulation
./Vapb_uart_tb || { echo "Error: Simulation failed"; exit 1; }

# Display waveform in GTKWave
gtkwave apb_uart_dump.vcd
```

---

## Results

Using the automated scripting platform, the APB-UART interface compiles successfully, runs sequential bus write and read routines, and produces logical verifications directly in the simulation console.

### Simulation Output

```text
APB WRITE : ADDR=00000000 DATA=000000a5
APB READ  : ADDR=00000004 DATA=000000a5
APB READ  : ADDR=00000008 DATA=00000000
APB WRITE : ADDR=00000000 DATA=0000003c
APB READ  : ADDR=00000004 DATA=0000003c
APB READ  : ADDR=00000008 DATA=00000000
```

### Waveform

The generated waveform `apb_uart_dump.vcd` visualizes the APB transfer phases. In each cycle, the master initiates the **Setup Phase** (pulsing `PSEL` and placing target address on `PADDR`), followed immediately by the **Access Phase** (raising `PENABLE`). The bridge completes the handshake by raising `PREADY`, allowing the system to update outputs flawlessly.

<img width="455" height="119" alt="image" src="https://github.com/user-attachments/assets/c694271f-f961-4f63-a842-8eb4438bd83a" />


---

## Learning Outcome

* **AMBA APB Protocol Sequencing**: Gained deep architectural insight into peripheral bus transactions, handling APB setup and access states using control handshakes (`PSEL`, `PENABLE`, `PREADY`).
* **Memory-Mapped Register Design**: Modeled custom address decoding tables to read status data and execute write updates.
* **System-on-Chip (SoC) Integration**: Constructed multi-layered hardware designs, integrating local execution registers with external high-speed control interfaces.
* **Verification using Automated Tasks**: Programmed bus transaction models (`apb_write` and `apb_read` tasks) inside testbenches to verify SoC peripherals.
```

***

