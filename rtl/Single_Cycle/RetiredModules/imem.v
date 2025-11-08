module instruction_memory (
    	input  wire         clk,
    	input  wire [63:0]  pc,            
    	output reg  [31:0]  instruction
);
    	(* ram_style = "block" *) reg [7:0] memory [0:1023];  // 1 KB = 1024 bytes

    	wire [9:0] addr_index = pc[9:0];  // Use only lower 10 bits (byte addressing)

    	// Read instruction: 4 consecutive bytes form a 32-bit instruction
    	always @(posedge clk) begin
        	instruction <= { memory[addr_index+3], memory[addr_index+2], memory[addr_index+1], memory[addr_index] };
    	end

    	// preload program from file
    	initial begin
        	$readmemh("program.hex", memory);
    	end

endmodule

