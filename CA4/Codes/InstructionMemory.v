module InstructionMemory(input [31:0] PC, output [31:0] Instr);

	reg[31:0] InstMem[15999:0];

	integer j;

	initial begin $readmemh("code.txt", InstMem);

			for(j = 0; j < 15; j = j + 1) $display("%h", InstMem[j]); end

	assign Instr = InstMem[PC[15:0] >> 2];

endmodule