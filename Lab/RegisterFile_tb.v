module RegisterFile_tb();

reg clk, rst, writeBackEn;
reg [3:0] src1, src2, Dest_wb;
reg [31:0] Result_WB;
wire [31:0] reg1, reg2;
RegisterFile regfile(
    clk, rst,
    src1, src2, Dest_wb,
    Result_WB,
    writeBackEn,
    reg1,reg2
);

initial begin
    clk = 0 ;
    rst = 1 ;
    #5 rst = 0 ;
end
always #10 clk = ~clk;

initial begin
    src1 = 4'd3;
    src2 = 4'd10;
    #53;
    writeBackEn = 1'b1;
    Dest_wb = 4'd13;
    Result_WB = 32'd24;
    #1000 ;
    $stop;

end


endmodule