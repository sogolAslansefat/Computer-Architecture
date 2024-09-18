module mux3_to_1(input[31:0] x, input[31:0] y, input[31:0] z, input[1:0] sel,

     output reg[31:0] ou);

 always@(x, y, z, sel) begin

  case(sel)

   2'b00: ou = x;

   2'b01: ou = y;

   2'b10: ou = z;

  endcase

 end

endmodule
