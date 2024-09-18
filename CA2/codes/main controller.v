`timescale 1ns/1ns
module Main_cntrlr(input [6:0] op, input zero, output reg resultSrc, output reg [1:0] ALUOp, output reg memWrite,  ALUSrc, regWrite, jal, jalr, branch, luiSel, jalrSel, selPC, output reg [2:0] immSrc);

    parameter [6:0] R_T = 7'b0110011, I_T = 7'b0010011, S_T = 7'b0100011, B_T = 7'b1100011, U_T = 7'b0110111, J_T = 7'b1101111, LW_T = 7'b0000011, JALR_T = 7'b1100111;
    always @(op) begin 
        { memWrite, regWrite, ALUSrc, branch, immSrc, resultSrc, jal, ALUOp, luiSel, jalrSel, selPC} <= 13'b0000000000000;
        case(op)
            R_T:begin
                ALUOp     <= 2'b10;
                regWrite  <= 1'b1;
            end

            I_T:begin
                ALUOp     <= 2'b11;
                regWrite  <= 1'b1;
                ALUSrc    <= 1'b1;
            end

            LW_T:begin
                regWrite  <= 1'b1;
                ALUSrc    <= 1'b1;
                resultSrc <= 1'b1;
            end

            JALR_T:begin // not done
                regWrite  <= 1'b1;
                ALUSrc    <= 1'b1;
                jalrSel  <= 1'b1;
                selPC    <= 1'b1;
                immSrc    <= 3'b000;
                jalr      <= 1'b1;
            end

            S_T:begin
                memWrite  <= 1'b1;
                immSrc    <= 3'b001;
                ALUSrc    <= 1'b1;
            end
            
            J_T:begin
                //resultSrc <= 2'b10;
                immSrc    <= 3'b100;
                jal       <= 1'b1;
                regWrite  <= 1'b1;
            end

            B_T:begin
                ALUOp     <= 2'b01;
                immSrc    <= 3'b010;
                branch    <= 1'b1;
            end

            U_T:begin
                luiSel   <= 1'b1;
                immSrc    <= 3'b011;
                regWrite  <= 1'b1;
            end
        endcase
    end
endmodule