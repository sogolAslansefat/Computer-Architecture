module reg_en(input clk, rst, input[31:0] Next, input en, output reg[31:0] Now);
    always @(posedge clk, posedge rst) begin
        if (rst) begin Now = 32'b0; end
        else if(en) Now = Next;
    end
endmodule