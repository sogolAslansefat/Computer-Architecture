`timescale 1ns/1ns
module RISCV(input clk, rst);
    wire [1:0] ALUOp;   
    wire [2:0] func3, ALU_function, immSrc;
    wire [6:0] func7, op;
    wire branch, SIGN, zero, PCsource, resultSrc, memWrite, ALUSrc, regWrite, jal, jalr, sel_lui, sel_jalr, sel_pc, signSel; 
    BranchController BRANCH_CNTRLR(func3, branch, jal, jalr, SIGN, zero, PCsource);
    ALU_Controller ALU_CNTRLR(func3, func7, ALUOp, signSel, ALU_function);
    Main_cntrlr MAIN_CNTRLR(op, zero, resultSrc, ALUOp, memWrite,  ALUSrc, regWrite, jal, jalr, branch, sel_lui, sel_jalr, sel_pc, immSrc);
    RISC_V_Datapath RISCV_DATAPATH(clk, rst, regWrite, ALUSrc, memWrite, sel_jalr, sel_lui, sel_pc, resultSrc, PCsource, signSel, ALU_function, immSrc, zero, SIGN, op, func7, func3);
endmodule