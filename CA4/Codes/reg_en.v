module reg_en(input clk, rst, en, clr, input [31:0] Next, output reg [31:0] Now);

	always @(posedge clk, posedge rst)begin

		if (rst | clr) Now = 32'b0;

		else if(!en) Now = Next;

	end

endmodule