module instruction_memory (
        input  wire         clk,
    	input  wire [9:0] pc,         
    	output reg [31:0] instruction
);
    	(* ram_style = "block" *)reg [7:0] memory [0:1023];       //1024 x 8-bit = 1 KB instruction_memory
        
    	always @(posedge clk) begin
        	instruction <= memory[pc];  
    	end

    	// preload program from file
    	initial begin
        	$readmemh("program.hex", memory);
    	end
endmodule

