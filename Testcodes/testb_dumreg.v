`timescale 1ns / 1ps

module tb_cpu;

    reg clk;
    reg resetn;
    reg btn;
    reg [3:0] sw;

    wire [7:0] reg_out;

    // ---------------------------------------------------
    // Instantiate your DUT
    // ---------------------------------------------------
    pipelined_datapath DUT (
        .clk(clk),
        .resetn(resetn),
        .btn(btn),
        .sw(sw),
        .reg_out(reg_out)
    );

    // ---------------------------------------------------
    // Clock generation
    // ---------------------------------------------------
    initial begin
        clk = 0;
        forever #5 clk = ~clk;   // 100 MHz clock
    end

    // ---------------------------------------------------
    // Reset + inputs
    // ---------------------------------------------------
    initial begin
        resetn = 0;
        btn = 0;
        sw = 4'b0000;

        #20;
        resetn = 1;  // release reset
    end

    // ---------------------------------------------------
    // Simulation runtime control
    // ---------------------------------------------------
    initial begin
        #2000;   // run for 2000 ns (increase if needed)
        print_registers();
        $stop;
    end

    // ---------------------------------------------------
    // TASK: Prints all 32 registers from REGFILE
    // ---------------------------------------------------

    task print_registers;
        integer i;
    begin
        $display("\n================ REGISTER FILE DUMP ================");
        for (i = 0; i < 32; i = i + 1) begin
            $display("x%0d = %h", i, DUT.RF.registers[i]);
        end
        $display("==================================================\n");
    end
    endtask

endmodule
