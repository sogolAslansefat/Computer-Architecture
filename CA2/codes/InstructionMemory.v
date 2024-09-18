module INSTRuctionMemory(input [31:0] pc, output [31:0] instruction);
    //32 changed to 16
    reg [7:0] instructionMemory [0:$pow(2, 16)-1]; 

    wire [31:0] adr;
    // changed
    assign adr = {pc[31:2], 2'b00}; 
    // assign adr = pc[31:0]; 

    initial $readmemb("instructions.mem", instructionMemory);

    assign instruction = {instructionMemory[adr], instructionMemory[adr + 1], instructionMemory[adr + 2], instructionMemory[adr + 3]};

endmodule
