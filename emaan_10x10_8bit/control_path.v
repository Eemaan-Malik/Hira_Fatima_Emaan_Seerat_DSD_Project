`timescale 1ns / 1ps

module control_path(
    // global signals
    input   clk,
    input   reset_n,
    // matrix A i/o
    output reg en_ReadMat_A,
    output reg en_WriteMat_A,
    output reg [3:0] rowAddr_A,
    output reg [3:0] colAddr_A,
    // matrix B i/o
    output reg en_ReadMat_B,
    output reg en_WriteMat_B,
    output reg [3:0] rowAddr_B,
    output reg [3:0] colAddr_B,
    // data path i/o
    output reg en_Mux,
    output reg en_PPReg,
    output reg en_FDReg,
    // matrix C i/o
    output reg en_ReadMat_C,
    output reg en_WriteMat_C,
    output reg [3:0] rowAddr_C,
    output reg [3:0] colAddr_C
);
    // state parameters
    localparam S_IDLE = 3'd0;
    localparam STATE_1 = 3'd1;
    localparam STATE_2 = 3'd2;
    localparam STATE_3 = 3'd3;
    localparam STATE_4 = 3'd4;
    localparam S_FINISH = 3'd5;

    // state and counters
    reg [3:0] state;
    reg [3:0] counterI, counterJ, counterK;

    // FSM
    always @(posedge clk or negedge reset_n) begin
        if (~reset_n) begin
            state <= S_IDLE;
        end else begin
            case (state)
                S_IDLE: begin
                    if (counterK == 0) state <= STATE_1;  
                end
                STATE_1: begin
                    if (counterK == 1) state <= STATE_2;
                    else state <= STATE_1;
                end
                STATE_2: begin
                    if (counterK == 9) state <= STATE_3;
                    else state <= STATE_2;
                end
                STATE_3: begin
                    if (counterK == 10) state <= STATE_4;
                    else state <= STATE_3;
                end
                STATE_4: begin
                    if (counterI == 9 && counterJ == 9 && counterK == 10) state <= S_FINISH;
                    else state <= STATE_1;
                end
                S_FINISH: begin
                    state <= S_FINISH;
                end
                default: state <= S_IDLE;
            endcase
        end
    end

    // Address counter
    always @(posedge clk or negedge reset_n) begin
        if (~reset_n) begin
            counterI <= 4'd0;
            counterJ <= 4'd0;
            counterK <= 4'd0;
        end else if (en_PPReg) begin
            counterK <= counterK + 1'b1;
            if (counterK == 12) begin
                counterK <= 4'd0;
                counterJ <= counterJ + 1'b1;
            end
            if (counterJ == 10) begin
                counterJ <= 4'd0;
                counterI <= counterI + 1'b1;
            end
            if (counterI == 10) begin
                counterI <= 4'd0;
            end
        end
    end

    // Output logic
    always @(*) begin
        case (state)
            S_IDLE: begin
                en_ReadMat_A = 0;
                en_WriteMat_A = 0;
                rowAddr_A = 4'd0;
                colAddr_A = 4'd0;
                en_ReadMat_B = 0;
                en_WriteMat_B = 0;
                rowAddr_B = 4'd0;
                colAddr_B = 4'd0;
                en_Mux = 0;
                en_PPReg = 0;
                en_FDReg = 0;
                en_ReadMat_C = 0;
                en_WriteMat_C = 0;
                rowAddr_C = 4'd0;
                colAddr_C = 4'd0;
            end
            STATE_1: begin
                en_ReadMat_A = 1;
                en_WriteMat_A = 0;
                rowAddr_A = counterI;
                colAddr_A = counterK;
                en_ReadMat_B = 1;
                en_WriteMat_B = 0;
                rowAddr_B = counterK;
                colAddr_B = counterJ;
                en_Mux = 0;
                en_PPReg = 1;
                en_FDReg = 0;
                en_ReadMat_C = 0;
                en_WriteMat_C = 0;
            end
            // other states...
            default: begin
                en_ReadMat_A = 0;
                en_WriteMat_A = 0;
                rowAddr_A = 4'd0;
                colAddr_A = 4'd0;
                en_ReadMat_B = 0;
                en_WriteMat_B = 0;
                rowAddr_B = 4'd0;
                colAddr_B = 4'd0;
                en_Mux = 0;
                en_PPReg = 0;
                en_FDReg = 0;
                en_ReadMat_C = 0;
                en_WriteMat_C = 0;
                rowAddr_C = 4'd0;
                colAddr_C = 4'd0;
            end
        endcase
    end

endmodule
