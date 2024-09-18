module hazardunit(clk, Rs1D, Rs2D, Rs1E, Rs2E, RdE, PCSrcE, ResultSrcE0, RdM, RegWriteM, RdW, RegWriteW,
                  StallF, StallD, FlushD, FlushE, ForwardAE, ForwardBE);

    input clk, PCSrcE, ResultSrcE0, RegWriteM, RegWriteW;
    input [4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW;
    output StallF, StallD, FlushD, FlushE;
    output reg [1:0] ForwardAE, ForwardBE;
    wire lwStall;

    always@(posedge clk, RdM, Rs1E, RegWriteM, RdW, RegWriteW, Rs2E) begin
        if     ((RdM == Rs1E) & RegWriteM & (Rs1E != 5'b0)) ForwardAE = 2'b10;
        else if((RdW == Rs1E) & RegWriteW & (Rs1E != 5'b0)) ForwardAE = 2'b01;
        else                                                ForwardAE = 2'b00;
        if     ((RdM == Rs2E) & RegWriteM & (Rs2E != 5'b0)) ForwardBE = 2'b10;
        else if((RdW == Rs2E) & RegWriteW & (Rs2E != 5'b0)) ForwardBE = 2'b01;
        else                                                ForwardBE = 2'b00;
    end

    assign lwStall = (((Rs1D == RdE) | (Rs2D == RdE)) & (ResultSrcE0));
    assign StallF = lwStall;
    assign StallD = lwStall;
    assign FlushE = lwStall | PCSrcE;
    assign FlushD = PCSrcE;
endmodule