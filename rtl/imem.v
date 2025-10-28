module instruction_memory (
    	input  wire [63:0] addr,         
    	output wire [31:0] instruction
);
    	reg [31:0] memory [0:255];       //256 x 32-bit = 1 KB instruction_memory
    
    	assign instruction = memory[addr[9:2]];  

    	// preload program from file
    	initial begin
        	$readmemh("program.hex", memory);
    	end
endmodule

