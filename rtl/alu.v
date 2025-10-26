module ALU(
    input  [63:0] a,
    input  [63:0] b,
    input  [3:0]  control,
    output reg [63:0] out,
    output        reg flagzero,
    output        reg valid
);
//add,sub,xor,or,and,sl,sra,srl
always@(*) begin
    valid=1'b1;
    casez(control)
    4'b0000:out=a+b;
    4'b1000:out=a-b;
    4'b?100:out=a^b; //xor 100
    4'b?110:out=a|b; //or 110
    4'b?111:out=a&b; //and 111
    4'b?001:out=a<<b; //sl 001
    4'b0101:out=a>>b; //srl 0 101 
    4'b1101:out=$signed(a)>>>b; //sra 1 101
    4'b?010:out={63'b0,$signed(a)<$signed(b)}; //slt 010
    4'b?011:out={63'b0,a<b}; //sltu 011
    default: begin out=64'b0;
                   valid=1'b0; 
             end
    endcase
    flagzero = out==64'b0;
end


endmodule