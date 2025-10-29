`timescale 1ns/1ps

module controlunit_tb();

    // Inputs
    reg  [6:0] opcode;
    reg  [2:0] func3;

    // Outputs
    wire [2:0] ALUOp;
    wire       RegWrite;
    wire       ALUSrc;
    wire [2:0] MemRead;
    wire [2:0] MemWrite;
    wire       MemtoReg;
    wire       Branch;
    wire       Jump;
    wire [2:0] InstType;

    // DUT (Device Under Test)
    ControlUnit dut (
        .opcode(opcode),
        .func3(func3),
        .ALUOp(ALUOp),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .Branch(Branch),
        .Jump(Jump),
        .InstType(InstType)
    );

    // Test procedure
    initial begin
        $dumpfile("controlunit_tb.vcd");
        $dumpvars(0, controlunit_tb);

        // Default func3 value
        func3 = 3'b000;

        // Test 1: R-type
        opcode = 7'b0110011; #10;

        // Test 2: I-type (Immediate)
        opcode = 7'b0010011; #10;

        // Test 3: LOAD - try LB, LH, LW, LD, LBU, LHU, LWU
        opcode = 7'b0000011;
        func3  = 3'b000; #10; // LB
        func3  = 3'b001; #10; // LH
        func3  = 3'b010; #10; // LW
        func3  = 3'b011; #10; // LD
        func3  = 3'b100; #10; // LBU
        func3  = 3'b101; #10; // LHU
        func3  = 3'b110; #10; // LWU

        // Test 4: STORE - SB, SH, SW, SD
        opcode = 7'b0100011;
        func3  = 3'b000; #10; // SB
        func3  = 3'b001; #10; // SH
        func3  = 3'b010; #10; // SW
        func3  = 3'b011; #10; // SD

        // Test 5: BRANCH
        opcode = 7'b1100011; func3 = 3'b000; #10;

        // Test 6: LUI
        opcode = 7'b0110111; #10;

        // Test 7: JAL
        opcode = 7'b1101111; #10;

        // Test 8: JALR
        opcode = 7'b1100111; #10;

        // Test 9: Invalid opcode (for default case)
        opcode = 7'b1111111; #10;

        // End simulation
        #20;
        $finish;
    end

endmodule
