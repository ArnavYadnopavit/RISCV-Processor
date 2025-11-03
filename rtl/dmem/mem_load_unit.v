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
    input wire re,
    input wire [2:0] func3,
    input wire  [2:0] addr_local,
    input  wire [63:0] data,
    output reg [63:0] read_data
    );
    wire [6:0]cswire={re,func3,addr_local};
    always@(*)begin
        casez(cswire)
            7'b1_000_000:read_data={{56{data[7]}},data[7:0]}; //lb
            7'b1_000_001:read_data={{56{data[15]}},data[15:8]};
            7'b1_000_010:read_data={{56{data[23]}},data[23:16]};
            7'b1_000_011:read_data={{56{data[31]}},data[31:24]};
            7'b1_000_100:read_data={{56{data[39]}},data[39:32]};
            7'b1_000_101:read_data={{56{data[47]}},data[47:40]};
            7'b1_000_110:read_data={{56{data[55]}},data[55:48]};
            7'b1_000_111:read_data={{56{data[63]}},data[63:56]};
            
            7'b1_001_000:read_data={{48{data[15]}},data[15:0]};//lh
            7'b1_001_010:read_data={{48{data[31]}},data[31:16]};
            7'b1_001_100:read_data={{48{data[47]}},data[47:32]};
            7'b1_001_110:read_data={{48{data[63]}},data[63:48]};
            
            7'b1_010_000:read_data={{32{data[31]}},data[31:0]};//lw
            7'b1_010_100:read_data={{32{data[63]}},data[63:32]};
            
            7'b1_011_000:read_data=data;//ld
            
            7'b1_100_000:read_data={56'd0,data[7:0]}; //lbu
            7'b1_100_001:read_data={56'd0,data[15:8]};
            7'b1_100_010:read_data={56'd0,data[23:16]};
            7'b1_100_011:read_data={56'd0,data[31:24]};
            7'b1_100_100:read_data={56'd0,data[39:32]};
            7'b1_100_101:read_data={56'd0,data[47:40]};
            7'b1_100_110:read_data={56'd0,data[55:48]};
            7'b1_100_111:read_data={56'd0,data[63:56]};
            
            7'b1_101_000:read_data={48'd0,data[15:0]};//lhu
            7'b1_101_010:read_data={48'd0,data[31:16]};
            7'b1_101_100:read_data={48'd0,data[47:32]};
            7'b1_101_110:read_data={48'd0,data[63:48]};
            
            7'b1_110_000:read_data={32'd0,data[31:0]};//lwu
            7'b1_110_100:read_data={32'd0,data[63:32]};
            default: read_data=64'd0;
        endcase
    end
endmodule