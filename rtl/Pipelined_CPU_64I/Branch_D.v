(* use_dsp = "yes" *)module Branch_D(
        input [63:0] rs1D_data,
        input [63:0] rs2D_data,
        input [63:0] pc,
        input [63:0] imm,
        input [2:0]  func3,
        output reg   branch_dec,
        output reg   [63:0] branchpc
    );
    wire eq,lt,ltu;
    assign eq=(rs1D_data==rs2D_data);
    assign lt=($signed(rs1D_data)<$signed(rs2D_data));
    assign ltu=(rs1D_data<rs2D_data);
    
    always@(*)begin
        casez(func3)
            3'b000:branch_dec=eq;
            3'b001:branch_dec=~eq;
            3'b100:branch_dec=lt;
            3'b101:branch_dec=~lt;
            3'b110:branch_dec=ltu;
            3'b111:branch_dec=~ltu;
            default:branch_dec=1'b0;
        endcase
        branchpc=pc+(imm<<1'b1);
    end
    
    
    
endmodule
