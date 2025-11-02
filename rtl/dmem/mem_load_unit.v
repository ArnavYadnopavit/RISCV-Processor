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


module mem_load_unit(
    input re,
    input wire [2:0] func3,
    input  wire [63:0] data,
    output reg [63:0] read_data
    );
    wire [3:0]cswire={re,func3};
    always@(*)begin
        casez(cswire)
            4'b1000:read_data={56'd0,data[7:0]};
            4'b1001:read_data={48'd0,data[15:0]};
            4'b1010:read_data={32'd0,data[31:0]};
            4'b1011:read_data=data;
            4'b1100:read_data={{56{data[7]}},data[7:0]};
            4'b1101:read_data={{48{data[15]}},data[15:0]};
            4'b1110:read_data={{32{data[31]}},data[31:0]};
            default: read_data=64'd0;
        endcase
    end
endmodule