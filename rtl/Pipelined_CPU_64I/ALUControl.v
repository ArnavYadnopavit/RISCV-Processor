module ALUControl(
input op5,
input func75,
input [2:0] func3,
input [2:0]AluOp,
output reg [4:0]AluControlPort
    );
    wire [7:0]cswire;
    assign cswire={AluOp,op5,func75,func3};
    always@(*) begin
    casez(cswire)
        8'b000_?_?_???:AluControlPort=5'b00000; //add for load store
        8'b010_1_0_000:AluControlPort=5'b00000; //add rtype i type
        8'b011_0_?_000:AluControlPort=5'b00000; //add i type
        8'b010_1_1_000:AluControlPort=5'b01000; //sub rtype
        default:AluControlPort={cswire[7],cswire[3:0]};
    endcase
    end
    
endmodule
