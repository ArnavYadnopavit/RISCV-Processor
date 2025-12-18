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
    output        reg valid
);


    wire [5:0] cswire;
    assign cswire = {InstType,control};
    
//add,sub,xor,or,and,sl,sra,srl
always@(*) begin
    valid=1'b1;

    casez(cswire)
    6'b0_00000: begin
    	out=$signed(a)+$signed(b); 
    end
    
    6'b0_01000: begin
    	out=$signed(a)-$signed(b);
    end
    
    6'b0_0?100: begin
    	out=a^b; //xor 100
    end
    
    6'b0_0?110: begin
    	out=a|b; //or 110
    end
    
    6'b0_0?111: begin
    	out=a&b; //and 111
    end
    
    6'b0_0?001: begin
    	out=a<<b[5:0]; //sll 001
    end
    
    6'b0_00101: begin
    	out=a>>b[5:0]; //srl 0 101 
    end
    
    6'b0_01101: begin
    	out=$signed(a)>>>b[5:0]; //sra 1 101
    end
    
    6'b0_0?010: begin
    	out = {63'b0, ($signed(a) < $signed(b))}; // SLT
    end
    
    6'b0_0?011: begin
    	out = {63'b0, (a < b)}; // SLTU
    end

    default: begin out=64'b0;
                   valid=1'b0; 
             end
    endcase
end


endmodule
