`timescale 1ns/1ps

module imem_testbench;

    // Testbench signals
    reg clk;
    reg [9:0] pc;
    wire [31:0] instruction;

    // Instantiate the DUT (Device Under Test)
    instruction_memory dut (
        .clk(clk),
        .pc(pc),
        .instruction(instruction)
    );

    // Generate a clock (100 MHz -> 10 ns period)
    initial clk = 0;
    always #5 clk = ~clk;

    // Stimulus block
    initial begin
        // Dump waveform for GTKWave/Vivado simulation
        $dumpfile("imem_testbench.vcd");
        $dumpvars(0, imem_testbench);

        // Initialize PC
        pc = 10'd0;

        // Wait some cycles and read sequentially
        #10;   // Allow reset time (if any)

        // Read first few instructions
        repeat (10) begin
            @(posedge clk);
            $display("Time=%0t | PC=%0d | Instruction=%h", $time, pc, instruction);
            pc = pc + 1;
        end

        // Jump to another address and read a few bytes
        @(posedge clk);
        pc = 10'd000;
        repeat (5) begin
            @(posedge clk);
            $display("Time=%0t | PC=%0d | Instruction=%h", $time, pc, instruction);
            pc = pc + 4;
        end

        $finish;
    end

endmodule
