module ControlUnit(
        input  [6:0] opcode,
        output reg [2:0] ALUOp,       
        output reg RegWrite,
        output reg ALUSrc,
        output reg [2:0] MemRead,
        output reg [2:0] MemWrite,
        output reg MemtoReg,
        output reg Branch,
        output reg Jump,
        output reg [2:0] InstType     // For datapath decoding (R/I/S/B/U/J)
);
        // Instruction type encoding
        // 000:R-type, 001:I-type, 010:S-type, 011:B-type, 100:U-type, 101:J-type
        always @(*) begin
                // default
                ALUOp    = 3'b000;
                RegWrite = 0;
                ALUSrc   = 0;
                MemRead  = 3'b000;
                MemWrite = 3'b000;
                MemtoReg = 0;
                Branch   = 0;
                Jump     = 0;
                InstType = 3'b000;

                case(opcode)
                        7'b0110011: begin         // R-type (ADD, SUB, AND, OR, SLT, etc.)
                                ALUOp    = 3'b010;  
                                RegWrite = 1;
                                ALUSrc   = 0;
                                InstType = 3'b000;
                        end

                        7'b0010011: begin         // I-type (ADDI, ANDI, ORI, SLTI, etc.)
                                ALUOp    = 3'b011;  
                                RegWrite = 1;
                                ALUSrc   = 1;
                                InstType = 3'b001;
                        end

                        7'b0000011: begin         // LOAD (LB, LH, LW, LD)
                                ALUOp    = 3'b000; 
                                RegWrite = 1;
                                ALUSrc   = 1;
                                MemtoReg = 1;
                                MemRead  = 3'b100; 
                                InstType = 3'b001;
                        end

                        7'b0100011: begin         // STORE (SB, SH, SW, SD)
                                ALUOp    = 3'b000; 
                                ALUSrc   = 1;
                                RegWrite = 0;
                                MemWrite = 3'b100; 
                                InstType = 3'b010;
                        end

                        7'b1100011: begin         // BRANCH (BEQ, BNE, etc.)
                                ALUOp    = 3'b101;  
                                Branch   = 1;
                                InstType = 3'b011;
                        end

                        7'b0110111: begin         // LUI (U-type)
                                ALUOp    = 3'b000;
                                ALUSrc   = 1;
                                RegWrite = 1;
                                InstType = 3'b100;
                        end

                        7'b1101111: begin         // JAL (J-type)
                                ALUOp    = 3'b000;
                                ALUSrc   = 1;
                                RegWrite = 1;
                                Jump     = 1;
                                InstType = 3'b101;
                        end

                        7'b1100111: begin         // JALR (I-type jump)
                                ALUOp    = 3'b000;
                                ALUSrc   = 1;
                                RegWrite = 1;
                                Jump     = 1;
                                InstType = 3'b001;
                        end

                        default: begin
                                ALUOp    = 3'b000;
                                RegWrite = 0;
                                ALUSrc   = 0;
                                MemRead  = 3'b000;
                                MemWrite = 3'b000;
                                MemtoReg = 0;
                                Branch   = 0;
                                Jump     = 0;
                                InstType = 3'b000;
                        end
                endcase
        end
endmodule

