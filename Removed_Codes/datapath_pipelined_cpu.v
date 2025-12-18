
	/*
        assign write_data = ((opcode == 7'b1101111) ||     // JAL
                     (opcode == 7'b1100111)) ? pc_out :  // JAL / JALR
                    (MemtoReg) ? mem_data :              // load
                                 alu_result;             // ALU result (includes LUI)


        

        assign take_branch = (Branch && branch_D) || Jump;
        wire [63:0]jumpimm;
        assign jumpimm=imm<<1;
        assign pc_next = take_branch ? 
                    ((Jump && (opcode == 7'b1100111)) ? (read_data1 + imm) :     // JALR
                     (Jump && (opcode == 7'b1101111)) ? (pc_out - 64'd4 + jumpimm) : // JAL
                     (pc_out - 64'd8 + jumpimm))                                     // other branch
                 : (opcode == 7'b0010111) ? imm                                       // AUIPC
                 : (pc_out + 64'd4);                                                  // normal PC increment



        
        //always @(posedge clk,posedge reset)begin
        //    if (reset) 
        //        stall<=1'b0;
        //    if(opcode== 7'b0000011 | opcode==7'b1100011 | opcode==7'b1101111 | opcode==7'b1100111)
        //        stall=~stall;
        //end
        */
        
        //assign debug_pc = pc_out[5:2];
       // assign debug_alu_result = alu_result;
        //assign inst_debug=instruction;
       // assign debug_alu_input1=read_data1;
       // assign debug_regfile_out2=read_data2;
      //  assign debug_imm_out=imm;
      //  assign debug_alu_input2=ALUSrc ? imm : read_data2;
      //  assign valid_alu_debug=valid;
      //  assign debug_alu_control=ALUControlPort;


