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
input [1:0]AluOp,
output reg [3:0]AluControlPort
    );
    wire [6:0]cswire;
    assign cswire={AluOp,op5,func75,func3};
    always@(*) begin
    casez(cswire)
        7'b00?_????:AluControlPort=4'b0000; //add
        7'b01?_????:AluControlPort=4'b1000; //sub
        default:AluControlPort=cswire[4:0];
    endcase
    end
    
endmodule
