module ControlUnit(
        input  [6:0] opcode,
        input  [2:0] func3,
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
        // Instruction Type Encoding 
        // 000:R-type, 001:I-type, 010:S-type, 011:B-type, 100:U-type, 101:J-type
        always @(*) begin
                // Default 
                ALUOp    = 3'b000;
                RegWrite = 1'b0;
                ALUSrc   = 1'b0;
                MemRead  = 3'b000;
                MemWrite = 3'b000;
                MemtoReg = 1'b0;
                Branch   = 1'b0;
                Jump     = 1'b0;
                InstType = 3'b000;

                case (opcode)
                        7'b0110011: begin         // R-type
                                ALUOp    = 3'b010;  
                                RegWrite = 1'b1;
                                ALUSrc   = 1'b0;
                                InstType = 3'b000;
                        end

                        7'b0010011: begin         // I-type s
                                ALUOp    = 3'b011;  
                                RegWrite = 1'b1;
                                ALUSrc   = 1'b1;
                                InstType = 3'b001;
                        end

                        7'b0000011: begin         // LOAD
                                ALUOp    = 3'b000; 
                                RegWrite = 1'b1;
                                ALUSrc   = 1'b1;
                                MemtoReg = 1'b1;
                                InstType = 3'b001;
                                case (func3)
                                        3'b000: MemRead = 3'b001; // LB
                                        3'b001: MemRead = 3'b010; // LH
                                        3'b010: MemRead = 3'b011; // LW
                                        3'b011: MemRead = 3'b100; // LD
                                        3'b100: MemRead = 3'b101; // LBU
                                        3'b101: MemRead = 3'b110; // LHU
                                        3'b110: MemRead = 3'b111; // LWU
                                        default: MemRead = 3'b000;
                                endcase
                        end

                        7'b0100011: begin         // STORE
                                ALUOp    = 3'b000; 
                                ALUSrc   = 1'b1;
                                RegWrite = 1'b0;
                                InstType = 3'b010;
                                case (func3)
                                        3'b000: MemWrite = 3'b001; // SB
                                        3'b001: MemWrite = 3'b010; // SH
                                        3'b010: MemWrite = 3'b011; // SW
                                        3'b011: MemWrite = 3'b100; // SD
                                        default: MemWrite = 3'b000;
                                endcase
                        end

                        7'b1100011: begin         // BRANCH
                                ALUOp    = 3'b101;  
                                Branch   = 1'b1;
                                InstType = 3'b011;
                        end

                        7'b0110111: begin         // LUI
                                ALUOp    = 3'b000;
                                ALUSrc   = 1'b1;
                                RegWrite = 1'b1;
                                InstType = 3'b100;
                        end

                        7'b1101111: begin         // JAL
                                ALUOp    = 3'b000;
                                ALUSrc   = 1'b1;
                                RegWrite = 1'b1;
                                Jump     = 1'b1;
                                InstType = 3'b101;
                        end

                        7'b1100111: begin         // JALR
                                ALUOp    = 3'b000;
                                ALUSrc   = 1'b1;
                                RegWrite = 1'b1;
                                Jump     = 1'b1;
                                InstType = 3'b001;
                        end

                        default: begin
                                ALUOp    = 3'b000;
                                RegWrite = 1'b0;
                                ALUSrc   = 1'b0;
                                MemRead  = 3'b000;
                                MemWrite = 3'b000;
                                MemtoReg = 1'b0;
                                Branch   = 1'b0;
                                Jump     = 1'b0;
                                InstType = 3'b000;
                        end
                endcase
        end
endmodule

