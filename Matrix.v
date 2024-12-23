`timescale 1ns / 1ps

module Matrix(
	input rst,
	output reg [26:0] mat_out
    );

wire [2:0] mat [0:8];

assign 	mat[0] = 3'd 1;
assign 	mat[1] = 3'd 2;
assign	mat[2] = 3'd 3;
assign	mat[3] = 3'd 3;
assign	mat[4] = 3'd 2;
assign	mat[5] = 3'd 1;
assign	mat[6] = 3'd 1;
assign	mat[7] = 3'd 2;
assign	mat[8] = 3'd 3;

always @ (posedge rst) begin
	mat_out = {mat[8], mat[7], mat[6], mat[5], mat[4], 
              mat[3], mat[2], mat[1], mat[0]};
end

endmodule
