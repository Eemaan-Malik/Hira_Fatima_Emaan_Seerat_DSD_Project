`timescale 1ns / 1ps

module Matrix_Multiply(
	input clk, rst, start,
	input [26:0] matrixA, matrixB,
	output reg [53:0] result
    );

reg [2:0] matA [0:8];
reg [2:0] matB [0:8];
reg [5:0] matR [0:8];
reg [5:0] temp;
integer m, n, r, c, i;

reg [3:0] count;


always @ (posedge clk or posedge rst) begin
if (rst) begin 
	for (m = 0; m < 9; m = m + 1) begin
		matA[m] <= 0; 
		matB[m] <= 0;
		matR[m] = 0;
	end
	count = 0;
	temp = 0;
	result<=0;
end
else begin
	if (start) begin
			for (m = 0; m < 9; m = m + 1) begin
				matA[m] <= matrixA[m * 3 +: 3]; 
				matB[m] <= matrixB[m * 3 +: 3];
			end

			count = 0;
			
			for (r=0; r<3; r=r+1) begin
				for (c=0; c<3; c=c+1) begin
					temp = 0;
					for (i=0; i<3; i=i+1) begin
						temp = temp + (matA[(r*3)+i] * matB[(i*3)+c]);
					end
					matR[count] = temp;
					count = count + 1;
				end
			end
			
			result <= {matR[8], matR[7], matR[6], matR[5], matR[4], 
							matR[3], matR[2], matR[1], matR[0]};
		
		end
	end
end
endmodule
