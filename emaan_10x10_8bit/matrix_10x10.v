`timescale 1ns / 1ps

module matrix_10x10 #(parameter DATA_WIDTH=8)(
  input   wire clk,
  input   wire en_ReadMat,
  input   wire en_WriteMat,
  input   wire [3:0] rowAddr,
  input   wire [3:0] colAddr,
  input   wire [DATA_WIDTH-1:0] writeData,
  output  reg [DATA_WIDTH-1:0] readData
);

  reg [DATA_WIDTH-1:0] matrix_MemBlock [0:9][0:9];

  // Write operation
  always @(posedge clk) begin
    if (~en_ReadMat && en_WriteMat) begin           // write data
      if (rowAddr < 10 && colAddr < 10)
        matrix_MemBlock[rowAddr][colAddr] <= writeData;
    end
  end

  // Read operation
  always @(posedge clk) begin
    if (en_ReadMat && ~en_WriteMat) begin           // read data
      if (rowAddr < 10 && colAddr < 10)
        readData <= matrix_MemBlock[rowAddr][colAddr];
    end
  end

endmodule
