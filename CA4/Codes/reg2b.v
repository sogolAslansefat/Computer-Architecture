module reg2b(input clk, rst, en, clr, input [1:0] Next, output reg [1:0] Now);

	always @(posedge clk, posedge rst) begin

		if (rst | clr) Now = 2'b0;

		else if(~en) Now = Next;

	end

endmodule