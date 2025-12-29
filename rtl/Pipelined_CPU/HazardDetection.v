// Output StallD, stall whenever a ld instruction followed by usage in exec
// Output FlushD, to be aadded while control hazard
//ForwardAE signal controls the mux of alu input 1
//ForwardBE signal controls mux of alu input 2
//Stall F when nop has to be placed pc update stopped

module HazardDetection(
  	input wire [4:0] rs1_D,
  	input wire [4:0] rs2_D,
  	input wire [4:0] rs1_E,
  	input wire [4:0] rs2_E,
  	input wire [4:0] rd_E,
  	input wire [4:0] rd_M,
  	input wire [4:0] rd_W,
  	input wire [6:0] opcode_E,
  	input regwrite_E,
  	input regwrite_M,
  	input regwrite_W,
  	input MemtoregE,
  	input MemtoregM,
  	input DivStalled,
  	input MemStall,
  	output reg StallD,
  	output reg StallE,
  	output reg FlushE,
  	output reg StallM,
  	output reg [1:0] ForwardAE,
  	output reg [1:0] ForwardBE,
  	output reg StallF,
  	output reg [1:0] BranchForwardAE,
  	output reg [1:0] BranchForwardBE,
  	input wire [6:0] opcode_D
);
    wire isItype;
    assign isItype = (opcode_E == 7'b0010011) || 
                     (opcode_E == 7'b0000011) || 
                     (opcode_E == 7'b1100111) || 
                     (opcode_E == 7'b1110011);
                
    wire isBranchD;
    assign isBranchD = (opcode_D == 7'b1100011);


  	always @(*) begin
      
    		    StallD = 1'b0;
    		    StallF = 1'b0;
    		    FlushE = 1'b0;
    		    StallE = 1'b0;
    		    StallM = 1'b0;
    		    ForwardAE = 2'b00;
    		    ForwardBE = 2'b00;
    		    BranchForwardAE = 2'b00;
    		    BranchForwardBE = 2'b00;
    		
    		    if(MemStall)begin
                    StallD = 1'b1;
      			        StallF = 1'b1;
      			        StallE = 1'b1;
      			        StallM = 1'b1;
            end
            
            else begin

    		            // EX stage load-use hazard: lw in EX, use in ID
                    
              if (!StallE && MemtoregE && (rd_E != 5'b0) &&
                  (rd_E == rs1_D || rd_E == rs2_D)) begin
                      StallD = 1'b1;
                      StallF = 1'b1;
                      FlushE = 1'b1;
              end


            // rs1
            if (regwrite_M && !MemtoregM && (rd_M != 5'b0) && (rs1_E == rd_M))
                      ForwardAE = 2'b10;
              
            else if (regwrite_W && (rd_W != 5'b0) && (rs1_E == rd_W))
                      ForwardAE = 2'b01;

            // rs2
            if (!isItype) begin
                      if (regwrite_M && !MemtoregM && (rd_M != 5'b0) && (rs2_E == rd_M))
                              ForwardBE = 2'b10;
              
                      else if (regwrite_W && (rd_W != 5'b0) && (rs2_E == rd_W))
                              ForwardBE = 2'b01;
            end


    	    //Branch forwarding
    	    
          // Load -> branch hazard: stall only if ID instr is a branch
          // Branch depends on EX stage result → stall
            if (isBranchD && regwrite_E && (rd_E != 5'b0) && (rd_E == rs1_D || rd_E == rs2_D)) begin
                      StallD = 1'b1;
                      StallF = 1'b1;
                       //FlushE = 1'b1;
            end
            
          // rs1 branch forwarding
          if (regwrite_M && (rd_M != 5'b0) && (rd_M == rs1_D))
                   BranchForwardAE = 2'b10;

          else if (regwrite_W && (rd_W != 5'b0) && (rd_W == rs1_D))
                   BranchForwardAE = 2'b01;

          // rs2 branch forwarding
          if (regwrite_M && (rd_M != 5'b0) && (rd_M == rs2_D))
                   BranchForwardBE = 2'b10;
          else if (regwrite_W && (rd_W != 5'b0) && (rd_W == rs2_D))
                   BranchForwardBE = 2'b01;
            
          if(DivStalled)begin
                   StallD = 1'b1;
      			       StallF = 1'b1;
      			       StallE = 1'b1;
          end
              
      end            
        
  	end
      
endmodule
