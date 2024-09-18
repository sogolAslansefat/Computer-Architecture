//`define BITS(x) $rtoi($ceil($clog2(x)))
`timescale 1ns/1ns
module RegisterFile(input clk, regWrite,input [4:0] A1, A2, A3, input [31:0] WD, output [31:0] RD1, RD2);
                    

    reg [31:0] RegisterFile [0:31];

    initial RegisterFile[0] = 32'd0;


    always @(posedge clk) begin
        if (regWrite & (|A3))
            RegisterFile[A3] <= WD;
    end

    assign RD1 = RegisterFile[A1];
    assign RD2 = RegisterFile[A2];

endmodule
