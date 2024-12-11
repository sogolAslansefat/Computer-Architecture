`timescale 1ns/1ns
module Top_tb();

reg clk, rst;

wire WB_EN_OUT, MEM_R_EN_OUT, MEM_W_EN_OUT, B_OUT, S_OUT;
wire [3:0] EXE_CMD_OUT;
wire [31:0] PC_OUT;
wire [31:0] Val_Rn_OUT, Val_Rm_OUT, ALU_res;
wire imm_OUT;
wire [11:0] Shift_operand_OUT;
wire [23:0] Signed_imm_24_OUT;
wire [3:0] Dest_OUT, statusbits;

TopSim topSim(clk, rst, WB_EN_OUT, MEM_R_EN_OUT, MEM_W_EN_OUT, B_OUT, S_OUT, EXE_CMD_OUT
                ,PC_OUT, Val_Rn_OUT, Val_Rm_OUT, imm_OUT, Shift_operand_OUT,Signed_imm_24_OUT, Dest_OUT,
                ALU_res, statusbits);


initial begin
    rst = 1;
    clk = 0;
end
always #10 clk = ~clk;


initial begin
    #21 rst = 0;
    #1000000;
    $stop;
end

endmodule