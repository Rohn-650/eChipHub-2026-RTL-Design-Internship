module and_gate_tb;

    reg A;
    reg B;
    wire out;

    and_gate_design uut (
        .A(A),
        .B(B),
        .out(out)
    );

    initial begin
        $display("time=%t A=%0b B=%0b out=%b", $time, A, B, out);
        $monitor("time=%t A=%0b B=%0b out=%b", $time, A, B, out);

        #10;
        A = 1'b0; B = 1'b0; #10;
        A = 1'b0; B = 1'b1; #10;
        A = 1'b1; B = 1'b0; #10;
        A = 1'b1; B = 1'b1; #10;

        $finish;
    end

    initial begin
        $dumpfile("and_gate_dump.vcd");
        $dumpvars();
    end

endmodule