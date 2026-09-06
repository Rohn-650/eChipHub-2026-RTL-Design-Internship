`timescale 1ns/1ps  // Time unit = 1ns, time precision = 1ps 
module half_adder_behavioral_tb; 
// Declare test inputs as reg and outputs as wire 
reg a, b; 
wire sum, carry; 
// Instantiate the Unit Under Test (UUT) 
half_adder_behavioral uut ( 
.a(a), 
.b(b), 
.sum(sum), 
.carry(carry) 
); 
// Stimulus block 
initial begin 
$display("Behavioral Half Adder Test"); 
$display("A B | Sum Carry"); 
$display("---------------------"); 
// Apply all input combinations 
a = 0; b = 0; #10 $display("%b %b |  %b   %b", a, b, sum, 
carry);  // 0 + 0 
end 
a = 0; b = 1; #10 $display("%b %b |  %b    %b", a, b, sum, 
carry);  // 0 + 1 
a = 1; b = 0; #10 $display("%b %b |  %b    %b", a, b, sum, 
carry);  // 1 + 0 
a = 1; b = 1; #10 $display("%b %b |  %b    %b", a, b, sum, 
carry);  // 1 + 1 
$finish;  // Ends the simulation 
// Dump VCD waveform for GTKWave 
initial begin 
$dumpfile("half_adder_behavioral.vcd");//(VCD output 
filename) 
$dumpvars(0, half_adder_behavioral_tb); // (Dump all 
signals in this testbench) 
end 
endmodule
