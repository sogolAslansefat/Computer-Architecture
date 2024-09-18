module mux3_to_1(input [31:0] x, input [31:0] y, input [31:0] z, input [1:0] sel, output [31:0] ou);
    assign ou = (sel==2'b00)? x:
		(sel==2'b01)? y: z;
endmodule