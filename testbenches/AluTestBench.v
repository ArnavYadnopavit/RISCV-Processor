`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2025 16:24:31
// Design Name: 
// Module Name: AluTestBench
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

module alu_testbench;

    // DUT I/O
    reg  [63:0] a, b;
    reg  [4:0]  control;
    wire [63:0] out;
    wire        branchAlu;
    wire        valid;

    // Instantiate DUT
    ALU dut (
        .a(a),
        .b(b),
        .control(control),
        .out(out),
        .branchAlu(branchAlu),
        .valid(valid)
    );

    integer i;

    initial begin
        // VCD for GTKWave
        $dumpfile("alu_test.vcd");
        $dumpvars(0, alu_testbench);
        $dumpvars(0, alu_testbench.dut);

        // Initialize
        a = 64'h0000_0000_0000_0005;
        b = 64'h0000_0000_0000_0003;
        control = 5'b00000;
        #10;

        // === Arithmetic Tests ===
        control = 5'b00000; #10; // ADD
        control = 5'b01000; #10; // SUB

        // === Logical Tests ===
        control = 5'b00100; #10; // XOR
        control = 5'b00110; #10; // OR
        control = 5'b00111; #10; // AND

        // === Shift Tests ===
        a = 64'h0000_0000_0000_00F0;
        b = 64'h0000_0000_0000_0004;
        control = 5'b00001; #10; // SLL
        control = 5'b00101; #10; // SRL
        control = 5'b01101; #10; // SRA

        // === Comparison Tests ===
        a = 64'd5; b = 64'd8;
        control = 5'b00010; #10; // SLT (signed)
        control = 5'b00011; #10; // SLTU (unsigned)

        // === Branch Tests (signed and unsigned) ===
        a = 64'd5; b = 64'd5;
        control = 5'b10000; #10; // BEQ
        control = 5'b10001; #10; // BNE
        control = 5'b10100; #10; // BLT (signed)
        control = 5'b10101; #10; // BGE (signed)
        control = 5'b10110; #10; // BLTU
        control = 5'b10111; #10; // BGEU

        // === Random Tests ===
        for (i = 0; i < 10; i = i + 1) begin
            a = $random;
            b = $random;
            control = $random % 16; // pick a random operation
            #10;
        end

        // Finish simulation
        #50 $finish;
    end

endmodule

