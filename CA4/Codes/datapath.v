module DataPath(input clk, rst, jalrSelD, PCSrcD, [1:0] ResultSrcD, input MemWriteD, [2:0] ALUControlD, input ALUSrcD, 
  [2:0] ImmSrcD, input RegWriteD, StallF, StallD, FlushD, FlushE, [1:0] ForwardAE, [1:0] ForwardBE,
  output [6:0] op, [6:0] func7, [2:0] func3,
  input beqD, bneD, bltD, bgeD, jmpD, output [4:0] Rs1D, [4:0] Rs2D, 
  [4:0] Rs1E, [4:0] Rs2E, [4:0] RdE, output PCSrcE, 
  output [1:0] ResultSrcE, output [4:0] RdM, output RegWriteM, 
  output [4:0] RdW, output RegWriteW);
  wire [31:0] PCFP, PCF, InstrF, PCPlus4F, InstrD, RD1, RD2, ExtImmD, PCPlus4D, PCD, PCNE,
  RD1E, RD2E, PCE, ExtImmE, PCPlus4E, PCTargetE, SrcAE, SrcBE, WriteDataE, ALUResultE,
  ALUResultM, WriteDataM, PCPlus4M, ReadDataM, ReadDataW, PCPlus4W, ResultW, ALUResultW;
  wire RegWriteE, MemWriteE, ALUSrcE, MemWriteM, beqE, bneE, bltE, bgeE, jmpE, jalrSelE, lt, zero;
  wire [1:0] ResultSrcM, ResultSrcW;
  wire [2:0] ALUControlE;
  wire [4:0] RdD;

  mux2_to_1 my_mux1(PCPlus4F, PCTargetE, PCSrcE, PCFP);
  reg_en my_regPC(clk, rst, StallF, 1'b0, PCFP, PCF);
  adder4 my_adder4(PCF, PCPlus4F);
  InstructionMemory my_InsMem(PCF, InstrF);
  
  reg_en my_InstrD(clk, rst, StallD, FlushD, InstrF, InstrD);
  reg_en my_PCPlus4D(clk, rst, StallD, FlushD, PCPlus4F, PCPlus4D);
  reg_en my_PCD(clk, rst, StallD, FlushD, PCF, PCD);
  RegisterFile my_RegFile(clk, InstrD[19:15], InstrD[24:20], RdW, ResultW, RegWriteW, RD1, RD2);
  Extend my_ext(InstrD[31:7], ImmSrcD, ExtImmD);
  assign Rs1D = InstrD[19:15];
  assign Rs2D = InstrD[24:20];
  assign RdD = InstrD[11:7];
  assign op = InstrD[6:0];
  assign func3 = InstrD[14:12];
  assign func7 = InstrD[31:25];

  reg1b my_regwriteE(clk, rst, 1'b0, FlushE, RegWriteD, RegWriteE);
  reg2b my_ResultSrcE(clk, rst, 1'b0, FlushE, ResultSrcD, ResultSrcE);
  reg1b my_MemWriteE(clk, rst, 1'b0, FlushE, MemWriteD, MemWriteE);
  reg1b my_beqE(clk, rst,  1'b0, FlushE, beqD, beqE);
  reg1b my_bneE(clk, rst, 1'b0, FlushE, bneD, bneE);
  reg1b my_bltE(clk, rst, 1'b0, FlushE, bltD, bltE);
  reg1b my_bgeE(clk, rst, 1'b0, FlushE, bgeD, bgeE);
  reg1b my_jmpE(clk, rst, 1'b0, FlushE, jmpD, jmpE);
  reg1b my_jalrSelE(clk, rst, 1'b0, FlushE, jalrSelD, jalrSelE);
  reg3b my_ALUControlE(clk, rst, 1'b0, FlushE, ALUControlD, ALUControlE);
  reg1b my_ALUSrcE(clk, rst, 1'b0, FlushE, ALUSrcD, ALUSrcE);
  reg_en my_RD1E(clk, rst, 1'b0, FlushE, RD1, RD1E);
  reg_en my_RD2E(clk, rst, 1'b0, FlushE, RD2, RD2E);
  reg_en my_PCE(clk, rst, 1'b0, FlushE, PCD, PCE);
  reg5b my_Rs1E(clk, rst, 1'b0, FlushE, Rs1D, Rs1E);
  reg5b my_Rs2E(clk, rst, 1'b0, FlushE, Rs2D, Rs2E);
  reg5b my_RdE(clk, rst, 1'b0, FlushE, RdD, RdE);
  reg_en my_ExtImmE(clk, rst, 1'b0, FlushE, ExtImmD, ExtImmE);
  reg_en my_PCPlus4E(clk, rst, 1'b0, FlushE, PCPlus4D, PCPlus4E);
  mux3_to_1 my_mux2(RD1E, ResultW, ALUResultM, ForwardAE, SrcAE);
  mux3_to_1 my_mux3(RD2E, ResultW, ALUResultM, ForwardBE, WriteDataE);
  mux2_to_1 my_mux4(WriteDataE, ExtImmE, ALUSrcE, SrcBE);
  ALU my_alu(SrcAE, SrcBE, ALUControlE, ALUResultE, zero, lt);
  mux2_to_1 my_mux6(PCE, RD1E, jalrSelE, PCNE);
  adder my_adder(PCNE, ExtImmE, PCTargetE);
  assign PCSrcE = jmpE | (beqE & zero) | (bneE & ~zero) | (bltE & lt) | (bgeE & ~lt);
  reg1b my_RegWriteM(clk, rst, 1'b0, 1'b0, RegWriteE, RegWriteM);
  reg2b my_ResultSrcM(clk, rst, 1'b0, 1'b0, ResultSrcE, ResultSrcM);
  reg1b my_MemWriteM(clk, rst, 1'b0, 1'b0, MemWriteE, MemWriteM);
  reg_en my_ALUResultM(clk, rst, 1'b0, 1'b0, ALUResultE, ALUResultM);
  reg_en my_WriteDataM(clk, rst, 1'b0, 1'b0, WriteDataE, WriteDataM);
  reg5b my_RdM(clk, rst, 1'b0, 1'b0, RdE, RdM);
  reg_en my_PCPlus4M(clk, rst, 1'b0, 1'b0, PCPlus4E, PCPlus4M);
  DataMemory my_DataMem(clk, rst, ALUResultM, WriteDataM, MemWriteM, ReadDataM);
  
  reg1b my_RegWriteW(clk, rst, 1'b0, 1'b0, RegWriteM, RegWriteW);
  reg2b my_ResultSrcW(clk, rst, 1'b0, 1'b0, ResultSrcM, ResultSrcW);
  reg_en my_ReadDataW(clk, rst, 1'b0, 1'b0, ReadDataM, ReadDataW);
  reg5b my_RdW(clk, rst, 1'b0, 1'b0, RdM, RdW);
  reg_en my_PCPlus4W(clk, rst, 1'b0, 1'b0, PCPlus4M, PCPlus4W);
  reg_en my_ALUResultW(clk, rst, 1'b0, 1'b0, ALUResultM, ALUResultW);
  mux3_to_1 my_mux5(ALUResultW, ReadDataW, PCPlus4W, ResultSrcW, ResultW);

endmodule