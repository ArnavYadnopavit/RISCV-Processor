//a and b re the operands, control is {branchinst,func75,func3}
//out is the result
//branchAlu is the branch signal to control branch pc mux
//valid if the output of alu is valid

(* use_dsp = "yes" *) module ALU(
    input clk,
    input Divreset,
    input  [63:0] a,
    input  [63:0] b,
    input  [4:0]  control,
    input         InstType,
    output reg [63:0] out,
    //output        reg branchAlu,
    output        reg valid
);

    reg [63:0] divsin1;
    reg [63:0] divsin2;
    wire [63:0] divsout;
    wire [63:0] divsrem;
    reg [63:0] divuin1;
    reg [63:0] divuin2;
    wire [63:0] divuout;
    wire [63:0] divurem;
    wire [127:0] div_s_result;
    wire [127:0] div_u_result;
    reg readys;
    reg readyu;
    wire [5:0] cswire;
    assign cswire = {InstType,control};
    reg [127:0]multresult;
    reg signed [129:0]multhsu;
//add,sub,xor,or,and,sl,sra,srl
always@(*) begin
    multresult=128'd0;
    valid=1'b1;
    //branchAlu=1'b0;
    casez(cswire)
    6'b0_00000:out=$signed(a)+$signed(b);
    6'b0_01000:out=$signed(a)-$signed(b);
    6'b0_0?100:out=a^b; //xor 100
    6'b0_0?110:out=a|b; //or 110
    6'b0_0?111:out=a&b; //and 111
    6'b0_0?001:out=a<<b; //sl 001
    6'b0_00101:out=a>>b; //srl 0 101 
    6'b0_01101:out=$signed(a)>>>b; //sra 1 101
    6'b0_0?010:out={63'b0,$signed(a)<$signed(b)}; 
    6'b0_0?011:out={63'b0,a<b}; //sltu 011
    /*
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
    */
    
    //M EXTENSION
    //MUL 
    6'b0_10_000:begin //mul
        multresult=($signed(a)* $signed(b));
        out=multresult[63:0];
        end
    6'b0_10_001:begin //mulh
        multresult=($signed(a)* $signed(b));
        out=multresult[127:64];
        end
    6'b0_10_010:begin //mulsu
        multhsu=$signed({a[63],a})* $signed({1'b0,b});
        out=multhsu[127:64];
        end
    6'b0_10_011:begin //mulu
        multresult=($unsigned(a)* $unsigned(b));
        out=multresult[127:64];
        end
    //DIV
    6'b0_10_100:begin //div
        divsin1=a;
        divsin2=b;
        readys=1'b1;
        out=divsout;
        end
    6'b0_10_101:begin //divu
        divuin1=a;
        divuin2=b;
        readyu=1'b1;
        out=divuout;
        end
    6'b0_10_110:begin //rem
        divsin1=a;
        divsin2=b;
        readys=1'b1;
        out=divsrem;
        end
    6'b0_10_111:begin //remu
        divuin1=a;
        divuin2=b;
        readyu=1'b1;
        out=divurem;
        end
    6'b1_?????:out=b;
    
    default: begin out=64'b0;
                   valid=1'b0; 
             end
    endcase
end

div_gen_0 DIVS (
  .aclk(clk),
  .aresetn(~Divreset),
  .s_axis_divisor_tvalid(),
  .s_axis_divisor_tready(),
  .s_axis_divisor_tdata(divsin2),
  .s_axis_dividend_tvalid(),
  .s_axis_dividend_tready(),
  .s_axis_dividend_tdata(divsin1),
  .m_axis_dout_tvalid(),
  .m_axis_dout_tuser(),
  .m_axis_dout_tdata(div_s_result)
);

div_gen_unsigned DIVU (
  .aclk(clk),
  .aresetn(~Divreset),
  .s_axis_divisor_tvalid(readyu),
  .s_axis_divisor_tready(),
  .s_axis_divisor_tdata(divuin2),
  .s_axis_dividend_tvalid(readyu),
  .s_axis_dividend_tready(),
  .s_axis_dividend_tdata(divuin1),
  .m_axis_dout_tvalid(),
  .m_axis_dout_tuser(),
  .m_axis_dout_tdata(div_u_result)
);
assign divsrem = div_s_result[63:0];
assign divsout = div_s_result[127:64];
assign divurem = div_u_result[63:0];
assign divuout = div_u_result[127:64];

endmodule