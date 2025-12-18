//a and b re the operands, control is {branchinst,func75,func3}
//out is the result
//branchAlu is the branch signal to control branch pc mux
//valid if the output of alu is valid

(* use_dsp = "yes" *) module ALU(
    input clk,
    input Divreset,
    input [63:0] a,
    input [63:0] b,
    input [4:0] control,
    input InstType,
    output reg [63:0] out,
    output reg valid
);
    wire signed [31:0] a32 = a[31:0];
    wire signed [31:0] b32 = b[31:0];
    wire [5:0] shamt64 = b[5:0];
    wire [4:0] shamt32 = b[4:0];

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
    
    reg signed [31:0] res_s32;
    reg [31:0] res_u32;

    
//add,sub,xor,or,and,sl,sra,srl

always@(*) begin
    divsin1=64'b0;
    divsin2=64'b0;
    divuin1=64'b0;
    divuin2=64'b0;
    readyu=64'b0;
    multresult=128'd0;
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
    
    6'b0_10000: begin                               // ADDW / ADDIW
        res_s32 = a32 + b32;
        out = {{32{res[31]}}, res};
    end

    6'b0_11000: begin                               // SUBW
        res_s32 = a32 - b32;
        out = {{32{res[31]}}, res};
    end

    6'b0_10001: begin                               // SLLW
        res_s32 = a32 << b[4:0];
        out = {{32{res[31]}}, res};
    end

    6'b0_10101: begin                               // SRLW
        res_s32 = a32 >> b[4:0];
        out = {{32{res[31]}}, res};
    end

    6'b0_11101: begin                               // SRAW
        res_s32 = a32 >>> b[4:0];
        out = {{32{res[31]}}, res};
    end
    
    //M EXTENSION
    
    //MUL 
    
    6'b0_10_000: begin                              // MUL
        multresult = $signed(a) * $signed(b);
        out = multresult[63:0];
    end

    6'b0_10_001: begin                              // MULH
        multresult = $signed(a) * $signed(b);
        out = multresult[127:64];
    end

    6'b0_10_010: begin                              // MULHSU
        multhsu = $signed(a) * $unsigned(b);
        out = multhsu[127:64];
    end

    6'b0_10_011: begin                              // MULHU
        multresult = $unsigned(a) * $unsigned(b);
        out = multresult[127:64];
    end
    
    //DIV
    
    6'b0_10_100: begin                              // DIV
        divsin1 = a;
        divsin2 = b;
        readys  = 1'b1;
        out     = divsout;
    end

    6'b0_10_101: begin                              // DIVU
        divuin1 = a;
        divuin2 = b;
        readyu  = 1'b1;
        out     = divuout;
    end

    6'b0_10_110: begin                              // REM
        divsin1 = a;
        divsin2 = b;
        readys  = 1'b1;
        out     = divsrem;
    end

    6'b0_10_111: begin                              // REMU
        divuin1 = a;
        divuin2 = b;
        readyu  = 1'b1;
        out     = divurem;
    end
    
    6'b0_11_000: begin                              // MULW
        res_s32 = a32 * b32;
        out = {{32{res_s32[31]}}, res_s32};
    end
    
	6'b0_11_100: begin                                // DIVW
            divsin1 = {{32{a[31]}}, a[31:0]};
            divsin2 = {{32{b[31]}}, b[31:0]};
            readys  = 1'b1;
            w_res   = divsout[31:0];
            out     = {{32{w_res[31]}}, w_res};
        end

        6'b0_11_101: begin                                // DIVUW
            divuin1 = {32'b0, a[31:0]};
            divuin2 = {32'b0, b[31:0]};
            readyu  = 1'b1;
            w_res   = divuout[31:0];
            out     = {{32{w_res[31]}}, w_res};
        end

        6'b0_11_110: begin                                // REMW
            divsin1 = {{32{a[31]}}, a[31:0]};
            divsin2 = {{32{b[31]}}, b[31:0]};
            readys  = 1'b1;
            w_res   = divsrem[31:0];
            out     = {{32{w_res[31]}}, w_res};
        end

        6'b0_11_111: begin                                // REMUW
            divuin1 = {32'b0, a[31:0]};
            divuin2 = {32'b0, b[31:0]};
            readyu  = 1'b1;
            w_res   = divurem[31:0];
            out     = {{32{w_res[31]}}, w_res};
        end

    6'b1_?????:out=b;
    
    default: begin out=64'b0;
                   divsin1=64'b0;
                   divsin2=64'b0;
                   divuin1=64'b0;
                   divuin2=64'b0;
                   readyu=64'b0;
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
