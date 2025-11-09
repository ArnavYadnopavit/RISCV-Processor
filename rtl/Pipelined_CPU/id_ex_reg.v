module id_ex_reg(
    	input wire clk,
    	input wire reset,
    	input wire [63:0] pc_in,
    	input wire [63:0] rs1_data_in,
    	input wire [63:0] rs2_data_in,
    	input wire [63:0] imm_in,
    	input wire [4:0] rd_in,
    	input wire [2:0] func3_in,
    	input wire func75_in,
    	input wire [2:0] ALUop_in,
    	input wire op5_in,
    	input wire ALUSrc_in,
    	input wire RegWrite_in,
    	input wire MemtoReg_in,
    	input wire Branch_in,
    	input wire Jump_in,
    	input wire MemRead_in,
    	input wire MemWrite_in,
    	input wire InstType_in,
    	output reg [63:0] pc_out,
    	output reg [63:0] rs1_data_out,
   	output reg [63:0] rs2_data_out,
    	output reg [63:0] imm_out,
    	output reg [4:0] rd_out,
    	output reg [2:0] func3_out,
    	output reg func75_out,
    	output reg [2:0] ALUop_out,
    	output reg op5_out,
	output reg ALUSrc_out,
	output reg RegWrite_out,
    	output reg MemtoReg_out,
    	output reg Branch_out,
    	output reg Jump_out,
    	output reg MemRead_out,
    	output reg MemWrite_out,
    	output reg InstType_out
);

        always @(posedge clk or posedge reset) begin
                if (reset) begin
                
                        pc_out        <= 64'b0;
                        rs1_data_out  <= 64'b0;
                        rs2_data_out  <= 64'b0;
                        imm_out       <= 64'b0;
                        rd_out        <= 5'b0;
                        func3_out     <= 3'b0;
                        func75_out    <= 1'b0;
                        ALUop_out     <= 3'b0;
                        op5_out       <= 1'b0;
                        ALUSrc_out    <= 1'b0;
                        RegWrite_out  <= 1'b0;
                        MemtoReg_out  <= 1'b0;
                        Branch_out    <= 1'b0;
                        Jump_out      <= 1'b0;
                        MemRead_out   <= 1'b0;
                        MemWrite_out  <= 1'b0;
                        InstType_out  <= 3'b0;
                        
                end 
                
                else begin
                
                        pc_out        <= pc_in;
                        rs1_data_out  <= rs1_data_in;
                        rs2_data_out  <= rs2_data_in;
                        imm_out       <= imm_in;
                        rd_out        <= rd_in;
                        func3_out     <= func3_in;
                        func75_out    <= func75_in;
                        ALUop_out     <= ALUop_in;
                        op5_out       <= op5_in;
                        ALUSrc_out    <= ALUSrc_in;
                        RegWrite_out  <= RegWrite_in;
                        MemtoReg_out  <= MemtoReg_in;
                        Branch_out    <= Branch_in;
                        Jump_out      <= Jump_in;
                        MemRead_out   <= MemRead_in;
                        MemWrite_out  <= MemWrite_in;
                        InstType_out  <= InstType_in;
                        
                end
        end
endmodule
