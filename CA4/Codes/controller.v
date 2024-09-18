module controller(clk, op, func3, func7, beq, bne, blt, bge, jmp, resultSrc, memWrite, aluControl, aluSrc, immSrc, regWrite, jalrSel, done);

parameter [6:0] lw = 3 , sw = 35 , RT = 51 , BT = 99 , IT = 19 , jalr = 103 , jal= 111 , lui= 55 ;
parameter [6:0] endop = 7'bxxxxxxx;

input clk;
input[2:0] func3;
input[6:0] op, func7;

output[2:0] aluControl;
output reg[2:0] immSrc;
output reg[1:0] resultSrc;
output beq, bne, blt, bge;
output reg memWrite, aluSrc, regWrite, done, jmp, jalrSel;

reg branch;
reg[1:0] aluOp;

assign beq = branch & (func3 == 3'b000);
assign bne = branch & (func3 == 3'b001);
assign blt = branch & (func3 == 3'b100);
assign bge = branch & (func3 == 3'b101);
assign aluControl = (aluOp == 2'b00)? 3'b000:
                    (aluOp == 2'b01)? 3'b001:
                    (aluOp == 2'b11)? 3'b100:
                    (aluOp == 2'b10)? (func3 == 3'b000)? ((op == RT & func7 == 7'b0100000)? 3'b001: 3'b000):
                            (func3 == 3'b111)? 3'b010:
                            (func3 == 3'b100)? 3'b111:
                            (func3 == 3'b110)? 3'b011:
                            (func3 == 3'b010)? 3'b101: 3'b000: 3'b000;



always@(posedge clk, op, func3, func7) begin

 {memWrite, aluSrc, regWrite, jmp, branch, jalrSel, done} = 7'b0;

 resultSrc = 2'b00;
 aluOp = 2'b00;
 immSrc = 3'b000;

 case(op)

  lw:   begin regWrite = 1; aluSrc = 1; resultSrc = 2'b01; end
  sw:   begin immSrc = 3'b001; aluSrc = 1; memWrite = 1; end
  RT:   begin regWrite = 1; aluOp = 2'b10; end
  BT:   begin immSrc = 3'b010; branch = 1; aluOp = 2'b01; end
  IT:   begin regWrite = 1; aluSrc = 1; aluOp = 2'b10; end
  jal:  begin regWrite = 1; immSrc = 3'b011; resultSrc = 2'b10; jmp = 1; end
  jalr: begin regWrite = 1; aluSrc = 1; jmp = 1; jalrSel = 1; end
  lui:  begin regWrite = 1; immSrc = 3'b100; aluOp = 2'b11; end
  endop: done = 1'b1;

  default: ;

 endcase

end

endmodule