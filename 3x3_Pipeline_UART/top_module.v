`timescale 1ns / 1ps

module top_module(
	input rst, clk, 
	input [2:0] switch,
	input [2:0] switch2,
	input rx,
	output reg [5:0] res,
	output tx,           // UART transmit pin
   output reg [7:0] test          // UART busy signal
    );
parameter N = 8;
wire rx_valid,receiving;
wire [3:0] bit_index;
wire [7:0] rx_data;
wire [26:0] matA, matB;
reg [26:0] matA_, matB_;
wire [53:0] result;
reg [63:0] test_result;
reg [53:0] result_;
reg send_data;  // Signal to trigger UART transmission
reg [3:0] counter;
wire busy;
integer i;
reg [63:0] data_buffer; // 54-bit register to store incoming data
reg [63:0] data_mem [0:5];
reg [63:0] result_mem [0:N+2];
integer result_mem_idx;
integer data_mem_idx, data_mem_idx2;
reg [63:0] data_buffer_temp;
reg start;
Matrix_Multiply uut (.clk(clk),
	.rst(rst),
	.start(start),
	.matrixA(matA_),
	.matrixB(matB_),
	.result(result));

// UART Receive
UART_Rx uart_rx (
    .clk(clk),
    .rst(rst),
    .rx(rx),
    .rx_data(rx_data),
    .rx_ready(rx_valid)
);

// UART Transmit
UART_Tx uart_tx (
    .clk(clk),
    .rst(rst),
    .data_in(result_),
    .send(send_data),
    .tx(tx),
    .busy(busy)
);

reg rx_ready_d;  // Delayed version of rx_ready

always @(posedge clk or posedge rst) begin
    if (rst) begin
        rx_ready_d <= 0;
    end else begin
        rx_ready_d <= rx_valid;
    end
end

wire rx_valid_edge = rx_valid && !rx_ready_d;  // Detect rising edge of rx_ready

always @ (posedge clk or posedge rst) begin
	if (rst) begin
		matA_ = 0;
      matB_ = 0;
		send_data <= 0;
      i <= 0;
      data_buffer <= 0;
		data_mem_idx <= 0;
		data_mem_idx2 <= 0;
		start = 0;
		result_mem_idx <= 0;
	end
	else begin
		if (data_mem_idx < N) begin
			if (i == 8) begin
				data_mem[data_mem_idx]<=data_buffer;
				data_mem_idx <= data_mem_idx + 1;
				 //matA_ <= data_buffer[26:0];    // First 27 bits
				 //matB_ <= data_buffer[58:32];  // Next 27 bits
				i <= 0;                      // Reset index for next transaction
          end
			  if (rx_valid_edge) begin
			  
			  // Write the received byte into the correct position in the buffer
					data_buffer[(i * 8) +: 8] <= rx_data;  // Dynamic bit slicing

					// Increment the byte counter (i) for the next byte
					i <= i + 1;

				end 
        end else begin
		  if (data_mem_idx2 < N) begin
		  data_buffer_temp = data_mem[data_mem_idx2];
		  matA_ = data_buffer_temp[26:0];    
		  matB_ = data_buffer_temp[58:32]; 
		  start = 1;
		  result_mem[data_mem_idx2]=result;
		  data_mem_idx2 <= data_mem_idx2+1;
		  end
		  else begin
		  
		  if (data_mem_idx2 < N+3) begin
		  matA_ = 0;    
		  matB_ = 0; 
		  start = 1;
		  result_mem[data_mem_idx2]=result;
		  data_mem_idx2 <= data_mem_idx2+1;
		  end
		  end
		end
			if (data_mem_idx2>=N+3 && result_mem_idx<=N+3 ) begin
			if (!busy) begin
            send_data <= 1;  // Send the result back to the laptop
				result_ <= result_mem[result_mem_idx];
				result_mem_idx <= result_mem_idx + 1;
				end
		   end
		   else send_data <= 0;
    end
	
end

always @(*) begin
case (switch2)
		  3'd0: test_result = result_mem[0];    // Least significant byte
        3'd1: test_result = result_mem[1];   // Second byte
        3'd2: test_result = result_mem[2];  // Third byte
        3'd3: test_result = result_mem[3];  // Fourth byte
        3'd4: test_result = result_mem[4];  // Fifth byte
        3'd5: test_result = result_mem[5];  // Sixth byte
        3'd6: test_result = result_mem[6];  // Most significant bits (partial byte for 54-bit buffer)
        3'd7: test_result = result_mem[8];

		  default: test_result = 8'h00;
    endcase
    case (switch)
       3'd0: test = test_result[7:0];    // Least significant byte
        3'd1: test = test_result[15:8];   // Second byte
        3'd2: test = test_result[23:16];  // Third byte
        3'd3: test = test_result[31:24];  // Fourth byte
        3'd4: test = test_result[39:32];  // Fifth byte
        3'd5: test = test_result[47:40];  // Sixth byte
        3'd6: test = test_result[55:48];  // Most significant bits (partial byte for 54-bit buffer)
        3'd7: test = test_result[63:56];
		  /*3'd0: test = test_result[7:0];    // Least significant byte
        3'd1: test = test_result[15:8];   // Second byte
        3'd2: test = matA_[23:16];  // Third byte
        3'd3: test = matA_[26:24];  // Fourth byte
        3'd4: test = matB_[7:0];  // Fifth byte
        3'd5: test = matB_[15:8];  // Sixth byte
        3'd6: test = matB_[23:16];  // Most significant bits (partial byte for 54-bit buffer)
        3'd7: test = matB_[26:24];*/

		  default: test = 8'h00;
    endcase
end


endmodule
