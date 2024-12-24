`timescale 1ns / 1ps

module UART_Tx (
    input clk,
    input rst,
    input [53:0] data_in,  // 54-bit result from Matrix_Multiply
    input send,             // Signal to start sending data
    output reg tx,          // Transmit data
    output reg busy         // Indicates UART is busy transmitting
);

parameter BAUD_RATE = 9600;
parameter CLOCK_FREQ = 100_000_000;  // Set to your clock frequency (in Hz)

localparam DIVISOR = CLOCK_FREQ / BAUD_RATE;

reg [15:0] counter;      // Baud rate counter
reg [2:0] byte_index;    // Byte index (0 to 6 for 7 bytes)
reg [7:0] tx_byte;       // Current byte to transmit
reg [3:0] bit_index;     // Bit index within the byte (0 to 9: start, 8 data bits, stop)
reg [53:0] shift_reg;    // Shift register for data (stores 54 bits)
reg transmitting;        // Transmission in progress

always @(posedge clk or posedge rst) begin
    if (rst) begin
        tx <= 1;              // Idle state is high
        busy <= 0;
        counter <= 0;
        byte_index <= 0;
        tx_byte <= 0;
        bit_index <= 0;
        transmitting <= 0;
        shift_reg <= 0;
    end else begin
        if (send && !busy) begin
            // Start transmission
            busy <= 1;
            transmitting <= 1;
            byte_index <= 0;
            bit_index <= 0;
            counter <= 0;
            tx_byte <= data_in[7:0];  // Load first byte (least significant 8 bits)
            shift_reg <= data_in;
        end

        if (transmitting) begin
            if (counter == DIVISOR - 1) begin
                counter <= 0;

                // Transmit bit by bit
                if (bit_index == 0) begin
                    tx <= 0;  // Start bit
                    bit_index <= bit_index + 1;
                end else if (bit_index >= 1 && bit_index <= 8) begin
                    tx <= tx_byte[bit_index - 1];  // Transmit data bits
                    bit_index <= bit_index + 1;
                end else if (bit_index == 9) begin
                    tx <= 1;  // Stop bit
                    bit_index <= 0;

                    if (byte_index < 6) begin
                        // Move to the next byte
                        byte_index <= byte_index + 1;

                        case (byte_index)
                            0: tx_byte <= shift_reg[15:8];
                            1: tx_byte <= shift_reg[23:16];
                            2: tx_byte <= shift_reg[31:24];
                            3: tx_byte <= shift_reg[39:32];
                            4: tx_byte <= shift_reg[47:40];
                            5: tx_byte <= {2'b00, shift_reg[53:48]}; // Last byte (6 bits + padding)
                        endcase
                    end else begin
                        // Transmission complete
                        transmitting <= 0;
                        busy <= 0;
                    end
                end
            end else begin
                counter <= counter + 1;
            end
        end
    end
end

endmodule
