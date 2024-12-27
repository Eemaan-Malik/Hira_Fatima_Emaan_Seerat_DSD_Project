`timescale 1ns / 1ps

module UART_Tx (
    input clk,
    input rst,
    input [399:0] data_in,  // 54-bit result from Matrix_Multiply
    input send,             // Signal to start sending data
    output reg tx,          // Transmit data
    output reg busy         // Indicates UART is busy transmitting
);

parameter BAUD_RATE = 9600;
parameter CLOCK_FREQ = 100_000_000;  // Set to your clock frequency (in Hz)

localparam DIVISOR = CLOCK_FREQ / BAUD_RATE;

reg [15:0] counter;      // Baud rate counter
reg [6:0] byte_index;    // Byte index (0 to 6 for 7 bytes)
reg [7:0] tx_byte;       // Current byte to transmit
reg [3:0] bit_index;     // Bit index within the byte (0 to 9: start, 8 data bits, stop)
reg [399:0] shift_reg;    // Shift register for data (stores 54 bits)
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

                    if (byte_index < 50) begin
                        // Move to the next byte
                        byte_index <= byte_index + 1;

                        case (byte_index)
    0: tx_byte <= shift_reg[7:0];
    1: tx_byte <= shift_reg[15:8];
    2: tx_byte <= shift_reg[23:16];
    3: tx_byte <= shift_reg[31:24];
    4: tx_byte <= shift_reg[39:32];
    5: tx_byte <= shift_reg[47:40];
    6: tx_byte <= shift_reg[55:48];
    7: tx_byte <= shift_reg[63:56];
    8: tx_byte <= shift_reg[71:64];
    9: tx_byte <= shift_reg[79:72];
    10: tx_byte <= shift_reg[87:80];
    11: tx_byte <= shift_reg[95:88];
    12: tx_byte <= shift_reg[103:96];
    13: tx_byte <= shift_reg[111:104];
    14: tx_byte <= shift_reg[119:112];
    15: tx_byte <= shift_reg[127:120];
    16: tx_byte <= shift_reg[135:128];
    17: tx_byte <= shift_reg[143:136];
    18: tx_byte <= shift_reg[151:144];
    19: tx_byte <= shift_reg[159:152];
    20: tx_byte <= shift_reg[167:160];
    21: tx_byte <= shift_reg[175:168];
    22: tx_byte <= shift_reg[183:176];
    23: tx_byte <= shift_reg[191:184];
    24: tx_byte <= shift_reg[199:192];
    25: tx_byte <= shift_reg[207:200];
    26: tx_byte <= shift_reg[215:208];
    27: tx_byte <= shift_reg[223:216];
    28: tx_byte <= shift_reg[231:224];
    29: tx_byte <= shift_reg[239:232];
    30: tx_byte <= shift_reg[247:240];
    31: tx_byte <= shift_reg[255:248];
    32: tx_byte <= shift_reg[263:256];
    33: tx_byte <= shift_reg[271:264];
    34: tx_byte <= shift_reg[279:272];
    35: tx_byte <= shift_reg[287:280];
    36: tx_byte <= shift_reg[295:288];
    37: tx_byte <= shift_reg[303:296];
    38: tx_byte <= shift_reg[311:304];
    39: tx_byte <= shift_reg[319:312];
    40: tx_byte <= shift_reg[327:320];
    41: tx_byte <= shift_reg[335:328];
    42: tx_byte <= shift_reg[343:336];
    43: tx_byte <= shift_reg[351:344];
    44: tx_byte <= shift_reg[359:352];
    45: tx_byte <= shift_reg[367:360];
    46: tx_byte <= shift_reg[375:368];
    47: tx_byte <= shift_reg[383:376];
    48: tx_byte <= shift_reg[391:384];
    49: tx_byte <= shift_reg[399:392];
    
    
    default: tx_byte <= 8'b0;  // Default case to avoid latches
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
