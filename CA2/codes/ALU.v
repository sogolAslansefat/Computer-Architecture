`timescale 1ns/1ns
module ALU(input [2:0] ALUOperation, input [31:0] a, b, output zero, SIGN, output reg [31:0] w);
    parameter [2:0] ADD = 0, SUB = 1, AND = 2, OR = 3, SLT = 4, SLTU = 5, XOR = 6;

    always @(a , b , ALUOperation) begin
        case (ALUOperation)
            ADD   :  w = a + b;
            SUB   :  w = a - b;
            AND   :  w = a & b;
            OR    :  w = a | b;
            SLT   :  w = a < b ? 32'b1 : 32'b0;
            SLTU  :  w = $unsigned(a) < $unsigned(b) ? 32'b1 : 32'b0;
            XOR   :  w = a ^ b;
            default:  w = 32'bz;
        endcase
    end

    assign zero = (~|w);
    assign SIGN = w[31];

endmodule