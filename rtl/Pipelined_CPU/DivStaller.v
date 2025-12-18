module DivStaller#(
    parameter integer DIV_LATENCY = 9   // number of cycles to stall (must be >= 1)
)(
    input clk,
    input reset,
    input [4:0] AluControlPort,
    output DivStalled,
    output reg Divreset
    );
    
    
    // width to hold DIV_LATENCY (DIV_LATENCY >= 1)
    localparam integer CNT_WIDTH = $clog2(DIV_LATENCY + 1);
    reg [CNT_WIDTH-1:0] Divfsm;
    wire isDiv;
    assign isDiv = (AluControlPort[4] & AluControlPort[2]);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Divfsm      <= {CNT_WIDTH{1'b0}};
            Divreset   <= 1'b1;
        end else begin
            // Start a new division only when no division is active (count == 0)
            if (isDiv && (Divfsm == {CNT_WIDTH{1'b0}})) begin
                // initialize counter to DIV_LATENCY
                Divfsm      <= DIV_LATENCY[CNT_WIDTH-1:0];
                Divreset   <= 1'b1;    // one-cycle pulse - matches your current ALU (aresetn = ~Divreset)
            end
            else if (Divfsm != {CNT_WIDTH{1'b0}}) begin
                Divfsm     <= Divfsm - 1'b1;
                Divreset   <= 1'b0;    // only the first cycle after start had Divreset=1
            end
            else begin
                // idle
                Divreset   <= 1'b1;
                Divfsm      <= {CNT_WIDTH{1'b0}};
            end
        end
    end

    assign DivStalled=!(Divfsm==4'b0000);
endmodule
