module StatusRegister(input clk, rst, S, N_IN, Z_IN, C_IN, V_IN,
                      output reg N_OUT, Z_OUT, C_OUT, V_OUT);
    always @(negedge clk, posedge rst) begin
      if (rst) begin
        N_OUT <= 1'b0;
        Z_OUT <= 1'b0;
        C_OUT <= 1'b0;
        V_OUT <= 1'b0;
      end
      else if (S) begin
        N_OUT <= N_IN;
        Z_OUT <= Z_IN;
        C_OUT <= C_IN;
        V_OUT <= V_IN;
      end       
    end
endmodule