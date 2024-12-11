module ID_Stage(
    input clk,
    input rst,
    input [31:0] Instruction,
    input [31:0] Result_WB,
    input writeBackEn,
    input [3:0] Dest_wb,
    input hazard,
    input [3:0] SR,
    output WB_EN, MEM_R_EN, MEM_W_EN, B, S,
    output [3:0] EXE_CMD, 
    output [31:0] Val_Rn, Val_Rm,
    output imm, 
    output [11:0] Shift_operand,
    output [23:0] Signed_imm_24,
    output [3:0] Dest,
    output [3:0] src1, src2, output Two_src,move
);

    assign Dest = Instruction[15:12];
    assign Signed_imm_24 = Instruction[23:0];
    assign imm = Instruction[25];
    assign Shift_operand = Instruction[11:0];

    wire [8:0] ControlUnitOut;

    wire  WB_EN_cuOut, MEM_R_EN_cuOut, MEM_W_EN_cuOut, B_cuOut, S_cuOut;
    wire [3:0] EXE_CMD_cuOut;
    // assign ControlUnitOut = {EXE_CMD_cuOut[3],EXE_CMD_cuOut[2],EXE_CMD_cuOut[1],EXE_CMD_cuOut[0],MEM_R_EN_cuOUT, MEM_W_EN_cuOUT, WB_EN_cuOUT, B_cuOUT, S_cuOUT};

    ControlUnit ControlUnit(
    .mode(Instruction[27:26]),
    .opcode(Instruction[24:21]),
    .S_in(Instruction[20]),
    .EXE_CMD(EXE_CMD_cuOut),
    .MEM_R_EN(MEM_R_EN_cuOut), .MEM_W_EN(MEM_W_EN_cuOut), .WB_EN(WB_EN_cuOut), .B(B_cuOut), .S_out(S_cuOut),.move(move)
    );

    // assign ControlUnitOut = {EXE_CMD_cuOut, MEM_R_EN_cuOUT};
    // assign ControlUnitOut[3:0] = EXE_CMD_cuOut;
    // assign ControlUnitOut[4] = MEM_R_EN_cuOUT;
    // assign ControlUnitOut[5] = MEM_W_EN_cuOUT;
    // assign ControlUnitOut[6] = WB_EN_cuOUT;
    // assign ControlUnitOut[7] = B_cuOUT;
    // assign ControlUnitOut[8] = S_cuOUT;
    mux2to1_4 mux2to1_4(
        Instruction[3:0], 
        Instruction[15:12],
        MEM_W_EN,
        src2
    );

    RegisterFile RegisterFile(
    clk, rst,
    src1, src2, Dest_wb,
    Result_WB,
    writeBackEn,
    Val_Rn,Val_Rm
    );


    wire Condition_Check_Out;
    wire condition_or;

    Condition_Check Condition_Check(
    Instruction[31:28],
    SR, Condition_Check_Out
    );

    assign condition_or = (~Condition_Check_Out | hazard);
    assign src1 = Instruction[19:16];

    wire [8:0] muxout;
    assign ControlUnitOut = {EXE_CMD_cuOut[3], EXE_CMD_cuOut[2], EXE_CMD_cuOut[1], EXE_CMD_cuOut[0], MEM_R_EN_cuOut, MEM_W_EN_cuOut, WB_EN_cuOut, B_cuOut, S_cuOut};
    mux2to1_9 mux2to1_9(
        ControlUnitOut,9'b0,
        muxout,
        condition_or);

    assign EXE_CMD = muxout[8:5];
    assign MEM_R_EN = muxout[4];
    assign MEM_W_EN = muxout[3];
    assign WB_EN = muxout[2];
    assign B = muxout[1];
    assign S = muxout[0];

    assign Two_src = (~Instruction[25]) | MEM_W_EN;
    

endmodule

module mux2to1_9(
    input [8:0]in0,in1, output [8:0] out,input sel
);

    assign out = sel ? in1 : in0;

endmodule

module mux2to1_4(
    input [3:0] in0, in1, input sel, output [3:0] out
);
    assign out = sel ? in1 : in0;
endmodule