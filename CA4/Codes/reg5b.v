module reg5b(input clk, rst, en, clr, input [4:0] Next, output reg [4:0] Now);

	always @(posedge clk, posedge rst) begin

		if (rst | clr) Now = 4'b0;

		else if(~en) Now = Next;

	end

endmodule