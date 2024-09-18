`timescale 1ns/1ns
module ALU_Controller(input [2:0] func3,input [6:0] func7, input [1:0] ALUOp, output signSel, output reg [2:0] ALUOperation);
    parameter [2:0] ADD = 0, SUB = 1, AND = 2, OR = 3, SLT = 4, SLTU = 5, XOR = 6;
    parameter [1:0] lw_sw = 0, B_T = 1, R_T = 2, I_T = 3;
    
    always @(ALUOp , func3 , func7)begin
        case (ALUOp)
            lw_sw : ALUOperation <= ADD;
            B_T   : ALUOperation <= SUB;
            R_T   : ALUOperation <= 
                        (func3 == 3'b000 & func7 == 7'b0000000) ? ADD:
                        (func3 == 3'b000 & func7 == 7'b0100000) ? SUB:
                        (func3 == 3'b111 & func7 == 7'b0000000) ? AND:
                        (func3 == 3'b110 & func7 == 7'b0000000) ? OR:
                        (func3 == 3'b010 & func7 == 7'b0000000) ? SLT: 
                        (func3 == 3'b011 & func7 == 7'b0000000) ? SLTU: 3'bzzz;
            I_T   : ALUOperation <=  
                        (func3 == 3'b000) ? ADD:
                        (func3 == 3'b100) ? XOR:
                        (func3 == 3'b110) ? OR:
                        (func3 == 3'b010) ? SLT:
                        (func3 == 3'b011) ? SLTU: 3'bzzz;
            default: ALUOperation <= ADD;
        endcase
    end

assign signSel = (ALUOperation == SLTU) ? 1'b1 : 1'b0;

endmodule