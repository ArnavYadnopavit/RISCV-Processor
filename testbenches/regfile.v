module reg_file(
    input wire clk,
    input wire reset,
    input wire reg_write,
    input wire [4:0] rs1,
    input wire [4:0] rs2,
    input wire [4:0] rd,
    input wire [63:0] write_data,
    output wire [63:0] read_data1,
    output wire [63:0] read_data2
);

    reg [63:0] registers [0:31];
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset)
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 64'b0;
        else if (reg_write && rd != 5'd0)
            registers[rd] <= write_data;
    end

  
    assign read_data1 = (rs1 == 5'd0) ? 64'b0 : registers[rs1];
    assign read_data2 = (rs2 == 5'd0) ? 64'b0 : registers[rs2];

endmodule