`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.11.2025 23:16:27
// Design Name: 
// Module Name: HazardDetection
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// Output StallD, stall whenever a ld instruction followed by usage in exec
// Output FlushD, to be aadded while control hazard
//ForwardAE signal controls the mux of alu input 1
//ForwardBE signal controls mux of alu input 2
//Stall F when nop has to be placed pc update stopped
//////////////////////////////////////////////////////////////////////////////////


module HazardDetection(
  	input  wire [4:0] rs1_D,
  	input  wire [4:0] rs2_D,
  	input  wire [4:0] rs1_E,
  	input  wire [4:0] rs2_E,
  	input  wire [4:0] rd_E,
  	input  wire [4:0] rd_M,
  	input  wire [4:0] rd_W,
  	//input  wire       PCSrc_E,
  	input             regwrite_E,
  	input             regwrite_M,
  	input             regwrite_W,
  	input             MemtoregE,
  	input             MemtoregM,
  	input             DivStalled,
  	output reg        StallD,
  	//output reg        FlushD,
  	output reg        FlushE,
  	output reg [1:0]  ForwardAE,
  	output reg [1:0]  ForwardBE,
  	output reg        StallF,
  	output reg [1:0]  BranchForwardAE,
  	output reg [1:0]  BranchForwardBE
);
  	always @(*) begin
    		StallD    = 1'b0;
    		StallF    = 1'b0;
    		FlushE    = 1'b0;
    		//FlushD  = 1'b0;
    		ForwardAE = 2'b00;
    		ForwardBE = 2'b00;
    		BranchForwardAE = 2'b00;
    		BranchForwardBE = 2'b00;

    		if (MemtoregE && (rd_E != 5'b0) && (rd_E == rs1_D || rd_E == rs2_D)) begin
      			StallD = 1'b1;
      			StallF = 1'b1;
      			FlushE = 1'b1;
    		end

    		if (regwrite_M && (rd_M != 5'b0) && (rs1_E == rd_M)) begin
      			ForwardAE = 2'b10;  //Forward ALU result
    		end 
    		else if (regwrite_W && (rd_W != 5'b0) && (rs1_E == rd_W)) begin
      			ForwardAE = 2'b01; //Forward Mem result
    		end

    		if (regwrite_M && (rd_M != 5'b0) && (rs2_E == rd_M)) begin
      			ForwardBE = 2'b10;  //Forward ALU result
    		end 
    		else if (regwrite_W && (rd_W != 5'b0) && (rs2_E == rd_W)) begin
      			ForwardBE = 2'b01;  //Forward Mem result
    		end

    		/*
    		if (PCSrc_E == 1'b1) begin
      			FlushD = 1'b1;
      			//FlushE = 1'b1;
    		end
    		*/
    		//Branch forwarding
            // rs1 forwarding
            if ( MemtoregM && (rd_M==rs1_D || rd_M==rs2_D) ) begin
                 // second-cycle stall (waiting for WB)
                StallD = 1; StallF = 1; FlushE = 1;
            end
            
            if (regwrite_E && (rd_E != 5'b0) && (rd_E == rs1_D)) begin
                BranchForwardAE = 2'b01; // forward EX stage
            end 
            else if (regwrite_W && (rd_W != 5'b0) && (rd_W == rs1_D)) begin
                BranchForwardAE= 2'b11; // forward WB stage
            end 

            // rs2 forwarding
            if (regwrite_E && (rd_E != 5'b0) && (rd_E == rs2_D)) begin
                BranchForwardBE = 2'b01; // forward EX stage
            end 
            else if (regwrite_W && (rd_W != 5'b0) && (rd_W == rs2_D)) begin
                BranchForwardBE = 2'b11; // forward WB stage
            end 
            
            if(DivStalled)begin
                StallD = 1'b1;
      			StallF = 1'b1;
      			FlushE = 1'b1;
            end
        
  	end

endmodule

