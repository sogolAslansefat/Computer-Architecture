module reg1(input clk, rst, input[31:0] PCNext, output reg[31:0] PC);
    always @(posedge clk, posedge rst) begin
        if(rst) begin PC = 32'b0; end
    else begin PC = PCNext; end
 end
endmodule