`timescale 1ns/1ps

module tb_datapath_mext;

    reg clk;
    reg reset;

    // DUT (Device Under Test)
    wire [63:0] debug_pc;
    wire [31:0] inst_debug;

    pipelined_datapath dut (
        .clk(clk),
        .reset(reset),
        .debug_pc(debug_pc),
        .inst_debug(inst_debug)
    );

    // Clock generator
    initial begin
        clk = 0;
        forever #3 clk = ~clk;  // 6ns clock period
    end

    // Reset sequence
    initial begin
        reset = 1;
        #25;
        reset = 0;
    end

    // Simulation timeout and register check
    reg [63:0] expected [0:31];
    integer i, pass_count, fail_count;

    initial begin
        // Wait long enough for program to finish
        #900;
        $display("============================================");
        $display("Register File Check at 990ns");
        $display("============================================");

        // Initialize all registers to zero
        for (i = 0; i < 32; i = i + 1)
            expected[i] = 64'd0;

        // ======================================================
        // Expected register values from the M-extension program
        // ======================================================
        expected[0]  = 64'd0;       // x0 = 0
        expected[1]  = 64'd15;      // x1 = 15
        expected[2]  = -64'd3;      // x2 = -3
        expected[3]  = 64'd200;     // x3 = 200
        expected[4]  = -64'd45;     // x4 = 15 * -3 = -45
        expected[5]  = -64'd1;      // x5 = upper 64 bits of signed multiply = -1
        expected[6]  = -64'd1;    // x6 = mulhsu(-3, 200) = -600
        expected[7]  = 64'd0;       // x7 = mulhu(15, 200) = upper 64 bits = 0
        expected[8]  = -64'd5;      // x8 = div(15, -3) = -5
        expected[9]  = 64'd13;      // x9 = divu(200, 15) = 13
        expected[10] = 64'd0;       // x10 = div(-3, 15) = 0
        expected[11] = 64'd0;       // x11 = divu(15, 200) = 0
        expected[12] = 64'd0;       // x12 = rem(15, -3) = 0
        expected[13] = 64'd5;       // x13 = remu(200, 15) = 5
        expected[14] = -64'd3;      // x14 = rem(-3, 15) = -3
        expected[15] = 64'd15;      // x15 = remu(15, 200) = 15

        pass_count = 0;
        fail_count = 0;

        // Compare register file with expected values
        for (i = 0; i < 32; i = i + 1) begin
            if (dut.RF.registers[i] === expected[i]) begin
                $display("x%0d = %0d  PASS", i, dut.RF.registers[i]);
                pass_count = pass_count + 1;
            end else begin
                $display("x%0d = %0d  FAIL (expected %0d)",
                         i, dut.RF.registers[i], expected[i]);
                fail_count = fail_count + 1;
            end
        end

        $display("--------------------------------------------");
        $display("Total PASS: %0d, FAIL: %0d", pass_count, fail_count);
        if (fail_count == 0)
            $display("✅ ALL TESTS PASSED - M Extension Functional!");
        else
            $display("❌ SOME TESTS FAILED - Check multiplier/divider unit!");
        $display("============================================");

        #100;
        $finish;
    end

endmodule
