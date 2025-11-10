`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.11.2025 19:04:31
// Design Name: 
// Module Name: mem_store_unit
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
// ONLY ALLOWS
//////////////////////////////////////////////////////////////////////////////////


module mem_store_unit(
    input we,
    input [63:0] addr,
    input wire [2:0] func3,
    input  wire [63:0] data,
    output reg [7:0] write_en,
    output wire [63:0] write_data,
    output wire [12:0] mem_addr
    );
wire [6:0] cswire;
assign cswire = {{we},{func3},{addr[2:0]}};
wire [5:0] shiftwire;
assign shiftwire={{addr[2:0]},3'b0};
assign write_data=data<<shiftwire;
assign mem_addr=addr[10:3];
always @(*) begin
    casez(cswire)
        7'b1_000_000:write_en=8'h01;//sb addressing
        7'b1_000_001:write_en=8'h02;
        7'b1_000_010:write_en=8'h04;
        7'b1_000_011:write_en=8'h08;
        7'b1_000_100:write_en=8'h10;
        7'b1_000_101:write_en=8'h20;
        7'b1_000_110:write_en=8'h40;
        7'b1_000_111:write_en=8'h80;
        
        7'b1_001_000:write_en=8'h03;//sh addressing aligned store
        7'b1_001_010:write_en=8'h0C;
        7'b1_001_100:write_en=8'h30;
        7'b1_001_110:write_en=8'hC0;
        
        7'b1_010_000:write_en=8'h0F;//sw addressing aligned store
        7'b1_010_100:write_en=8'hF0;
        
        7'b1_011_000:write_en=8'hFF;//sd addressing aligned store
        
        default:write_en=8'h00;
    endcase
end 


endmodule
