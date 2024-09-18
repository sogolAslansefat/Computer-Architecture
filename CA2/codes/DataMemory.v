module DataMemory(input [31:0] Adr, WD, input memWrite, clk, output [31:0] readData);

    reg [7:0] dataMemory [0:$pow(2, 16)-1]; // 4GB

    wire [31:0] adr;
    //changed
    assign adr = {Adr[31:2], 2'b00};
    // assign adr = Adr[31:0];
    initial $readmemb("data.mem", dataMemory, 1000); 

    always @(posedge clk) begin
        if(memWrite)
            {dataMemory[adr + 3], dataMemory[adr + 2], dataMemory[adr + 1], dataMemory[adr]} <= WD;
    end

    assign readData = {dataMemory[adr + 3], dataMemory[adr + 2], dataMemory[adr + 1], dataMemory[adr]};

endmodule