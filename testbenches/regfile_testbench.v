`timescale 1ns/1ps
module reg_file_tb;

    // --- DUT I/O ---
    reg clk;
    reg reset;
    reg reg_write;
    reg [4:0] rs1, rs2, rd;
    reg [63:0] write_data;
    wire [63:0] read_data1, read_data2;

    // --- Instantiate DUT ---
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

    // --- Clock ---
    initial clk = 0;
    always #5 clk = ~clk;          // 10 ns period

    // --- Task: compare and print result ---
    task check(input [63:0] got, input [63:0] exp, input [127:0] msg);
        begin
            if (got === exp)
                $display("[%0t] PASS: %s = %h",$time,msg,got);
            else
                $display("[%0t] FAIL: %s expected %h got %h",$time,msg,exp,got);
        end
    endtask

    integer i;

    // --- Test sequence ---
    initial begin
        // Dump for timing diagram
        $dumpfile("reg_file.vcd");
        $dumpvars(0, reg_file_tb);
        for (i = 0; i < 32; i = i + 1) begin
            $dumpvars(0, reg_file_tb.dut.registers[i]);
        end

        // Initialize
        reset = 1; reg_write = 0;
        rs1 = 0; rs2 = 0; rd = 0; write_data = 0;

        // Apply reset
        @(posedge clk);
        reset = 0;
        @(posedge clk);

        // --- Write some registers ---
        for (i = 0; i <= 3; i = i + 1) begin
            @(posedge clk);
            reg_write = 1;
            rd = i[4:0];
            write_data = 64'h1000 + i;
        end
        @(posedge clk) reg_write = 0;

        // --- Read and verify ---
        rs1 = 5'd1; rs2 = 5'd2; #20;
        check(read_data1, 64'h1001, "read_data1 (x1)");
        check(read_data2, 64'h1002, "read_data2 (x2)");

        rs1 = 5'd3; rs2 = 5'd0; #20;
        check(read_data1, 64'h1003, "read_data1 (x3)");
        check(read_data2, 64'h0,    "read_data2 (x0)");

        // --- Try writing to x0 (should stay 0) ---
        @(posedge clk);
        reg_write = 1; rd = 5'd0; write_data = 64'hAAAA_BBBB_CCCC_DDDD;
        @(posedge clk) reg_write = 0;

        rs1 = 5'd0; #20;
        check(read_data1, 64'h0, "x0 must stay 0");

        // --- Done ---
        #20;
        $display("All tests complete.  Open reg_file.vcd in your waveform viewer.");
        $finish;
    end

endmodule