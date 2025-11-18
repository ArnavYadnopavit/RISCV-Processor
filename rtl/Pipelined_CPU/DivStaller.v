`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2025 16:08:44
// Design Name: 
// Module Name: DivStaller
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

    always @(posedge clk or posedge isDiv) begin
        //if (reset) begin
          //  Divfsm      <= {CNT_WIDTH{1'b0}};
            //Divreset   <= 1'b1;
        //end else begin
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
   // end


    
   /* 
    always@(posedge clk or posedge reset)begin
        if(reset)begin
        Divfsm<=4'b0000;
        Divreset<=1'b1;
        end
        else begin
        casez(Divfsm)
            4'b0000:begin
                    if(isDiv)begin
                            Divfsm<=4'b0001;
                            Divreset<=1'b1;
                        end
                    else begin
                            Divfsm<=4'b0000;
                        end
                   end
            4'b0001: begin
        Divfsm   <= 4'b0010;
        Divreset <= 1'b0;
    end
    4'b0010: begin
        Divfsm   <= 4'b0011;
        Divreset <= 1'b0;
    end
    4'b0011: begin
        Divfsm   <= 4'b0100;
        Divreset <= 1'b0;
    end
    4'b0100: begin
        Divfsm   <= 4'b0101;
        Divreset <= 1'b0;
    end
    4'b0101: begin
        Divfsm   <= 4'b0110;
        Divreset <= 1'b0;
    end
    4'b0110: begin
        Divfsm   <= 4'b0111;
        Divreset <= 1'b0;
    end
    4'b0111: begin
        Divfsm   <= 4'b1000;
        Divreset <= 1'b0;
    end
    4'b1000: begin
        Divfsm   <= 4'b1001;
        Divreset <= 1'b0;
    end
    4'b1001: begin
        Divfsm   <= 4'b1010;
        Divreset <= 1'b0;
    end
    4'b1010: begin
        Divfsm   <= 4'b0000;   // return to idle/start
        Divreset <= 1'b1;
    end
    default: begin
        Divfsm   <= 4'b0000;
        Divreset <= 1'b1;
    end
        endcase
        end
    end
    
    */
    assign DivStalled=!(Divfsm==4'b0000);
endmodule
