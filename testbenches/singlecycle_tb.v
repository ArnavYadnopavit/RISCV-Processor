`timescale 1ns / 1ps

module singlecycle_tb;

    // Clock and reset
    reg clk;
    reg reset;

    // Debug outputs from datapath
    wire [63:0] debug_pc;
    wire [31:0] inst_debug;

    // Instantiate DUT
    datapath uut (
        .clk(clk),
        .reset(reset),
        .debug_pc(debug_pc),
        .inst_debug(inst_debug)
    );

    // Clock generation: 10ns period (100 MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    // Reset pulse
    initial begin
        reset = 1;
        #13;
        reset = 0;
    end

    // Simulation duration backup (safety)
    initial begin
        #2000000; // safety timeout (200 us)
        $display("Timeout reached, finishing simulation.");
        $finish;
    end

    // Console header
    initial begin
        $display("--------------------------------------------------------------------------");
        $display("| Time(ns) |     PC      |    Instruction    |   ALU_in1   |   ALU_in2   |   ALU_out   |");
        $display("--------------------------------------------------------------------------");
    end

    

    // Optional: waveform dump (GTKWave / Vivado)
    initial begin
        $dumpfile("singlecycle_tb.vcd");
        $dumpvars(2, singlecycle_tb);
    end

endmodule
