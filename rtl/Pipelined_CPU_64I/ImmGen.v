`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2025 16:54:23
// Design Name: 
// Module Name: ImmGen
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
// 
//////////////////////////////////////////////////////////////////////////////////


module ImmGen(
    input [31:0] inst,
    output reg [63:0] imm
    );
    wire [6:0] opcode;
    assign opcode = inst[6:0];
    always@(*) begin
        casez(opcode)
        7'b010_0011: imm={{52{inst[31]}},inst[31:25],inst[11:7]}; //for s type
        7'b110_0011: imm={{52{inst[31]}},inst[31],inst[7],inst[30:25],inst[11:8]}; //for b type to be right shifted  when given to pc hardware
        7'b0?1_0111: imm={32'd0,inst[31:12],12'd0}; //lui and auipc
        7'b110_1111: imm={{44{inst[31]}},inst[31],inst[19:12],inst[20],inst[30:21]}; //jal AAAAHHH
        default:imm={{52{inst[31]}},inst[31:20]};//For I type and load instructions and jalr
        endcase 
    end
endmodule
