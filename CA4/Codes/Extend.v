module Extend(input signed [31:7] imm, [2:0] immSrc, output reg signed [31:0] ImmExt);

	always @(imm, immSrc) begin

	case (immSrc)

	3'b000: ImmExt = {{20{imm[31]}}, imm[31:20]};

	3'b001: ImmExt = {{20{imm[31]}}, imm[31:25], imm[11:7]};

	3'b010: ImmExt = {{19{imm[31]}}, imm[31], imm[7], imm[30:25], imm[11:8], 1'b0};

	3'b011: ImmExt = {{11{imm[31]}}, imm[31], imm[19:12], imm[20], imm[30:21], 1'b0};

	3'b100: ImmExt = {imm[31:12], 12'b0};

	endcase

	end

endmodule