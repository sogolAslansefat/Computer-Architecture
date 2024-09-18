`timescale 1ns/1ns
module RISC_V_Datapath(input clk, rst, regWrite, ALUSrc, memWrite, sel_jalr, sel_lui, sel_pc, resultSrc, PCsource, signSel, input [2:0] ALU_function, immSrc, output zero, SIGN, output [6:0] op, func7, output [2:0] func3);

    wire [31:0] PCSO, PCO, PCIN, PCADD, INSTR, PC4, SELJALRO, IMMO, RD1O, RD2O, ALUSO, ALUO, SELLUIO, RDMO, RESO, passIMMO;

    Mux PC_src (PCsource, PC4, PCADD, PCSO);

    Mux PC_in (sel_pc, PCSO, ALUO, PCIN);

    Pc PC_REG (PCIN, clk, rst, PCO);

    INSTRuctionMemory INST_MEM (PCO, INSTR);

    RegisterFile REG_FILE (clk, regWrite, INSTR[19:15], INSTR[24:20], INSTR[11:7], SELJALRO, RD1O, RD2O);

    Mux ALU_SRC1 (ALUSrc, RD2O, passIMMO, ALUSO);

    ALU ALU_MAIN (ALU_function, RD1O, ALUSO, zero, SIGN, ALUO);

    DataMemory DMEMORY (ALUO, RD2O, memWrite, clk, RDMO);

    Mux RES_SRC (resultSrc, ALUO, RDMO, RESO);

    Mux SELECT_LUI1 (sel_lui, RESO, IMMO, SELLUIO);

    Adder adder_imm (IMMO, PCO, PCADD);

    ImmExt immidiate_extension (immSrc, INSTR, IMMO);

    Mux signSELECT (signSel, IMMO, {12'b0, IMMO[19:0]}, passIMMO);

    Mux SELECT_jalr1 (sel_jalr, SELLUIO, PC4, SELJALRO);

    Adder PC_adder (32'd4, PCO, PC4);

    assign op = INSTR[6:0];
    assign func3 = INSTR[14:12];
    assign func7 = INSTR[31:25];
    
endmodule