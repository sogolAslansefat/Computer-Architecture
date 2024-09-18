`timescale 1ns/1ns
module Pc(input [31:0] in, input clk, rst, output reg [31:0] Instr_adress);
    
    always @(posedge clk , rst) begin
        if(rst)
            Instr_adress <= {32'b0};
        else
            Instr_adress <= in;
    end

endmodule