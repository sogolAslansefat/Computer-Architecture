`timescale 1ns/1ns
module RISCV_TB();
    reg clk, rst;
    RISCV risc_v(clk, rst);
    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        #2 rst = 1'b1;
        #6 rst = 1'b0;
        #2000 $stop;
    end
    
endmodule