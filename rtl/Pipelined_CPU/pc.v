module program_counter(
  	input  wire        clk,
  	input  wire        reset,
  	input  wire        stall,
  	input  wire [63:0] pc_next,
  	output reg  [63:0] pc_out
);

  	always @(posedge clk or posedge reset) begin
    		if (reset)
      			pc_out <= 64'b0;
    		else if (~stall)
      			pc_out <= pc_out;     // Hold PC during stall
    		else
      			pc_out <= pc_next;
  	end

endmodule

