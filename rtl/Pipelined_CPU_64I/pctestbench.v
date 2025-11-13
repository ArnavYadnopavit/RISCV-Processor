`timescale 1ns/1ps

module pctestbench;

    // Testbench signals
    reg clk;
    reg reset;
    reg [9:0] pc_next;
    reg pc_branch;
    wire [9:0] pc_out;

    // Instantiate the DUT (Device Under Test)
    program_counter dut (
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc_branch(pc_branch),
        .pc_out(pc_out)
    );

    // Clock generation: 10 ns period (100 MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    // Stimulus
    initial begin
        // Dump waveform (for GTKWave or Vivado simulator)
        $dumpfile("pctestbench.vcd");
        $dumpvars(0, pctestbench);

        // Initialize inputs
        reset = 1;
        pc_branch = 0;
        pc_next = 10'd0;

        // Apply reset
        #10;
        reset = 0;

        // Let PC increment normally for a few cycles
        #40;

        // Simulate a branch: jump to address 40
        pc_next = 10'd40;
        pc_branch = 1;
        #10;
        pc_branch = 0; // back to sequential mode

        // Continue counting from new branch target
        #40;

        // Another branch: jump to address 100
        pc_next = 10'd100;
        pc_branch = 1;
        #10;
        pc_branch = 0;

        // Continue for a few more cycles
        #40;

        $finish;
    end

    // Optional monitor for console output
    initial begin
        $monitor("Time=%0t | reset=%b | branch=%b | pc_next=%d | pc_out=%d",
                 $time, reset, pc_branch, pc_next, pc_out);
    end

endmodule
