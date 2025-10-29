`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.10.2025 16:09:19
// Design Name: 
// Module Name: ALUControl
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


module ALUControl(
input op5,
input func75,
input [2:0] func3,
input [2:0]AluOp,
output reg [4:0]AluControlPort
    );
    wire [7:0]cswire;
    assign cswire={AluOp,op5,func75,func3};
    always@(*) begin
    casez(cswire)
        7'b000?_????:AluControlPort=4'b00000; //add for load store
        7'b01??_0000:AluControlPort=4'b00000; //add rtype i type
        7'b010?_1000:AluControlPort=4'b01000; //sub rtype
        default:AluControlPort={cswire[6],cswire[3:0]};
    endcase
    end
    
endmodule
