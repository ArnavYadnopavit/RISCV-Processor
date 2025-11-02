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
// 
//////////////////////////////////////////////////////////////////////////////////


module mem_store_unit(
    input we,
    input [63:0] addr,
    input wire [2:0] func3,
    input  wire [63:0] data,
    output reg [7:0] write_en,
    output wire [63:0] write_data,
    output wire [7:0] mem_addr
    );
wire [3:0] cswire;
assign cswire = {{we},{func3}};
assign write_data=data;
assign mem_addr=addr[7:0];
always @(*) begin
    casez(cswire)
        4'b1000:begin
                    write_en=8'h01;
                end
        4'b1001:begin
                    write_en=8'h03;
                end
        4'b1010:begin
                    write_en=8'h0F;
                end
        4'b1011:begin
                    write_en=8'hFF;
                end
        default:write_en=8'h00;
    endcase
end 


endmodule
