module if_id_reg(
	input wire clk,
    	input wire reset,
    	input wire [31:0] instruction_in,
    	input wire [63:0] pc_in,
    	output reg [31:0] instruction_out,
    	output reg [63:0] pc_out;
);

	always @(posedge clk or posedge reset) begin

		if (reset) begin

			instruction_out <= 32'b0;
			pc_out <= 64'b0;

		end 
		
		else begin

			instruction_out <= instruction_in;
			pc_out <= pc_in;

		end
	end
endmodule
