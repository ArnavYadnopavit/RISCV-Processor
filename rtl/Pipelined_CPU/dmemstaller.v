module dmemstaller(
    input  wire clk,
    input  wire reset,
    input  wire MemRead,
    input  wire MemWrite,
    output reg  MemStall
);
    reg prev_mem;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            MemStall  <= 1'b0;
            prev_mem <= 1'b0;
        end else begin
            prev_mem <= (MemRead || MemWrite);
            // one-cycle pulse when a new mem op enters MEM
            MemStall <= (MemRead || MemWrite) && !prev_mem;
        end
    end
endmodule

