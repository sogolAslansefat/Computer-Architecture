module Divider(
        input clk,
        input sclr,
        input start,
        input [9:0]in_A,
        input [9:0]in_B,
        input busy,
        input dvz,
        input ovf,
        input valid,
        output [9:0]q_out);

    wire Cout, cntEn, Ld_A, Ld_B, Ld_Cnt, Ld_Q, Ld_Acc, dp_ovf, dp_dvz, S0;

    Controller CONTROLLER(start, dp_dvz, dp_ovf, Cout, clk, sclr, valid, cntEn, Ld_Q, Ld_Acc, Ld_A, Ld_B, Ld_Cnt, S0, busy, ovf, dvz);

    Data_path DATA_PATH(clk, sclr, in_A, in_B, Ld_A, Ld_B, Ld_Cnt, Ld_Q, Ld_Acc, cntEn, S0, dp_dvz, dp_ovf, Cout, q_out);

endmodule