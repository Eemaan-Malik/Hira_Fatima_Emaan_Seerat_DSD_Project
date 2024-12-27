`timescale 1ns / 1ps

module vedicmultiplier_2bit(
  input   wire [1:0] inData_A, // Inputs should be wires
  input   wire [1:0] inData_B, // Inputs should be wires
  output  wire [3:0] outData_C // Outputs can also be wires
);

wire [3:0] w; // Intermediate signals must be declared as wire

// Perform bitwise AND operations
assign outData_C[0] = inData_A[0] & inData_B[0];
assign w[0] = inData_A[1] & inData_B[0];
assign w[1] = inData_A[0] & inData_B[1];
assign w[2] = inData_A[1] & inData_B[1];

// Instantiate half adders
half_adder HA0(.a(w[0]), .b(w[1]), .sum(outData_C[1]), .cout(w[3]));
half_adder HA1(.a(w[2]), .b(w[3]), .sum(outData_C[2]), .cout(outData_C[3]));

endmodule
