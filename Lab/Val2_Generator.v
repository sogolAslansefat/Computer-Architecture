module Val2_Generator(Val_Rm, imm, Shift_operand, OR_out, Val2);

    input [31:0] Val_Rm;
    input imm, OR_out;
    input [11:0] Shift_operand;
    output reg [31:0] Val2;

    always@(*)begin
        Val2 = 32'b0;
        if(OR_out)
            Val2 = Shift_operand[11:0];
        else if (imm == 1'b0) begin
            case (Shift_operand[6:5])
                2'd0: Val2 = Val_Rm << Shift_operand[11:7]; //LSL
                2'd1: Val2 = Val_Rm >> Shift_operand[11:7]; //LSR
                2'd2: Val2 = Val_Rm >>> Shift_operand[11:7]; //ASR
                2'd3: Val2 = Val_Rm >> Shift_operand[11:7] | Val_Rm << ~Shift_operand[11:7]; // ROR
            endcase
        end
        else if (imm == 1'b1) begin
            case(Shift_operand[11:8])
                4'd0: Val2 = {24'd0, Shift_operand[7:0]};
                4'd1: Val2 = {Shift_operand[1:0], 24'd0, Shift_operand[7:2]};
                4'd2: Val2 = {Shift_operand[3:0], 24'd0, Shift_operand[7:4]};
                4'd3: Val2 = {Shift_operand[5:0], 24'd0, Shift_operand[7:6]};
                4'd4: Val2 = {Shift_operand[7:0], 24'd0};
                4'd5: Val2 = {2'd0, Shift_operand[7:0], 22'd0};
                4'd6: Val2 = {4'd0, Shift_operand[7:0], 20'd0};
                4'd7: Val2 = {6'd0,Shift_operand[7:0], 18'd0};
                4'd8: Val2 = {8'd0, Shift_operand[7:0], 16'd0};
                4'd9: Val2 = {10'd0, Shift_operand[7:0], 14'd0};
                4'd10: Val2 = {12'd0, Shift_operand[7:0], 12'd0};
                4'd11: Val2 = {14'd0, Shift_operand[7:0], 10'd0};
                4'd12: Val2 = {16'd0, Shift_operand[7:0], 8'd0};
                4'd13: Val2 = {18'd0, Shift_operand[7:0], 6'd0};
                4'd14: Val2 = {20'd0, Shift_operand[7:0], 4'd0};
                4'd15: Val2 = {22'd0, Shift_operand[7:0], 2'd0};
            endcase
        end

    end


endmodule

