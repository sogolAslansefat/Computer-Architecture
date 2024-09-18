`timescale 1ns/1ns
module Mux(input cntrl_sig, input [31:0] a, b, output [31:0] w);
    assign w = cntrl_sig ? b : a;
endmodule