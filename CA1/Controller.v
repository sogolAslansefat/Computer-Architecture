`timescale 1ns/1ns
module Controller (input start,
                   input in_dvz,
                   input in_ovf,
                   input cout,
                   input clk,
                   input rst,
                   output reg valid,
                   output reg cntEn,
                   output reg ld_Q,
                   output reg ld_Acc,
                   output reg ld_A,
                   output reg ld_B,
                   output reg ld_cnt,
                   output reg S0,
                   output reg busy,
                   output reg ovf,
                   output reg dvz);

    parameter IDLE = 3'd0 , LOAD = 3'd1 , CALC = 3'd2 , RESULT = 3'd3;
    reg [2:0] ps;
    reg [2:0] ns;

    always @(posedge clk)
    #1
    begin
        if(rst == 1'b1) 
            ps <= 3'b0;
        else ps <= ns;
    end

    always @(start, in_dvz, in_ovf, cout, ps) 
    begin
        case(ps)
            IDLE    : ns = (start == 1'b0)  ? IDLE : LOAD;
            LOAD    : ns = (in_dvz == 1'b1) ? RESULT : CALC;
            CALC    : ns = ((cout == 1'b1) | (in_ovf == 1'b1)) ? RESULT : CALC;
            RESULT  : ns = IDLE;
            default : ns = IDLE;
        endcase
    end

    always @(in_dvz, in_ovf, cout, ps) begin
        ld_A = 1'b0;    
        ld_B = 1'b0;
        ld_Q = 1'b0;
        ld_Acc = 1'b0;
        ld_cnt = 1'b0;
        valid = 1'b0;
        cntEn = 1'b0;
        S0 = 1'b0;
        busy = 1'b0;
        ovf = 1'b0;
        dvz = 1'b0;
        case (ps)
            IDLE : busy = 1'b0;
            LOAD :  
                begin
                    busy = 1'b1;
                    ld_cnt = 1'b1;
                    ld_A = 1'b1;
                    ld_B = 1'b1;
                    ld_Q = 1'b1;
                    ld_Acc = 1'b1;
                    dvz = in_dvz;
                end
            CALC :   
                begin
                    busy = 1'b1;
                    ld_Q = 1'b1;
                    ld_Acc = 1'b1;
                    cntEn = 1'b1;
                    S0 = 1'b1;
                end
            RESULT :  
                begin
                    busy = 1'b0;
                    ovf = in_ovf;
                    dvz = in_dvz;
                    valid = cout;
                end
        endcase
    end
endmodule