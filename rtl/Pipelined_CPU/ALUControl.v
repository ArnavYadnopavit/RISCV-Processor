module ALUControl(
input op5,
input func70,
input func75,
input [2:0] func3,
input [2:0]AluOp,
output reg [4:0]AluControlPort
    );
    wire [8:0]cswire;
    assign cswire={AluOp,op5,func70,func75,func3};
    always@(*) begin
    casez(cswire)
        9'b000_?_??_???:AluControlPort=5'b00000; //add for load store
        9'b010_1_00_000:AluControlPort=5'b00000; //add rtype type
        9'b011_0_??_000:AluControlPort=5'b00000; //add i type
        9'b010_1_01_000:AluControlPort=5'b01000; //sub rtype
        default:AluControlPort={cswire[4:0]};
    endcase
    end
    
endmodule
