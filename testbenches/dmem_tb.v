`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2025 22:04:20
// Design Name: 
// Module Name: dmem_tb
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

module data_memory_tb;
    reg clk;
    reg [2:0] mem_read;
    reg [2:0] mem_write;
    reg [63:0] addr;
    reg [63:0] write_data;
    wire [63:0] read_data;

    // Instantiate DUT
    data_memory dut (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .addr(addr),
        .write_data(write_data),
        .read_data(read_data)
    );

    integer errors = 0;

    // Clock
    always #5 clk = ~clk;

    // Task to check expected value
    task check;
        input [63:0] expected;
        input [255:0] msg;
        begin
            #1;
            if (read_data !== expected) begin
                $display("❌ FAIL: %s | Expected = %h, Got = %h", msg, expected, read_data);
                errors = errors + 1;
            end else begin
                $display("✅ PASS: %s | Value = %h", msg, read_data);
            end
        end
    endtask

    initial begin
        clk = 0;
        mem_read = 3'b000;
        mem_write = 3'b000;
        addr = 0;
        write_data = 0;
        errors = 0;

        // --- STORE TESTS ---
        #10;
        addr = 0;
        write_data = 64'hAABBCCDDEEFF0011;
        mem_write = 3'b001; // SB
        @(posedge clk); mem_write = 3'b000;
        mem_read = 3'b101; // LBU
        #1; check(64'h0000000000000011, "SB -> LBU");

        addr = 8;
        write_data = 64'h1122334455667788;
        mem_write = 3'b010; // SH
        @(posedge clk); mem_write = 3'b000;
        mem_read = 3'b110; // LHU
        #1; check(64'h0000000000007788, "SH -> LHU");

        addr = 16;
        write_data = 64'hFFEEDDCCBBAA9988;
        mem_write = 3'b011; // SW
        @(posedge clk); mem_write = 3'b000;
        mem_read = 3'b011; // LW (signed)
        #1; check({32'hFFFFFFFF, 32'hBBAA9988}, "SW -> LW (sign-extend)");

        addr = 32;
        write_data = 64'h0102030405060708;
        mem_write = 3'b100; // SD
        @(posedge clk); mem_write = 3'b000;
        mem_read = 3'b100; // LD
        #1; check(64'h0102030405060708, "SD -> LD");

        // --- LOAD SIGN-EXTENSION TESTS ---
        addr = 0;
        write_data = 64'hFFFFFFFFFFFFFF80; // 0x80 = -128
        mem_write = 3'b001; // SB
        @(posedge clk); mem_write = 3'b000;
        mem_read = 3'b001; // LB
        #1; check(64'hFFFFFFFFFFFFFFFF80, "LB sign-extend -128");

        addr = 64;
        write_data = 64'h000000000000F080;
        mem_write = 3'b010; // SH
        @(posedge clk); mem_write = 3'b000;
        mem_read = 3'b010; // LH
        #1; check(64'hFFFFFFFFFFFFF080, "LH sign-extend -128");

        // --- LOAD ZERO-EXTENSION TESTS ---
        addr = 128;
        write_data = 64'h0000000000000080;
        mem_write = 3'b001; // SB
        @(posedge clk); mem_write = 3'b000;
        mem_read = 3'b101; // LBU
        #1; check(64'h0000000000000080, "LBU zero-extend 0x80");

        addr = 256;
        write_data = 64'h000000000000F080;
        mem_write = 3'b010; // SH
        @(posedge clk); mem_write = 3'b000;
        mem_read = 3'b110; // LHU
        #1; check(64'h000000000000F080, "LHU zero-extend 0xF080");

        // --- FINAL REPORT ---
        #10;
        if (errors == 0)
            $display("\n🎯 ALL TESTS PASSED SUCCESSFULLY!");
        else
            $display("\n⚠️ TESTS FAILED: %0d errors", errors);

        $finish;
    end
endmodule

