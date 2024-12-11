module EXE_Stage(
    input clk,rst,S,
    input [3:0] EXE_CMD,
    input MEM_R_EN, MEM_W_EN,
    input [31:0] PC, 
    input [31:0] Val_Rn, Val_Rm, 
    input imm,
    input [11:0] Shift_operand, 
    input [23:0] Signed_imm_24, 
    input [3:0] SR, 
    output [31:0] ALU_result, Br_addr, 
    output[3:0] status
);

    wire MEM_EN;
    wire N, Z, C, V;
    wire [31:0] Signed_EX_imm_24, Val2;
    
    assign MEM_EN = MEM_R_EN | MEM_W_EN;
    assign Signed_EX_imm_24 = {{8{Signed_imm_24[23]}}, Signed_imm_24}<<2;
    
    Adder ADDD(Signed_EX_imm_24, PC, Br_addr);
    
    ALU ALU(Val_Rn, Val2, EXE_CMD, SR, ALU_result, N, Z, C, V);
    
    StatusRegister StatusRegister(clk, rst, S, N, Z, C, V, status[0], status[1], status[2], status[3]);
    
    Val2_Generator Val2_Generator(Val_Rm, imm, Shift_operand, MEM_EN, Val2);

endmodule

module Adder(input signed[31:0] in1, in2, output [31:0]out);
    assign out = in1 + in2;
endmodule