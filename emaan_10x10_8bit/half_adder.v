`timescale 1ns / 1ps

module half_adder(
  input   wire a,      // Use wire for inputs
  input   wire b,      // Use wire for inputs
  output  wire sum,    // Use wire for outputs
  output  wire cout    // Use wire for outputs
);

assign sum = a ^ b;     // XOR operation for sum
assign cout = a & b;    // AND operation for carry out

endmodule
