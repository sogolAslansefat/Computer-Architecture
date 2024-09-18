`timescale 1ns/1ns
module BranchController(input [2:0] func3, input branch, jal, jalr, SIGN, zero, output reg PCsource);
    parameter [2:0] BEQ = 0, BNE = 1, BLT = 4, BGE = 5;

    always @(func3, zero, SIGN, branch, jal) begin
        if (jal | jalr) begin
            PCsource <= (jal | jalr);
        end
        else begin
            case(func3)
            BEQ   : PCsource <= branch & zero;
            BNE   : PCsource <= branch & ~zero;
            BLT   : PCsource <= branch & SIGN & ~zero;
            BGE   : PCsource <= branch & ~zero & ~SIGN;
            default: PCsource <= 1'b0;
        endcase
        end

        
    end

    //always @(jal) begin
    //    PCsource <= jal;
    //end


endmodule