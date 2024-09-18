`timescale 1ns/1ns
module ImmExt(input [2:0] immSrc, input [31:0] instr, output reg [31:0] w);
    parameter [2:0]  I_T = 0, S_T = 1, B_T = 2, U_T = 3, J_T = 4;

    always @(immSrc, instr) begin
        case(immSrc)
            I_T   : w <= {{20{instr[31]}}, instr[31:20]};
            S_T   : w <= {{20{instr[31]}}, instr[31:25], instr[11:7]};
            B_T   : w <= {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
            U_T   : w <= {{instr[31:12]}, {12'b0}};
            J_T   : w <= {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
            default: w <= 32'b0;
        endcase
    end
endmodule