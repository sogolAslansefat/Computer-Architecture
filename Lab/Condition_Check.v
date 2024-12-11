module Condition_Check(
    input [3:0] Cond,
    input [3:0] SR, output reg out
);
    //SR[0] = N
    //SR[1] = Z
    //SR[2] = C
    //SR[3] = V
    always@(Cond, SR) begin 
        out = 1'b0;
        case(Cond)
            4'b0000: begin if(SR[1]) out = 1'b1;end 
            4'b0001: begin if(!SR[1]) out = 1'b1;end 
            4'b0010: begin if(SR[2]) out = 1'b1;end 
            4'b0011: begin if(!SR[2]) out = 1'b1;end 
            4'b0100: begin if(SR[0]) out = 1'b1;end 
            4'b0101: begin if(!SR[0]) out = 1'b1;end 
            4'b0110: begin if(SR[3]) out = 1'b1;end 
            4'b0111: begin if(!SR[3]) out = 1'b1;end 
            4'b1000: begin if(SR[2] && !SR[1]) out = 1'b1;end 
            4'b1001: begin if(!SR[2] && SR[1]) out = 1'b1;end 
            4'b1010: begin if(SR[0] == SR[3]) out = 1'b1;end 
            4'b1011: begin if(SR[0] != SR[3]) out = 1'b1;end 
            4'b1100: begin if(SR[1] == 0 &&  SR[0] == SR[3]) out = 1'b1;end 
            4'b1101: begin if(SR[1] == 1 &&  SR[0] != SR[3]) out = 1'b1;end 
            4'b1110: begin out = 1'b1;end 
            default: out = 1'b0; 
        endcase
    end
endmodule