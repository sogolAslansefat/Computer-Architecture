module Data_path (
    input clk,
    input sclr,
    input [9:0] in_A,
    input [9:0] in_B,
    input Ld_A,
    input Ld_B,
    input Ld_Cnt,
    input Ld_Q,
    input Ld_Acc,
    input cntEn,
    input S1,
    output dvz,
    output ovf,
    output Cout,
    output [9:0] q_out);


    wire [9:0] A, B;
    wire [10:0] Acc, Acc_0, Acc_2, Acc_3, next_Acc, Acc_sub;
    wire [9:0] Q, Q_0, Q_2, Q_3, next_Q;

    wire [3:0] cnt_out;
    wire [1:0] select;
    wire S0;

    assign S0 = S1 & (Acc >= {1'b0, B});

    assign Acc_sub = Acc - {1'b0, B};

    assign {Acc_0, Q_0} = {10'b0, in_A, 1'b0};

    assign {Acc_2, Q_2} = {Acc[9:0], Q, 1'b0};

    assign {Acc_3, Q_3} = {Acc_sub[9:0], Q, 1'b1};

    assign select = {S1, S0};

    //Register
    Reg #(.bit(10)) REG_A   (clk, sclr, Ld_A, in_A, A);
    Reg #(.bit(10)) REG_B   (clk, sclr, Ld_B, in_B, B);
    Reg #(.bit(10)) REG_Q   (clk, sclr, Ld_Q, next_Q, Q);
    Reg #(.bit(11)) REG_Acc (clk, sclr, Ld_Acc, next_Acc, Acc);

    //Multiplexer
    mux #(.bit(11)) MUX_Acc (select, Acc_0, 11'b0, Acc_2, Acc_3, next_Acc);
    mux #(.bit(10)) MUX_Q   (select, Q_0, 10'b0, Q_2, Q_3, next_Q);

    //Counter
    counter CNT (clk, sclr, cntEn, Ld_Cnt, 4'b0010, Cout, cnt_out);

    assign q_out = Q;
    assign ovf = (cnt_out == 4'b1011) ? (next_Q[9:4] != 0) : 0;
    assign dvz = ~|in_B;

endmodule

module Reg #(parameter bit = 10) (
    input clk,
    input rst,
    input ld,
    input [bit - 1:0] par_in,
    output reg [bit - 1:0] par_out
);
    always @(posedge clk) begin
        if (rst == 1'b1)
            par_out <= 0;
        else if (ld == 1'b1)
            par_out <= par_in;
    end
endmodule

module counter (
    input clk,
    input rst,
    input inc,
    input ld,
    input [3:0] par_in,
    output reg cout,
    output reg [3:0] par_out);

    always @(posedge clk) 
    begin
        if (par_out == 4'b1111)
            cout <= 1;
        else 
            cout <= 0;

        if (rst == 1'b1)
            par_out <= 4'b0;
        else if (ld == 1'b1)
            par_out <= par_in;
        else if (inc == 1'b1) 
        begin
            par_out <= par_out + 1;
        end
    end
endmodule

module mux #(parameter bit = 10) (
    input [1:0] sel,
    input [bit-1:0] a,
    input [bit-1:0] b,
    input [bit-1:0] c,
    input [bit-1:0] d,
    output reg [bit-1:0] out);
    
  always @(a or b or c or d or sel) begin
    case(sel)
      2'b00: out <= a;
      2'b01: out <= b;
      2'b10: out <= c;
      2'b11: out <= d;
    endcase
  end
endmodule