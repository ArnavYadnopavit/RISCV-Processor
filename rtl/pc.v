module program_counter(
    	input  wire        clk,
    	input  wire        reset,
    	input  wire [63:0] pc_next,  
    	input  wire        pc_branch,  
    	output reg  [63:0] pc_out     
);
    	always @(posedge clk or posedge reset) begin
        	if (reset)
            		pc_out <= 64'h0000_0000_0000_0000;
        	else if (pc_branch)
            		pc_out <= pc_next;     
        	else
            		pc_out <= pc_out + 64'd4; 
    	end

endmodule

