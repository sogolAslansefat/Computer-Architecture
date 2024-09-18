`timescale 1ns/1ns
module ALU_Controller(input [2:0] func3,input [6:0] func7, input [1:0] ALUOp, output reg [2:0] ALUOperation);
    parameter [2:0] ADD = 0, SUB = 1, AND = 2, OR = 3, LUI = 4, SLT = 5, SLTU = 6, XOR = 7;
    parameter [1:0] LS_W = 0, B_T = 1, RI_T = 2, U_T = 3;
    
    always @(ALUOp , func3 , func7)begin
        case (ALUOp)
            LS_W  : ALUOperation <= ADD;
            B_T   : ALUOperation <= SUB;
            RI_T  : ALUOperation <= 
                        (func3 == 3'b000 & func7 == 1'b0) ? ADD:
                        (func3 == 3'b000 & func7 == 1'b1) ? SUB:
                        (func3 == 3'b111) ? AND:
                        (func3 == 3'b110) ? OR:
                        (func3 == 3'b010) ? SLT: 
                        (func3 == 3'b011) ? SLTU: 3'bzzz;
            U_T   : ALUOperation <= LUI;
            default: ALUOperation <= ADD;
        endcase
    end

endmodule