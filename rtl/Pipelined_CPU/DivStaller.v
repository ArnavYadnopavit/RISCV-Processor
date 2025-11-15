`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2025 16:08:44
// Design Name: 
// Module Name: DivStaller
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


module DivStaller(
    input clk,
    input reset,
    input [4:0] AluControlPort,
    output DivStalled
    );
    
    reg [2:0] Divfsm;
    wire isDiv;
    
    assign isDiv=(AluControlPort[4]&AluControlPort[2]);
    always@(posedge clk or posedge reset)begin
        if(reset)begin
        Divfsm<=3'b000;
        end
        else begin
        casez(Divfsm)
            3'b000:begin
                    if(isDiv)begin
                            Divfsm<=3'b001;
                        end
                    else begin
                            Divfsm<=3'b000;
                        end
                   end
            3'b001: Divfsm<=3'b010;
            3'b010: Divfsm<=3'b011;
            3'b011: Divfsm<=3'b100;
            3'b100: Divfsm<=3'b101;
            3'b101: Divfsm<=3'b110;
            3'b110: Divfsm<=3'b111;
            3'b111: Divfsm<=3'b000;
            default:Divfsm<=3'b000;
        endcase
        end
    end
    assign DivStalled=!(Divfsm==3'b000);
endmodule
