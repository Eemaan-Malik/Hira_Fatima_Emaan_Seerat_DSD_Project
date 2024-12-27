`timescale 1ns / 1ps

module finaldata_reg #(parameter DATA_WIDTH = 8)(
  input wire clk,                           // Clock signal
  input wire reset_n,                       // Active-low reset
  input wire en_FDReg,                      // Enable signal
  input wire [DATA_WIDTH*2:0] inData,       // Input data
  output reg [DATA_WIDTH-1:0] outData,      // Output data
  output reg resultIsInvalid               // Invalid result flag
);

always @(posedge clk or negedge reset_n) begin
  if (!reset_n) begin
    // Active-low reset: set outputs to high-impedance state
    outData <= {DATA_WIDTH{1'bz}};
    resultIsInvalid <= 1'bz;
  end else if (en_FDReg) begin
    // When enabled, evaluate inputs and set outputs
    resultIsInvalid <= (inData > 8'hff) ? 1'b1 : 1'b0;
    outData <= (inData < 8'hff) ? inData[DATA_WIDTH-1:0] : {DATA_WIDTH{1'bz}};
  end
end

endmodule
