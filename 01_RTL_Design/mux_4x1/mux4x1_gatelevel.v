// 4x1 Multiplexer - Gate Level Modeling
 using basic gates
`timescale 1ns/1ps

module mux4x1_gatelevel (
    input [3:0] in,    // 4-bit input vector
    input [1:0] sel,   // 2-bit select input
    output out         // Output
);

    wire not_s0, not_s1;
    wire and0, and1, and2, and3;

    // Inverter gates
    not (not_s0, sel[0]);
    not (not_s1, sel[1]);

    // AND gates
    and (and0, not_s1, not_s0, in[0]);
    and (and1, not_s1, sel[0], in[1]);
    and (and2, sel[1], not_s0, in[2]);
    and (and3, sel[1], sel[0], in[3]);

    // OR gate
    or (out, and0, and1, and2, and3);

endmodule