module reg3b(input clk, rst, en, clr, input [2:0] Next, output reg [2:0] Now);

	always @(posedge clk, posedge rst) begin

		if (rst | clr) Now = 3'b0;

		else if(~en) Now = Next;

	end

endmodule