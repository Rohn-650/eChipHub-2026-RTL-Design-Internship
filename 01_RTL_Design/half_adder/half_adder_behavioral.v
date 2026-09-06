`timescale 1ns/1ps  // Time unit = 1ns, time precision = 1ps 
module half_adder_behavioral( 
input a,         // First input bit 
input b,         // Second input bit 
output reg sum,  // Sum output (a XOR b) 
output reg carry // Carry output (a AND b) 
); 
//Combinational logic block triggered on changes to 'a' or 'b' 
always @(a or b) begin 
sum = a ^ b;      // XOR for sum 
carry = a & b;    // AND for carry 
end 
endmodule
