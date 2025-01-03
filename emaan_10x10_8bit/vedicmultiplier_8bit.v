`timescale 1ns / 1ps

module vedicmultiplier_8bit #(parameter DATA_WIDTH = 8)(
  input  wire [DATA_WIDTH-1:0] inData_A,        // 8-bit Input A
  input  wire [DATA_WIDTH-1:0] inData_B,        // 8-bit Input B
  output wire [(DATA_WIDTH*2)-1:0] outData_C    // 16-bit Output C
);

  // Internal wire declarations
  wire [31:0] out0;         // Intermediate results
  wire [11:0] out1, out2;   // Intermediate shifted values
  wire [11:0] result1, result2; // Final results before assigning to output

  // Instantiate 4-bit Vedic multipliers
  vedicmultiplier_4bit VD0 (
    .inData_A(inData_A[7:4]),
    .inData_B(inData_B[7:4]),
    .outData_C(out0[31:24])
  );
  
  vedicmultiplier_4bit VD1 (
    .inData_A(inData_A[3:0]),
    .inData_B(inData_B[7:4]),
    .outData_C(out0[23:16])
  );
  
  vedicmultiplier_4bit VD2 (
    .inData_A(inData_A[7:4]),
    .inData_B(inData_B[3:0]),
    .outData_C(out0[15:8])
  );
  
  vedicmultiplier_4bit VD3 (
    .inData_A(inData_A[3:0]),
    .inData_B(inData_B[3:0]),
    .outData_C(out0[7:0])
  );

  // Perform addition and shifting to combine results
  assign out1 = {out0[31:24], 4'b0};
  assign out2 = {4'b0, out0[23:16]};
  assign result1 = out1 + out2;
  assign result2 = result1 + {4'b0, out0[15:8]} + {8'b0, out0[7:4]};
  assign outData_C[15:0] = {result2[11:0], out0[3:0]};

endmodule
