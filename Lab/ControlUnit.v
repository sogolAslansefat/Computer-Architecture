module ControlUnit(
    input [1:0] mode,
    input [3:0] opcode,
    input S_in,
    output reg [3:0] EXE_CMD,
    output reg MEM_R_EN, MEM_W_EN, WB_EN, B, S_out,move
);

always@(S_in, mode, opcode)begin
    move = 1'b0;
    case ({mode, opcode})
        6'b00_1101:  begin EXE_CMD = 4'b0001; move = 1'b1; end//MOV
        6'b00_1111:  begin EXE_CMD = 4'b1001; move = 1'b1; end //MVN
        6'b00_0100:  EXE_CMD = 4'b0010;//ADD
        6'b00_0101:  EXE_CMD = 4'b0011;//ADC
        6'b00_0010:  EXE_CMD = 4'b0100;//SUB
        6'b00_0110:  EXE_CMD = 4'b0101;//SBC
        6'b00_0000:  EXE_CMD = 4'b0110;//AND
        6'b00_1100:  EXE_CMD = 4'b0111;//ORR
        6'b00_0001:  EXE_CMD = 4'b1000;//EOR
        6'b00_1010:  EXE_CMD = 4'b0100;//CMP
        6'b00_1000:  EXE_CMD = 4'b0110;//TST
        6'b01_0100:  EXE_CMD = 4'b0010;//LDR & STR
        default EXE_CMD = 4'b0001;

    endcase
 
end
always@(mode)begin 
    if(mode == 2'b10) //B
        B = 1'b1;
    else 
        B = 1'b0;
end

always@(mode, opcode, S_in) begin 
    MEM_R_EN = 1'b0;
    MEM_W_EN = 1'b0;
    if({mode, opcode, S_in} == 7'b01_0100_1) //LDR
        MEM_R_EN = 1'b1;
    else if({mode, opcode, S_in} == 7'b01_0100_0) //STR
        MEM_W_EN = 1'b1;
end

always@(mode, opcode, S_in) begin 
    WB_EN = 1'b1;
    if({mode, opcode}== 6'b00_1010 || {mode, opcode}==  6'b00_1000 || mode == 2'b10 || {mode, opcode, S_in} == 7'b01_0100_0)
    begin
        WB_EN = 1'b0; 
    end

end

always@(mode, S_in) begin  //see you later
    S_out = 1'b0;
    if(mode == 2'b00)
        S_out = S_in;
    // else if(mode == 2'b01 && S_in == 1'b1 ) // LDR
    //     S_out = 1'b1;
    
end


endmodule