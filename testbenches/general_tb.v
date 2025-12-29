`timescale 1ns/1ps

module tb_pipelined_datapath;

    reg clk;
    reg resetn;
    reg btn;
    reg [3:0] sw;
    wire [7:0] reg_out;

    // ----------------------
    // DUT
    // ----------------------
    pipelined_datapath dut (
        .clk(clk),
        .resetn(resetn),
        .btn(btn),
        .sw(sw),
        .reg_out(reg_out)
    );

    // ----------------------
    // Clock: 1 ns period
    // ----------------------
    initial clk = 0;
    always #0.5 clk = ~clk;

    // ----------------------
    // ID-stage rd extraction
    // ----------------------
    wire [4:0] id_rd;
    assign id_rd = dut.if_id_instruction_out[11:7];

    integer i;

    // ----------------------
    // Main stimulus
    // ----------------------
    initial begin
        // init
        btn    = 0;
        sw     = 0;
        resetn = 0;

        // hold reset
        #20;
        resetn = 1;

        $display("=== Starting simulation ===");

        // let program run
        #200;

        // ----------------------
        // Register dump
        // ----------------------
        $display("\n---- Register dump (x0 to x31) ----");
        for (i = 0; i < 32; i = i + 1) begin
            {btn, sw} = i[4:0];   // select register
            #20;                 // wait for reg_out to settle
            $display("x%0d = %0d (0x%0h)", i, reg_out, reg_out);
        end
        $display("----------------------------------\n");

        #100;
        $finish;
    end

    // ----------------------
    // Live pipeline monitor
    // ----------------------
    always @(posedge clk) begin
        if (resetn) begin
            $display("T=%0t | PC=%h | ID.rd=%0d | EX.rd=%0d | MEM.rd=%0d | WB.rd=%0d | WB.RegW=%b",
                $time,
                dut.pc_out,
                id_rd,
                dut.id_ex_rd_out,
                dut.ex_mem_rd_out,
                dut.mem_wb_rd_out,
                dut.mem_wb_RegWrite_out
            );
        end
    end

endmodule
