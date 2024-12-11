module hazard_Detection_Unit(
    input [3:0] src1, src2, EXE_Dest, Mem_Dest,
    input Exe_WB_EN, Mem_WB_EN, Two_src,move,
    output reg hazard_Detected
    );

    // always@(src1, src2, Two_src, EXE_Dest, Mem_Dest, Exe_WB_EN, Mem_WB_EN)begin 
    always@(*)begin 
        hazard_Detected = 0;
        if(~move)begin
        if(Exe_WB_EN) 
        begin 
            if(src1 == EXE_Dest)
                hazard_Detected = 1;
            else if(src2 == EXE_Dest && Two_src)
                hazard_Detected = 1;

        end
        if(Mem_WB_EN) 
        begin 
            if(src1 == Mem_Dest)
                hazard_Detected = 1;
            else if(src2 == Mem_Dest && Two_src)
                hazard_Detected = 1;
        end
        end
    end














endmodule