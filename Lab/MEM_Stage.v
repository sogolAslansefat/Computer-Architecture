module MEM_Stage(
    input clk, MEMread, MEMwrite,
    input [31:0] address, data,
    output [31:0] MEM_result
);
    reg  [31:0] memory [0:63];
    assign MEM_result = MEMread ? memory[(address-1024)>>2] : 32'bx;
    always @(posedge clk) begin 
        if(MEMwrite)
            memory[(address-1024)>>2] = data;
    end



endmodule