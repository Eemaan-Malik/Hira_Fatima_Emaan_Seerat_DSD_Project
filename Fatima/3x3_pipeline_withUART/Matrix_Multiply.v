`timescale 1ns / 1ps

module Matrix_Multiply(
	input clk, rst,
	input [26:0] matrixA, matrixB,
	input load,
	output reg [53:0] result,
	output reg [1:0] state
    );

reg [2:0] matA [0:8];
reg [2:0] matB [0:8];
reg [5:0] matR [0:8];
integer m, n, r, c, i;

// State Encoding
parameter S0 = 3'd0, // Idle state
          S1 = 3'd1, // Load state
          S2 = 3'd2, // Compute state
          S3 = 3'd3; // Store state
			 
reg [1:0] next_state;
reg compute, done, stored;
reg [3:0] count;

always @ (posedge clk or posedge rst) begin
	if (rst) state <= S0;
	else state <= next_state;
end

always @ (*) begin
	next_state = state;
	case(state)
		S0:
			if (load) next_state = S1;
		S1:
			if (compute) next_state = S2;
		S2: 
			if (done) next_state = S3;
		S3:
			if (stored) next_state = S0;
	endcase
end

always @ (posedge clk) begin
	case (state)
		S0: begin
			compute = 0;
			done = 0;
			stored = 0;
			result <= 0;
			count = 0;
			for (n = 0; n < 9; n = n + 1) begin
				matA[n] = 3'd0;
				matB[n] = 3'd0;
				matR[n] = 6'd0; 
			end
		end
		S1: begin
			for (m = 0; m < 9; m = m + 1) begin
			// Extract each 5-bit value from memory_in and store it in matA[i]
				matA[m] = matrixA[m * 3 +: 3]; // Access 5 bits for each array element
				matB[m] = matrixB[m * 3 +: 3];
			end
			count = 0;
			for (n = 0; n < 9; n = n + 1) begin
				matR[n] = 6'd0; 
			end
			compute = 1;
			done = 0;
			stored = 0;
			result <= 0;
		end
		
		S2: begin
			count = 0;
			for (r=0; r<3; r=r+1) begin
				for (c=0; c<3; c=c+1) begin
					for (i=0; i<3; i=i+1) begin
						matR[count] = matR[count] + (matA[(r*3)+i] * matB[(i*3)+c]);
					end
					count = count + 1;
				end
			end
			done = 1;
			compute = 0;
			stored = 0;
			result <= 0;
			for (n = 0; n < 9; n = n + 1) begin
				matA[n] = 3'd0;
				matB[n] = 3'd0;
			end
		end
		
		S3: begin
			if (done) begin
			result <= {matR[8], matR[7], matR[6], matR[5], matR[4], 
							matR[3], matR[2], matR[1], matR[0]};
			end else result <= result;
			stored = 0;
			compute = 0;
			done = 0;
			count = 0;
			for (n = 0; n < 9; n = n + 1) begin
				matA[n] = 3'd0;
				matB[n] = 3'd0;
				matR[n] = 6'd0;
			end
		end
		
	endcase
end





endmodule
