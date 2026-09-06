
# Physical Design Exploration using OpenLane

## Overview

Designed and implemented the physical layout of a **4-to-16 Decoder** using the open-source **OpenLane ASIC Flow**. This project demonstrates the complete automated RTL-to-GDSII digital implementation pipeline, mapping behavioral Verilog code to a manufacturing-ready chip layout.

## Description

The OpenLane flow automates the tedious, manual steps involved in silicon manufacturing preparation. In this lab, a 4-to-16 Line Decoder is developed as the target design block. It accepts a 4-bit binary input and asserts exactly one of its 16 output lines, which is modeled as:
$$\text{out}[i] = 1 \quad \text{if and only if} \quad \text{in} = i$$

OpenLane processes this design by running Yosys synthesis, floorplanning, global/detailed placement, Clock Tree Synthesis (CTS), global/detailed routing, and sign-off validations (such as DRC, LVS, and antenna checks). The final output is a verified, DRC-clean GDSII stream file ready for chip tapeout and manufacturing.

---

## Files

* `decoder.v` - Behavioral RTL Verilog design file of the 4-to-16 decoder.
* `config.json` - JSON file specifying critical physical design configurations, routing guides, and clock settings.
* `flow.tcl` - Execution script driving the underlying tools through the automated design stages.

---

## Tools Used

* **OpenLane** (ASIC flow execution platform)
* **Yosys** & **OpenSTA** (Synthesis and Timing sign-off)
* **OpenROAD** (Floorplanning, Placement, CTS, and Routing engine)
* **Magic** & **KLayout** (DRC checks, SPICE extraction, and layout visualization)
* **Netgen** (LVS - Layout vs. Schematic verification)

---

## Code and Configuration

### 1. RTL Decoder Design (`decoder.v`)
```verilog
module decoder (
    input wire [3:0] in,
    output reg [15:0] out
);
    always @(*) begin
        out = 16'b0;  // Default: all outputs low
        case (in)
            4'b0000: out[ 0] = 1'b1;
            4'b0001: out[ 1] = 1'b1;
            4'b0010: out[ 2] = 1'b1;
            4'b0011: out[ 3] = 1'b1;
            4'b0100: out[ 4] = 1'b1;
            4'b0101: out[ 5] = 1'b1;
            4'b0110: out[ 6] = 1'b1;
            4'b0111: out[ 7] = 1'b1;
            4'b1000: out[ 8] = 1'b1;
            4'b1001: out[ 9] = 1'b1;
            4'b1010: out = 1'b1;
            4'b1011: out = 1'b1;
            4'b1100: out = 1'b1;
            4'b1101: out = 1'b1;
            4'b1110: out = 1'b1;
            4'b1111: out = 1'b1;
            default: out = 16'b0;
        endcase
    end
endmodule
```

### 2. Configuration Settings (`config.json`)
```json
{
  "DESIGN_NAME": "decoder",
  "VERILOG_FILES": "dir::src/*.v",
  "RUN_CTS": false,
  "CLOCK_PORT": null,
  "PL_RANDOM_GLB_PLACEMENT": true,
  "FP_SIZING": "absolute",
  "DIE_AREA": "0 0 34.5 57.12",
  "PL_TARGET_DENSITY": 0.75,
  "FP_PDN_AUTO_ADJUST": false,
  "FP_PDN_VPITCH": 25,
  "FP_PDN_HPITCH": 25,
  "FP_PDN_VOFFSET": 5,
  "FP_PDN_HOFFSET": 5,
  "DIODE_INSERTION_STRATEGY": 3
}
```

---

## Interactive Design Execution Flow

OpenLane can be run in **interactive mode**, allowing stage-by-stage analysis and execution:

```tcl
# 1. Start the OpenLane flow environment in interactive shell
flow.tcl -interactive

# 2. Prepare the design workspace for the decoder project
prep -design decoder

# 3. Perform Logic Synthesis & Timing Analysis
run_synthesis

# 4. Initialize physical boundaries (Floorplanning)
run_floorplan

# 5. Execute cell Placement (Global and Detailed)
run_placement

# 6. Run Clock Tree Synthesis (CTS)
run_cts

# 7. Complete Metal Interconnection Routing
run_routing

# 8. Generate physical GDSII layout and run DRC checks
run_magic
run_magic_drc

# 9. Perform LVS comparative netlist checks
run_lvs
```

---

## Results & Sign-off Validation

The physical implementation completed successfully through all design verification stages:
* **Timing Closure**: Achieved positive timing slacks across all environmental corners with zero setup or hold violations.
* **DRC Verification**: Layout verified clean under Magic and KLayout rule decks with 0 Design Rule Checker violations.
* **LVS Verification**: The physical layout perfectly matched the logical design schematic (LVS matched netlist).
* **GDSII Stream**: Generated the final manufacturing layout stream file (`decoder.gds`) verified ready for ASIC fabrication and tapeout.

### Final Physical Layout (GDSII View)

Below is the visualized micro-architecture layout of the 4-to-16 decoder. Standard cell logical components are densely aligned, interconnected via routing layers, and protected by ring-shaped Power Distribution Network (PDN) stripes.

<img width="184" height="149" alt="image" src="https://github.com/user-attachments/assets/56b7dc93-6262-4596-940b-49a23259d505" />

---

## Learning Outcome

* **RTL-to-GDSII Automated Pipelines**: Acquired hands-on experience navigating the complete ASIC physical design cycle using automated, open-source tool chains.
* **Floorplanning and Power Grids**: Configured absolute DIE dimensions, utilization densities, and adjusted power grid straps.
* **Design Rule Checking (DRC) and LVS**: Learned to identify and correct physical layout violations to ensure clean silicon layout-versus-schematic matching.
* **Interactive Tool Tuning**: Mastered the execution of interactive TCL scripts for micro-benchmarking individual physical steps.
