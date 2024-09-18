module RegisterFile(input clk, input [4:0] A1, [4:0] A2, [4:0] A3, [31:0] Result, input RegWrite, output signed [31:0] RD1, output signed [31:0] RD2);
  reg signed[31:0] RegFile[31:0];
  initial $readmemh("init.txt", RegFile);
  assign RD1 = RegFile[A1];
  assign RD2 = RegFile[A2];
  always @(posedge clk) begin
    if (RegWrite & A3 != 0) RegFile[A3] = Result;
  end
endmodule