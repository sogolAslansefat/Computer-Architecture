module adder(input[31:0] PC, input signed[31:0]ImmExt, output[31:0] PCTarget);

 assign PCTarget = PC + ImmExt;

endmodule