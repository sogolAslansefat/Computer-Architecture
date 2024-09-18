module reg1b(input clk, rst, en ,clr, Next, output reg Now);

	always @(posedge clk, posedge rst) begin

		if (rst | clr) Now = 0;

		else if(~en) Now = Next;

	end

endmodule 