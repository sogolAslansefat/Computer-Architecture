module WB_Stage(
    input [31:0] ALU_result, MEM_result,
    input MEM_R_en,
    output [31:0] out
);
    mux_2to1 mux_2to1(ALU_result, MEM_result, MEM_R_en, out);
endmodule

module mux_2to1(input [31:0] in0, in1,
                input sel,
                output [31:0] out);
    assign out = (sel) ? in1 : in0;
endmodule