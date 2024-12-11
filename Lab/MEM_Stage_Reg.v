module MEM_Stage_Reg(
    input clk, rst, WB_en_in, MEM_R_EN_in,
    input [31:0] ALU_result_in, Mem_read_value_in,
    input [3:0] Dest_in,
    output reg WB_en, MEM_R_EN,
    output reg [31:0] ALU_result, Mem_read_value,
    output reg [3:0] Dest
);

    always @(posedge clk, posedge rst) begin
        if(rst) 
            {WB_en, MEM_R_EN, ALU_result, Mem_read_value, Dest} <= 70'b0;
        else begin
            WB_en <= WB_en_in;
            MEM_R_EN <= MEM_R_EN_in;
            ALU_result <= ALU_result_in;
            Mem_read_value <= Mem_read_value_in;
            Dest <= Dest_in;
        end
    end
endmodule
