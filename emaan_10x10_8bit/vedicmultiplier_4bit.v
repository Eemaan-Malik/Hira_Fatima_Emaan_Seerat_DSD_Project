`timescale 1ns / 1ps

module vedicmultiplier_4bit #(parameter DATA_WIDTH = 8)(
  input  wire [(DATA_WIDTH/2)-1:0] inData_A, // Input wires
  input  wire [(DATA_WIDTH/2)-1:0] inData_B, // Input wires
  output wire [DATA_WIDTH-1:0]     outData_C // Output wire
);

wire [3:0] out0_15_12, out0_11_8, out0_7_4, out0_3_0; // Wires for 2-bit multiplier outputs
wire [5:0] out1, out2;                                // Intermediate wires for addition
wire [5:0] result1, result2;                         // Result wires for addition

// Instantiate 2-bit Vedic multipliers
vedicmultiplier_2bit VD0(
  .inData_A(inData_A[3:2]), 
  .inData_B(inData_B[3:2]), 
  .outData_C(out0_15_12)
);

vedicmultiplier_2bit VD1(
  .inData_A(inData_A[1:0]), 
  .inData_B(inData_B[3:2]), 
  .outData_C(out0_11_8)
);

vedicmultiplier_2bit VD2(
  .inData_A(inData_A[3:2]), 
  .inData_B(inData_B[1:0]), 
  .outData_C(out0_7_4)
);

vedicmultiplier_2bit VD3(
  .inData_A(inData_A[1:0]), 
  .inData_B(inData_B[1:0]), 
  .outData_C(out0_3_0)
);

// Perform intermediate additions
assign out1     = {out0_15_12, 2'b00};       // Shift left by 2
assign out2     = {2'b00, out0_11_8};        // Shift right by 2
assign result1  = out1 + out2;               // Add intermediate results
assign result2  = result1 + {2'b00, out0_7_4} + {4'b0000, out0_3_0[3:2]}; // Add final results

// Assign final output
assign outData_C = {result2[5:0], out0_3_0[1:0]}; // Concatenate results

endmodule
