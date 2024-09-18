module DataMemory(input clk, input rst, input signed [31:0] ALUResult, input signed [31:0] WriteData, input MemWrite, output signed [31:0] ReadDate);
  reg signed [31:0] DataMem[15999:0];
  integer i;
  initial begin $readmemh("Data.txt", DataMem); 
      for(i = 0; i < 15; i = i + 1) $display("%h", DataMem[i]); end
  assign ReadDate = DataMem[ALUResult[15:0] >> 2];
  always @(posedge clk) begin
    if (MemWrite) DataMem[ALUResult[15:0] >> 2] = WriteData;
  end
endmodule
