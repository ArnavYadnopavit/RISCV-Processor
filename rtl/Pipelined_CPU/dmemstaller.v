module dmemstaller(
    input clk,
    input MemWrite,
    input MemRead,
    output reg MemStall
    );
    wire isMem;
    assign isMem=MemWrite||MemRead;
    always@(posedge clk or posedge isMem)begin
        //if(reset)MemStall<=1'b0;
        casez(MemStall)
            1'b0:if(isMem)begin
                MemStall<=1'b1;
                end
                else MemStall<=1'b0;
            1'b1:MemStall<=1'b0;
            default:MemStall<=1'b0;        
        endcase
    end 
endmodule
