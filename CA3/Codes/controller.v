`timescale 1ns/1ns
module controller(clk, rst, op, func3, func7, zero, lt, PCWrite, AdrSrc, MemWrite, IRWrite, ResultSrc, AluControl, AluSrcB, AluSrcA, ImmSrc, RegWrite, done);
parameter [4:0] S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5, S6 = 6, S7 = 7, S8 = 8, S9 = 9, S10 = 10, S11 = 11, S12 = 12, S13 = 13, S14 = 14, S15 = 15, S16 = 16, S17 = 17, S18 = 18, S19 = 19, S20 = 20;
input clk, rst, zero, lt;
input[6:0] op, func7;
input [2:0] func3;
output reg PCWrite, AdrSrc, MemWrite, IRWrite, RegWrite, done;
output reg[1:0] ResultSrc, AluSrcB, AluSrcA;
output reg[2:0] ImmSrc;
output[2:0] AluControl;
reg [1:0]ALUOp;
reg branch;
reg[4:0] ns, ps = S0;
wire beq, bne, blt, bge, sub_condition;
assign beq = branch & (func3 == 3'b000);
assign bne = branch & (func3 == 3'b001);
assign blt = branch & (func3 == 3'b100);
assign bge = branch & (func3 == 3'b101);
assign sub_condition = (op == 7'b0110011 & func7 == 7'b0100000);

ALU_Controller ALUC(func3, sub_condition, ALUOp, AluControl);

always@(ps, op, ns) begin
 ns = S0;
case(ps)
  S0: ns = S1;
  S1:  begin       if (op == 7'b0000011) begin ns = S3;  end //lw
              else if (op == 7'b0100011) begin ns = S6;  end //sw
              else if (op == 7'b0110011) begin ns = S8;  end //rt
              else if (op == 7'b1100011) begin ns = S2;  end //bt
              else if (op == 7'b0010011) begin ns = S10; end //it
              else if (op == 7'b1100111) begin ns = S12; end //jalr
              else if (op == 7'b1101111) begin ns = S15; end //jal
              else if (op == 7'b0110111) begin ns = S18; end //lui
              else begin  ns = S20; end  
  end
  S2:  ns = S0;
  S3:  ns = S4;
  S4:  ns = S5;
  S5:  ns = S0; 
  S6:  ns = S7; 
  S7:  ns = S0; 
  S8:  ns = S9; 
  S9:  ns = S0; 
  S10: ns = S11;
  S11: ns = S0;
  S12: ns = S13;
  S13: ns = S14; 
  S14: ns = S0; 
  S15: ns = S16; 
  S16: ns = S17;
  S17: ns = S0;
  S18: ns = S19; 
  S19: ns = S0; 
  S20: ns = S20; 
  endcase
end


always@(ps, beq, bne, blt, bge, zero, lt) begin

 {PCWrite, AdrSrc, MemWrite, IRWrite, RegWrite, branch, done, ResultSrc, AluSrcB, AluSrcA, ALUOp, ImmSrc} = 18'b0;

  case(ps)
  S0:   begin IRWrite = 1; AluSrcB = 2'b10; ResultSrc = 2'b10; PCWrite = 1;  end
  S1:   begin AluSrcB = 2'b01; AluSrcA = 2'b01; ImmSrc = 3'b010; end
  S2:   begin AluSrcA = 2'b10; ALUOp = 2'b01; branch = 1; 
        PCWrite = (beq & zero)  ? 1:
						      (bne & ~zero) ? 1:
						      (blt & lt)   ? 1:
						      (bge & ~lt)  ? 1:0;
        end
  S3:   begin AluSrcA = 2'b10; AluSrcB = 2'b01; end
  S4:   begin AdrSrc = 1; end
  S5:   begin ResultSrc = 2'b01; RegWrite = 1; end
  S6:   begin ImmSrc = 3'b001; AluSrcA = 2'b10; AluSrcB = 2'b01; end
  S7:   begin AdrSrc = 1; MemWrite = 1; end
  S8:   begin AluSrcA = 2'b10; ALUOp = 2'b10; end
  S9:   begin RegWrite = 1; end
  S10:  begin AluSrcA = 2'b10; AluSrcB = 2'b01; ALUOp = 2'b10;  end
  S11:  begin RegWrite = 1;  end
  S12:  begin AluSrcA = 2'b10; AluSrcB = 2'b01; end
  S13:  begin PCWrite = 1; AluSrcA = 2'b01; AluSrcB = 2'b10; end
  S14:  begin RegWrite = 1; end
  S15:  begin AluSrcA = 2'b01; AluSrcB = 2'b01; ImmSrc = 3'b011; end
  S16:  begin PCWrite = 1; AluSrcA = 2'b01; AluSrcB = 2'b10; end
  S17:  begin RegWrite = 1; end
  S18:  begin ImmSrc = 3'b100; AluSrcB = 2'b01; ALUOp = 2'b11; end
  S19:  begin RegWrite = 1; end
  S20:  begin done = 1; end
  endcase
end

always@(posedge clk) begin
 ps <= ns;
end
endmodule