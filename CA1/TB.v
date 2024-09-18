`timescale 1ns/1ns
module TB();

    reg start=1'b0;
    reg clk=1'b0;
    reg sclr=1'b1;

    reg [9:0] a_in = 10'b0001010000;
    reg [9:0] b_in = 10'b0000100000;
    wire [9:0] q_out;
    wire dvz;
    wire ovf;
    wire busy;
    wire valid;
    Divider DIVIDER(clk, sclr, start, a_in, b_in, busy, dvz, ovf, valid, q_out);
    always #10 clk = ~clk;
    initial 
    begin
        #20 sclr=1'b0;
        #20 start=1'b1;
        #20 start=1'b0;
        #1000 $stop;
    end
    

endmodule