//a and b re the operands, control is {branchinst,func75,func3}
//out is the result
//branchAlu is the branch signal to control branch pc mux
//valid if the output of alu is valid

(* use_dsp = "yes" *) module ALU(
    input  [63:0] a,
    input  [63:0] b,
    input  [4:0]  control,
    input         InstType,
    output reg [63:0] out,
    output        reg branchAlu,
    output        reg valid
);


    wire [5:0] cswire;
    assign cswire = {InstType,control};
//add,sub,xor,or,and,sl,sra,srl
always@(*) begin
    valid=1'b1;
    branchAlu=1'b0;
    casez(cswire)
    6'b0_00000:out=$signed(a)+$signed(b);
    6'b0_01000:out=$signed(a)-$signed(b);
    6'b0_0?100:out=a^b; //xor 100
    6'b0_0?110:out=a|b; //or 110
    6'b0_0?111:out=a&b; //and 111
    6'b0_?001:out=a<<b; //sl 001
    6'b0_00101:out=a>>b; //srl 0 101 
    6'b0_01101:out=$signed(a)>>>b; //sra 1 101
    6'b0_0?010:out={63'b0,$signed(a)<$signed(b)}; 
    6'b0_0?011:out={63'b0,a<b}; //sltu 011
    6'b0_1?000:begin //beq
        out=64'b0;
        valid=1'b0;
        branchAlu=(a==b)?1'b1:1'b0;            
    end
    6'b0_1?001:begin //bne
        out=64'b0;
        valid=1'b0;
        branchAlu=(a!=b)?1'b1:1'b0;            
    end
    6'b0_1?100:begin //blt
        out=64'b0;
        valid=1'b0;
        branchAlu=($signed(a)<$signed(b))?1'b1:1'b0;            
    end
    6'b0_1?101:begin //bge
        out=64'b0;
        valid=1'b0;
        branchAlu=($signed(a)>=$signed(b))?1'b1:1'b0;            
    end
    6'b0_1?110:begin //bltu
        out=64'b0;
        valid=1'b0;
        branchAlu=(a<b)?1'b1:1'b0;            
    end
    6'b0_1?111:begin //bgeu
        out=64'b0;
        valid=1'b0;
        branchAlu=(a>=b)?1'b1:1'b0;            
    end
    6'b1_?????:out=b;
    default: begin out=64'b0;
                   valid=1'b0; 
             end
    endcase
end


endmodule