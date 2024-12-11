module ALU(Val1, Val2, EXE_CMD, SR, ALU_Res, N, Z, C, V);
    input signed [31:0] Val1,Val2;
    input [3:0]EXE_CMD;
    input [3:0] SR;
    output reg [31:0] ALU_Res;
    output reg C;
    output Z, N;
    output reg V;
    // wire [31:0] Val2;
    // assign Val2 =  (EXE_CMD == 4'b0100 || EXE_CMD == 4'b0101) ? ~Val2 + 1'b1 : Val2 ; 
    // always @(EXE_CMD, Val2, Val1, SR) begin
     always @(*) begin
        ALU_Res = 32'b0;
        C = 1'b0;
        V = 1'b0;
        case (EXE_CMD)
        4'b0001: ALU_Res = Val2;
        4'b1001: ALU_Res = ~Val2;
        4'b0010: begin {C,ALU_Res} = Val1 + Val2;
            if(Val1[31] & Val2[31] & ~ALU_Res[31])
                V = 1'b1;
            else if(~Val1[31] & ~Val2[31] & ALU_Res[31])
                V = 1'b1;
            
        end
        4'b0011: begin {C,ALU_Res} = Val1 + Val2 + {31'b0,SR[2]};
            if(Val1[31] & Val2[31] & ~ALU_Res[31])
                V = 1'b1;
            else if(~Val1[31] & ~Val2[31] & ALU_Res[31])
                V = 1'b1;

        end
        4'b0100: begin {C,ALU_Res} = Val1 - Val2;
            if(Val1[31] & ~Val2[31] & ~ALU_Res[31])
                V = 1'b1;
            else if(~Val1[31] & Val2[31] & ALU_Res[31])
                V = 1'b1;
        end
        4'b0101: begin {C,ALU_Res} = Val1 - Val2-{32'b0,!(SR[2])} ;

            if(Val1[31] & ~Val2[31] & ~ALU_Res[31])
                V = 1'b1;
            else if(~Val1[31] & Val2[31] & ALU_Res[31])
                V = 1'b1;

        end

        4'b0110: ALU_Res = Val1 & Val2;
        4'b0111: ALU_Res = Val1 | Val2;
        4'b1000: ALU_Res = Val1 ^ Val2;
        4'b0100: begin {C,ALU_Res} = Val1 - Val2;
            if(Val1[31] & ~Val2[31] & ~ALU_Res[31])
                V = 1'b1;
            else if(~Val1[31] & Val2[31] & ALU_Res[31])
                V = 1'b1;
        end
        4'b0110: ALU_Res = Val1 & Val2;
        4'b0010: begin {C,ALU_Res} = Val1 + Val2;
            if(Val1[31] & Val2[31] & ~ALU_Res[31])
                V = 1'b1;
            else if(~Val1[31] & ~Val2[31] & ALU_Res[31])
                V = 1'b1;
        end
        default: {C,ALU_Res} = Val1 + Val2;
    endcase

    end
    assign Z = (ALU_Res == 32'b0);
    assign N = (ALU_Res[31] == 1);
     
    // assign V = (((Val1[31]&Val2[31]) &&  (ALU_Res[31] == 1'b0)) ||  (((!Val1[31])&(!Val2[31])) &&  (ALU_Res[31] == 1'b1)))? 1 : 0;
    // assign V = (Val1[31] == ~Val2[31]) && (ALU_Res[31] != Val1[31]);
endmodule