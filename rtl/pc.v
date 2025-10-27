module program_counter(
	input wire clk,
	input wire reset,
	input wire [63:0] pc_next, 
	input wire pc_branch,  // 0 = PC+4, 1 == branch or jump
	output reg [63:0] pc_out  // since, it needs memory (sequential logic)
);

always @(posedge clk or posedge reset) begin
	if(reset)
		pc_out <= 64'h0000000000000000;
	
	else if(pc_branch)
		pc_out <=  pc_next;
	
	else
		pc_out <= pc_out + 64'd4;
end

endmodule
