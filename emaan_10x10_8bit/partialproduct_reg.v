`timescale 1ns / 1ps

module partialproduct_reg #(parameter DATA_WIDTH = 8)(
  input wire clk,                                // Clock signal
  input wire reset_n,                            // Active-low reset
  input wire en_PPReg,                           // Enable signal
  input wire [(DATA_WIDTH*2)-1:0] inData,        // Input data
  input wire cin,                                // Carry input
  output reg [(DATA_WIDTH*2)-1:0] outData,       // Output data
  output reg cout                                // Carry output
);

always @(posedge clk or negedge reset_n) begin
  if (!reset_n) begin
    // Reset outputs to high-impedance state
    outData <= {((DATA_WIDTH*2)){1'bz}};
    cout <= 1'bz;
  end else if (en_PPReg == 1'b1) begin
    // Update outputs when enabled
    outData <= inData;
    cout <= cin;
  end
end

endmodule
