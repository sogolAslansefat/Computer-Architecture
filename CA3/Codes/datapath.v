module DataPath(input clk, rst, PCWrite, AdrSrc, IRWrite, RegWrite, MemWrite,input [1:0] ResultSrc,
	input [2:0] ALUControl,input [1:0] ALUSrcB,input [1:0] ALUSrcA,input [2:0] ImmSrc, output [6:0] op,
	output [6:0] func7,output [2:0] func3, output lt, zero);
    wire [31:0] PC, Adr, RD1, RD2, OldPC, A, ALUOut, Data, Instr, PCPlus4, PCNext, SrcA, SrcB, ImmExt, PCTarget, WriteData, ALUResult, ReadData, Result, Four; 
    reg_en my_PC(clk, rst, PCNext, PCWrite, PC);
    mux2_to_1 my_mux(PC, Result, AdrSrc, Adr);
    DataMemory my_data(clk, rst, Adr, WriteData, MemWrite, ReadData);
    reg_en my_inst(clk, rst, ReadData, IRWrite, Instr);
    reg_en my_oldpc(clk, rst, PC, IRWrite, OldPC);
    reg1 my_Da(clk, rst, ReadData, Data);
    RegisterFile my_regfile(clk, Instr[19:15], Instr[24:20], Instr[11:7], Result, RegWrite, RD1, RD2);
    reg1 my_A(clk, rst, RD1, A);
    reg1 my_WriteData(clk, rst, RD2, WriteData);
    Extend my_extend(Instr[31:7], ImmSrc, ImmExt);
    mux3_to_1 my_mux2(PC, OldPC, A, ALUSrcA, SrcA);
    mux3_to_1 my_mux3(WriteData, ImmExt, Four, ALUSrcB, SrcB);
    ALU my_alu(SrcA, SrcB, ALUControl, ALUResult, zero, lt);
    reg1 my_ALUout(clk, rst, ALUResult, ALUOut);
    mux3_to_1 my_mux4(ALUOut, Data, ALUResult, ResultSrc, Result);

    assign PCNext = Result;
    assign op = Instr[6:0];
    assign func3 = Instr[14:12];
    assign func7 = Instr[31:25];
    assign Four = 32'b00000000000000000000000000000100;
endmodule