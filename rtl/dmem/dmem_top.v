`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.11.2025 16:20:59
// Design Name: 
// Module Name: dmem_top
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
// ONLY ALLOWS ALIGNED READS AND WRITES
//////////////////////////////////////////////////////////////////////////////////


module dmem_top(
input clk,
input we,
input re,
input [63:0] data,
input [63:0] addr,
input [2:0]func3,
output [63:0]out_data
    );
    wire on;
    assign on=1'b1;
    wire [7:0] write_en;
    wire [63:0] write_data;
    wire [63:0] read_data;
    wire [7:0] mem_addr;
    
    mem_store_unit MSU(
    .we(we),
    .addr(addr),
    .func3(func3),
    .data(data),
    .write_en(write_en),
    .write_data(write_data),
    .mem_addr(mem_addr)
    );
    
    blk_mem_gen_0 MEM(
            .clka(clk),
            .ena(on),
            .wea(write_en),
            .addra(mem_addr),
            .dina(write_data),
            .douta(read_data)
        );
    
    mem_load_unit MLU(
    .re(re),
    .func3(func3),
    .data(read_data),
    .read_data(out_data),
    .addr_local(addr[2:0])
    );
endmodule
