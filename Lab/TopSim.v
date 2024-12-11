module TopSim(clk, rst, WB_EN_OUT, MEM_R_EN_OUT, MEM_W_EN_OUT, B_OUT, S_OUT, EXE_CMD_OUT,
                PC_OUT, Val_Rn_OUT, Val_Rm_OUT, imm_OUT, Shift_operand_OUT, Signed_imm_24_OUT, Dest_OUT,
                ALU_res, SR_exe_out);


input clk, rst ; 
output WB_EN_OUT, MEM_R_EN_OUT, MEM_W_EN_OUT, B_OUT, S_OUT;
output  [3:0] EXE_CMD_OUT;
output [31:0] PC_OUT, ALU_res;
output [31:0] Val_Rn_OUT, Val_Rm_OUT;
output imm_OUT;
output [11:0] Shift_operand_OUT;
output [23:0] Signed_imm_24_OUT;
output [3:0] Dest_OUT, SR_exe_out;

wire freeze, Branch_taken, flush;
wire [31:0] BranchAddr;
// assign freeze = 0;
// assign Branch_taken = 0;
// assign BranchAddr = 32'b0;
// assign flush = 1'b0;
wire [31:0] PC_IFout;
wire [31:0] Instruction_IFout;

wire [31:0] PC_IFregout;
wire [31:0] Instruction_IFregout;

wire move;
wire [31:0] PC_IDout;


wire [31:0] PC_IDregout;


wire [31:0] PC_EXEout;


wire [31:0] PC_EXEregout;

wire [31:0] PC_MEMout;
wire [31:0] PC_MEMregout;
wire [31:0] PC_WBout;

IF_Stage ifStage(
    clk,rst,freeze,B_OUT,
    BranchAddr, 
    PC_IFout,
    Instruction_IFout
);	
IF_Stage_Reg ifStageReg(
    clk,rst,freeze,B_OUT,
    PC_IFout, Instruction_IFout, 
    PC_IFregout,Instruction_IFregout
);
// reg writeBackEn = 1'b0;
reg hazard = 1'b0;
wire [31:0]Result_WB;
wire [3:0]Dest_wb;
wire [3:0]SR;
// assign SR = 4'b0001;
wire WB_EN, MEM_R_EN, MEM_W_EN, B, S, imm;
wire [3:0]EXE_CMD;
wire  [31:0] Val_Rn, Val_Rm;
wire [11:0] Shift_operand;
wire [23:0] Signed_imm_24;
wire [3:0] Dest;
wire [3:0] src1, src2;
wire Two_src;
wire WB_en_memout;
wire [3:0] Dest_memout;
ID_Stage idStage(
    clk,
    rst,
    Instruction_IFregout,
    Result_WB,
    WB_en_memout,
    Dest_memout,
    freeze,
    SR_exe_out,
    
    WB_EN, MEM_R_EN, MEM_W_EN, B, S,
    EXE_CMD, 
    Val_Rn, Val_Rm,
    imm, 
    Shift_operand,
    Signed_imm_24,
    Dest,
    src1, src2, Two_src,move
);

wire WB_EN_OUT, MEM_R_EN_OUT, MEM_W_EN_OUT, B_OUT, S_OUT;
wire [3:0] EXE_CMD_OUT;
wire [31:0] PC_OUT;
wire [31:0] Val_Rn_OUT, Val_Rm_OUT;
wire imm_OUT;
wire [11:0] Shift_operand_OUT;
wire [23:0] Signed_imm_24_OUT;
wire [3:0] Dest_OUT;
wire [3:0] SR_exe_in;
wire [31:0] ALU_res;
wire [31:0] Branch_Address;
wire [3:0] SR_exe_out;
ID_Stage_Reg idStageReg(
    .clk(clk), .rst(rst), .flush(B_OUT),
    .WB_EN_IN(WB_EN), .MEM_R_EN_IN(MEM_R_EN), .MEM_W_EN_IN(MEM_W_EN),
    .B_IN(B), .S_IN(S),
    .EXE_CMD_IN(EXE_CMD),
    .PC_in(PC_IFregout),
    .Val_Rn_IN(Val_Rn), .Val_Rm_IN(Val_Rm),
    .imm_IN(imm),
    .Shift_operand_IN(Shift_operand),
    .Signed_imm_24_IN(Signed_imm_24),
    .Dest_IN(Dest),
    .SR_in(SR_exe_out),
    .WB_EN(WB_EN_OUT), .MEM_R_EN(MEM_R_EN_OUT), .MEM_W_EN(MEM_W_EN_OUT), .B(B_OUT), .S(S_OUT),
    .EXE_CMD(EXE_CMD_OUT),
    .PC(PC_OUT),
    .Val_Rn(Val_Rn_OUT), .Val_Rm(Val_Rm_OUT),
    .imm(imm_OUT),
    .Shift_operand(Shift_operand_OUT),
    .Signed_imm_24(Signed_imm_24_OUT),
    .Dest(Dest_OUT),
    .SR(SR_exe_in)
);



EXE_Stage exeStage(
    .clk(clk),.rst(rst),.S(S_OUT),
    .EXE_CMD(EXE_CMD_OUT),
    .MEM_R_EN(MEM_R_EN_OUT), .MEM_W_EN(MEM_W_EN_OUT),
    .PC(PC_OUT), 
    .Val_Rn(Val_Rn_OUT), .Val_Rm(Val_Rm_OUT), 
    .imm(imm_OUT),
    .Shift_operand(Shift_operand_OUT), 
    .Signed_imm_24(Signed_imm_24_OUT), 
    .SR(SR_exe_in), 
    .ALU_result(ALU_res), .Br_addr(BranchAddr), 
    .status(SR_exe_out)
);
wire WB_en_exeout;
wire MEM_R_EN_exeout;
wire MEM_W_EN_exeout;
wire [31:0] ALU_result_exeout;
wire [31:0] ST_val_exeout;
wire [3:0] Dest_exeout;
EXE_Stage_Reg exeStageReg(
    .clk(clk), .rst(rst), .WB_en_in(WB_EN_OUT), .MEM_R_EN_in(MEM_R_EN_OUT), .MEM_W_EN_in(MEM_W_EN_OUT), 
    .ALU_result_in(ALU_res), .ST_val_in(Val_Rm_OUT), 
    .Dest_in(Dest_OUT), 
    .WB_en(WB_en_exeout), .MEM_R_EN(MEM_R_EN_exeout), .MEM_W_EN(MEM_W_EN_exeout),
    .ALU_result(ALU_result_exeout), .ST_val(ST_val_exeout), 
    .Dest(Dest_exeout)
);


wire [31:0] mem_data;
MEM_Stage memStage(
    .clk(clk), .MEMread(MEM_R_EN_exeout), .MEMwrite(MEM_W_EN_exeout),
    .address(ALU_result_exeout), .data(ST_val_exeout),
    .MEM_result(mem_data)
);


wire MEM_R_EN_memout;

wire [31:0] ALU_result_memout;
wire [31:0] MEM_DATA_memout;

MEM_Stage_Reg memStageReg(
    .clk(clk), .rst(rst), .WB_en_in(WB_en_exeout), .MEM_R_en_in(MEM_R_EN_exeout),
    .ALU_result_in(ALU_result_exeout), .Mem_read_value_in(mem_data),
    .Dest_in(Dest_exeout),
    .WB_en(WB_en_memout), .MEM_R_en(MEM_R_EN_memout),
    .ALU_result(ALU_result_memout), .Mem_read_value(MEM_DATA_memout),
    .Dest(Dest_memout)
);

hazard_Detection_Unit Hazard_Detection_Unit(
    .src1(Instruction_IFregout[19:16]), .src2(src2), .EXE_Dest(Dest_OUT), .Mem_Dest(Dest_exeout),
    .Exe_WB_EN(WB_EN_OUT), .Mem_WB_EN(WB_en_exeout), .Two_src(Two_src),.move(move),
    .hazard_Detected(freeze)
    );
WB_Stage WbSage(
    .ALU_result(ALU_result_memout), .MEM_result(MEM_DATA_memout),
    .MEM_R_en(MEM_R_EN_memout),
    .out(Result_WB)
);

endmodule