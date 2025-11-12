`timescale 1ns/1ps

module tb_datapath;

    reg clk;
    reg reset;

    // DUT (Device Under Test)
    wire [63:0] debug_pc;
    wire [31:0] inst_debug;

    datapath dut (
        .clk(clk),
        .reset(reset),
        .debug_pc(debug_pc),
        .inst_debug(inst_debug)
    );

    // Clock generator
    initial begin
        clk = 0;
        forever #3 clk = ~clk;  // 10ns clock period
    end

    // Reset sequence
    initial begin
        reset = 1;
        #25;
        reset = 0;
    end

    // Simulation timeout and check
    reg [63:0] expected [0:31];
        integer i, pass_count, fail_count;
    initial begin
        // Wait until 990ns
        #900;
        $display("============================================");
        $display("Register File Check at 990ns");
        $display("============================================");

        // Expected register values (from Ripes functional test)
        // Only listing registers you expect to change; others stay 0
        

        // Initialize all to zero
        for (i = 0; i < 32; i = i + 1)
            expected[i] = 64'd0;

        // Fill expected results based on your Ripes assembly
        expected[0]  = 64'd0;
        expected[1]  = 64'd5;
        expected[2]  = 64'd7;
        expected[3]  = -64'd3;
        expected[4]  = 64'd2;
        expected[5]  = 64'd8;
        expected[6]  = 64'd12;
        expected[7]  = 64'd2;
        expected[8]  = 64'd5;
        expected[9]  = 64'd7;
        expected[10] = 64'd2;
        expected[11] = 64'd20;
        expected[12] = 64'd2;
        expected[13] = -64'd1;
        expected[14] = 64'd15;
        expected[15] = 64'd1;
        expected[16] = 64'd13;
        expected[17] = 64'd9;
        expected[18] = 64'd1;
        expected[19] = 64'd0;
        expected[20] = 64'd12;
        expected[21] = 64'd19;
        expected[22] = 64'd24;
        expected[23] = 64'd5;
        expected[24] = 64'd12;
        expected[25] = 64'd12;
        expected[26] = 64'd1;
        expected[27] = 64'd2;
        expected[28] = 64'd168;
        expected[29] = 64'd9;
        expected[30] = 64'h100;
        expected[31] = 64'd00;
        // x28 = return address -> not deterministic, skip check

        pass_count = 0;
        fail_count = 0;

        // Compare registers
        for (i = 0; i < 32; i = i + 1) begin
            if (dut.RF.registers[i] === expected[i]) begin
                $display("x%0d = %0d ✅ PASS", i, dut.RF.registers[i]);
                pass_count = pass_count + 1;
            end else begin
                $display("x%0d = %0d ❌ FAIL (expected %0d)", 
                    i, dut.RF.registers[i], expected[i]);
                fail_count = fail_count + 1;
            end
        end

        $display("--------------------------------------------");
        $display("Total PASS: %0d, FAIL: %0d", pass_count, fail_count);
        if (fail_count == 0)
            $display("✅ ALL TESTS PASSED");
        else
            $display("❌ SOME TESTS FAILED");
        $display("============================================");
            #100
        $finish;
    end

endmodule
