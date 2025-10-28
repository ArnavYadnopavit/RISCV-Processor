`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.10.2025 23:19:50
// Design Name: 
// Module Name: regfile_testbench
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


`timescale 1ns / 1ps

module reg_file_testbench;

    // Testbench signals
    reg clk;
    reg reset;
    reg reg_write;
    reg [4:0] rs1, rs2, rd;
    reg [63:0] write_data;
    wire [63:0] read_data1, read_data2;

    // Instantiate the DUT (Device Under Test)
    reg_file dut (
        .clk(clk),
        .reset(reset),
        .reg_write(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Generate clock (100 MHz -> 10 ns period)
    initial clk = 0;
    always #5 clk = ~clk;

    // Test procedure
    initial begin
        // Enable waveform dump
        $dumpfile("reg_file_testbench.vcd");
        $dumpvars(0, reg_file_testbench);

        // Initial values
        reset = 1;
        reg_write = 0;
        rs1 = 0;
        rs2 = 0;
        rd = 0;
        write_data = 0;

        // Apply reset
        #10;
        reset = 0;

        // --- TEST 1: Write to register 5 ---
        @(posedge clk);
        reg_write = 1;
        rd = 5'd5;
        write_data = 64'hDEADBEEFCAFEBABE;

        @(posedge clk);
        reg_write = 0; // stop writing

        // --- TEST 2: Read back from register 5 ---
        @(posedge clk);
        rs1 = 5'd5;
        rs2 = 5'd0; // x0 should always be zero

        @(posedge clk);
        $display("Time=%0t | ReadData1 (x5) = %h | ReadData2 (x0) = %h",
                 $time, read_data1, read_data2);

        // --- TEST 3: Write to register 10 ---
        @(posedge clk);
        reg_write = 1;
        rd = 5'd10;
        write_data = 64'h123456789ABCDEF0;

        @(posedge clk);
        reg_write = 0;

        // --- TEST 4: Read from x5 and x10 simultaneously ---
        @(posedge clk);
        rs1 = 5'd5;
        rs2 = 5'd10;

        @(posedge clk);
        $display("Time=%0t | ReadData1 (x5) = %h | ReadData2 (x10) = %h",
                 $time, read_data1, read_data2);

        // --- TEST 5: Attempt to write x0 (should remain zero) ---
        @(posedge clk);
        reg_write = 1;
        rd = 5'd0;
        write_data = 64'hFFFFFFFFFFFFFFFF;

        @(posedge clk);
        reg_write = 0;
        rs1 = 5'd0;

        @(posedge clk);
        $display("Time=%0t | ReadData1 (x0) = %h (should be 0)", 
                 $time, read_data1);

        $finish;
    end

endmodule

