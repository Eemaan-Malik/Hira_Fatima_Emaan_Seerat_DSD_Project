`timescale 1ns / 1ps

module mux_2x1 #(parameter DATA_WIDTH=8)(
  input  wire [DATA_WIDTH-1:0] inData_A,   // Input A
  input  wire [DATA_WIDTH-1:0] inData_B,   // Input B
  input  wire sel,                         // Selector signal
  output reg [DATA_WIDTH-1:0] outData      // Output data
);

always @(*) begin
  case(sel)
    1'b0: outData = inData_A;              // If sel is 0, select inData_A
    1'b1: outData = inData_B;              // If sel is 1, select inData_B
    default: outData = {DATA_WIDTH{1'bz}}; // Default to high impedance (Z-state) for invalid sel
  endcase
end

endmodule
