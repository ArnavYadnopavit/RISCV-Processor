`timescale 1ns/1ps

module tb_datapath_bubble;

    reg clk;
    reg resetn;
    reg btn;
    reg [3:0] sw;

    // DUT
    wire [7:0] reg_out;

    pipelined_datapath dut (
        .clk(clk),
        .resetn(resetn),
        .btn(btn),
        .sw(sw),
        .reg_out(reg_out)
    );

    // Clock generator
    initial begin
        clk = 0;
        forever #3 clk = ~clk;  // 6ns period
    end

    // Reset + button + switches
    initial begin
        resetn = 0;
        btn    = 0;
        sw     = 4'b0000;
        #25;
        resetn = 1;
    end

    // Main test logic
    initial begin
        // Allow program to run fully (adjust if needed)
        #9000;

        $display("============================================");
        $display("   Register File Values for x27 to x31");
        $display("============================================");

        $display("x27 = %0d", dut.RF.registers[27]);
        $display("x28 = %0d", dut.RF.registers[28]);
        $display("x29 = %0d", dut.RF.registers[29]);
        $display("x30 = %0d", dut.RF.registers[30]);
        $display("x31 = %0d", dut.RF.registers[31]);

        $display("============================================");

        #100;
        $finish;
    end

endmodule
