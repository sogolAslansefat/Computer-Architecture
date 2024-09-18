module mux2_to_1(input [31:0] x,  input [31:0] y, input sel, output [31:0] ou);
    assign ou = (sel == 1)?y:x;
endmodule