`timescale 1ns / 1ps

module Matrix_Multiply(
	input clk, rst, start,
	input [99:0] matrixA, matrixB,
	output reg [399:0] result
    );

reg matA [0:99];
reg matB [0:99];
reg [3:0] matR [0:99];
reg [3:0] temp;
integer m, n, r, c, i;

reg [6:0] count;


always @ (posedge clk or posedge rst) begin
if (rst) begin 
	for (m = 0; m < 99; m = m + 1) begin
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
			for (m = 0; m < 99; m = m + 1) begin
				matA[m] <= matrixA[m * 1 +: 1]; 
				matB[m] <= matrixB[m * 1 +: 1];
			end

			count = 0;
			
			for (r=0; r<10; r=r+1) begin
				for (c=0; c<10; c=c+1) begin
					temp = 0;
					for (i=0; i<10; i=i+1) begin
						temp = temp + (matA[(r*1)+i] * matB[(i*1)+c]);
					end
					matR[count] = temp;
					count = count + 1;
				end
			end
			
			result <= {matR[99], matR[98], matR[97], matR[96], matR[95], 
                           matR[94], matR[93], matR[92], matR[91], matR[90],
                           matR[89], matR[88], matR[87], matR[86], matR[85],
                           matR[84], matR[83], matR[82], matR[81], matR[80],
                           matR[79], matR[78], matR[77], matR[76], matR[75],
                           matR[74], matR[73], matR[72], matR[71], matR[70],
                           matR[69], matR[68], matR[67], matR[66], matR[65],
                           matR[64], matR[63], matR[62], matR[61], matR[60],
                           matR[59], matR[58], matR[57], matR[56], matR[55],
                           matR[54], matR[53], matR[52], matR[51], matR[50],
                           matR[49], matR[48], matR[47], matR[46], matR[45],
                           matR[44], matR[43], matR[42], matR[41], matR[40],
                           matR[39], matR[38], matR[37], matR[36], matR[35],
                           matR[34], matR[33], matR[32], matR[31], matR[30],
                           matR[29], matR[28], matR[27], matR[26], matR[25],
                           matR[24], matR[23], matR[22], matR[21], matR[20],
                           matR[19], matR[18], matR[17], matR[16], matR[15],
                           matR[14], matR[13], matR[12], matR[11], matR[10],
                           matR[9], matR[8], matR[7], matR[6], matR[5],
                           matR[4], matR[3], matR[2], matR[1], matR[0]};
		
		end
	end
end
endmodule
