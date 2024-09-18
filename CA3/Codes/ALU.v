module ALU(input signed[31:0] SrcA, input signed[31:0] SrcB, input[2:0] ALUControl, output reg signed[31:0] ALUResult, output zero, sgn);

wire unsgn;

 always@(ALUControl, SrcA, SrcB) begin
  case(ALUControl)
   3'b000: ALUResult = SrcA + SrcB;
   3'b001: ALUResult = SrcA - SrcB;
   3'b010: ALUResult = SrcA & SrcB;
   3'b011: ALUResult = SrcA | SrcB;
   3'b100: ALUResult = SrcB;
   3'b101: ALUResult = (SrcA < SrcB);
   3'b110: ALUResult = ($unsigned(SrcA) < $unsigned(SrcB));
   3'b111: ALUResult = SrcA ^ SrcB;
  endcase
 end
assign sgn = ALUResult[31];
assign zero = (SrcA == SrcB);

endmodule