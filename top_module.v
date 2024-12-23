`timescale 1ns / 1ps

module top_module(
	input rst, clk, load,
	input [3:0] switch,
	output reg [53:0] result,
	output reg [5:0] res,
	output [1:0] state,
	output tx,           // UART transmit pin
   output busy          // UART busy signal
    );

wire [26:0] matA, matB;
wire [53:0] matrixR;
reg [5:0] matR [0:8];
reg send_data;  // Signal to trigger UART transmission

Matrix A (rst, matA);
Matrix B (rst, matB);
Matrix_Multiply uut (.clk(clk),
	.rst(rst),
	.matrixA(matA),
	.matrixB(matB),
	.load(load),
	.result(matrixR),
	.state(state));

integer m;	
always @ (*) begin
	for (m = 0; m < 9; m = m + 1) begin
		matR[m] = matrixR[m * 6 +: 6]; 
	end
end

always @ (*) begin
	res = matR[switch];
end


UART_Tx uart_tx (
    .clk(clk),
    .rst(rst),
    .data_in(matrixR),
    .send(send_data),
    .tx(tx),
    .busy(busy)
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        result <= 0;
        send_data <= 0;
    end else begin
        result <= matrixR;
        if (matrixR != 0 && !busy) begin
            send_data <= 1;  // Trigger sending data over UART
        end else begin
            send_data <= 0;
        end
    end
end


endmodule
