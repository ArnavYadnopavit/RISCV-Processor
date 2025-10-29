`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2025 21:23:57
// Design Name: 
// Module Name: ImmGenTestBench
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

module ImmGen_tb;

    reg [31:0] inst;
    wire [63:0] imm;
    reg [63:0] expected;
    integer errors = 0;

    // Instantiate the DUT
    ImmGen uut (
        .inst(inst),
        .imm(imm)
    );

    task check;
        input [63:0] exp;
        begin
            expected = exp;
            #1; // small delay for imm to update
            if (imm !== expected) begin
                $display("❌ FAIL: inst=%b", inst);
                $display("   Expected imm=%h, Got imm=%h", expected, imm);
                errors = errors + 1;
            end else begin
                $display("✅ PASS: inst=%b -> imm=%h", inst, imm);
            end
        end
    endtask

    initial begin
        $dumpfile("ImmGen_tb.vcd");
        $dumpvars(0, ImmGen_tb);

        // Test 1: I-type (ADDI x1, x2, 5)
        inst = 32'b000000000101_00010_000_00001_0010011; // imm=5
        check(64'd5);

        // Test 2: S-type (SW x1, 8(x2))
        inst = 32'b0000000_00001_00010_010_01000_0100011; // imm=8
        check(64'd8);

        // Test 3: B-type (BEQ x1, x2, -16)
        inst = 32'b1_000001_00010_00001_000_0000_1100011; // imm = -16
        check({52'hFFFFFFFFFFFFF, 12'hFF0}); // sign-extended -16

        // Test 4: U-type (LUI x1, 0xABCDE)
        inst = 32'b10101011110011011110000010110111; // upper 20 bits = 0xABCDE
        check({32'd0, 20'hABCDE, 12'd0});

        // Test 5: J-type (JAL x1, 0x12345)
        inst = 32'b00010010001101000101000011101111; // sample JAL
        check({44{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21]); // approximate expected

        // Test 6: Default (unknown opcode)
        inst = 32'b111111111111_00010_000_00001_0000000; // imm=-1
        check(64'hFFFFFFFFFFFFFFFF);

        // Final summary
        if (errors == 0)
            $display("\n🎉 ALL TESTS PASSED!");
        else
            $display("\n⚠️ %0d TEST(S) FAILED!", errors);

        $finish;
    end

endmodule

