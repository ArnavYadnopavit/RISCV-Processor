module ex_mem_reg(
        input wire clk,
        input wire reset,
        input wire [63:0] pc_in,
        input wire [2:0] func3_in,
        input wire [63:0] alu_result_in,
        input wire branchAlu_in,
        input wire [63:0] alu_input2_in,  
	input wire [4:0]  rd_in,
        input wire RegWrite_in,
        input wire MemRead_in,
        input wire MemWrite_in,
        input wire MemReg_in,
        input wire Branch_in,
        input wire Jump_in,
        output reg [63:0] pc_out,
        output reg [2:0] func3_out,
        output reg [63:0] alu_result_out,
        output reg branchAlu_out,
        output reg [63:0] alu_input2_out,
        output reg [4:0] rd_out,
        output reg RegWrite_out,
        output reg MemRead_out,
        output reg MemWrite_out,
        output reg MemReg_out,
        output reg Branch_out,
        output reg Jump_out
);

        always @(posedge clk or posedge reset) begin
                if (reset) begin

                        pc_out <= 64'b0;
                        func3_out <= 3'b0;
                        alu_result_out <= 64'b0;
                        branchAlu_out <= 1'b0;
                        alu_input2_out <= 64'b0;
                        rd_out <= 5'b0;
                        RegWrite_out <= 1'b0;
                        MemRead_out <= 1'b0;
                        MemWrite_out <= 1'b0;
                        MemReg_out <= 1'b0;
                        Branch_out <= 1'b0;
                        Jump_out <= 1'b0;

                end 

		else begin

                        pc_out <= pc_in;
                        func3_out <= func3_in;
                        alu_result_out <= alu_result_in;
                        branchAlu_out <= branchAlu_in;
                        alu_input2_out <= alu_input2_in;
                        rd_out <= rd_in;
                        RegWrite_out <= RegWrite_in;
                        MemRead_out <= MemRead_in;
                        MemWrite_out <= MemWrite_in;
                        MemReg_out <= MemReg_in;
                        Branch_out <= Branch_in;
                        Jump_out <= Jump_in;

                end
        end
endmodule

