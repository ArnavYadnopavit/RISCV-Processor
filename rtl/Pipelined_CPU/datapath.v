module datapath(
        input  wire clk,
        input  wire reset,
        output wire [63:0] debug_pc,
        //output wire [63:0] debug_alu_result,
        //output wire [63:0] debug_alu_input1,
     //   output wire [63:0] debug_alu_input2,
     //   output wire [63:0] debug_regfile_out2,
     //   output wire [63:0] debug_imm_out,
        output wire [32:0] inst_debug
     //   output wire valid_alu_debug,
      //  output wire [4:0] debug_alu_control
);
        wire [63:0] pc_out;
        wire [63:0] pc_next;

        wire [31:0] instruction;

  	wire [2:0] ALUOp;
  	wire RegWrite, ALUSrc, MemtoReg, Branch, Jump, MemRead, MemWrite;
  	wire InstType;

        wire [63:0] read_data1;
        wire [63:0] read_data2;
        wire [63:0] write_data;

        wire [63:0] imm;

        wire [63:0] alu_result;
        wire [4:0]  ALUControlPort;
        wire branch_D;
        wire valid;

        wire [63:0] mem_data;
        
        wire take_branch;
        
        wire [63:0] if_id_pc_out;
	wire [31:0] if_id_instruction_out;
	
  	wire [6:0] opcode = if_id_instruction_out[6:0];
  	wire [4:0] rd = if_id_instruction_out[11:7];
  	wire [2:0] func3 = if_id_instruction_out[14:12];
  	wire [4:0] rs1 = if_id_instruction_out[19:15];
  	wire [4:0] rs2 = if_id_instruction_out[24:20];
  	wire [6:0] func7 = if_id_instruction_out[31:25];
  	wire op5 = opcode[5];
  	wire func75 = func7[5];
  	
  	wire [63:0] id_ex_pc_out, id_ex_rs1_out, id_ex_rs2_out, id_ex_imm_out;
  	wire [4:0] id_ex_rd_out;
  	wire [2:0] id_ex_func3_out, id_ex_ALUop_out;
  	wire id_ex_func75_out, id_ex_op5_out;
 	wire id_ex_ALUSrc_out, id_ex_RegWrite_out, id_ex_MemtoReg_out;
  	wire id_ex_Branch_out, id_ex_Jump_out, id_ex_MemRead_out, id_ex_MemWrite_out, id_ex_InstType_out;
  	wire [4:0] id_ex_rs1_E_out;
	wire [4:0] id_ex_rs2_E_out;
	
	
	wire [63:0] ex_mem_pc_out, ex_mem_func3_out, ex_mem_alu_result_out, ex_mem_rs2_out;
  	wire [4:0] ex_mem_rd_out;
 	wire ex_mem_branchAlu_out, ex_mem_RegWrite_out, ex_mem_MemRead_out, ex_mem_MemWrite_out;
  	wire ex_mem_MemtoReg_out, ex_mem_Branch_out, ex_mem_Jump_out;
  	
  	wire [63:0] mem_wb_mem_data_out, mem_wb_alu_result_out, mem_wb_pc_out;
  	wire [4:0] mem_wb_rd_out;
  	wire mem_wb_RegWrite_out, mem_wb_MemtoReg_out;
	
        //instruction_memory IM (
          //      .clk(clk),
           //     .pc(pc_out),
           //     .instruction(instruction)
        //);
        
        program_counter PC (
                .clk(clk),
                .reset(reset),
                .pc_next(pc_next),
                .pc_out(pc_out)
        );
        
            
    	imem_ip IM(
        	.clka(clk),
        	.ena(1'b1),
        	.wea(4'b0),
        	.addra(pc_out[15:2]),
        	.dina(32'd0),
        	.douta(instruction)
    	);
        
        if_id_reg IF_ID (
    		.clk(clk),
    		.reset(reset),
    		.instruction_in(instruction),
    		.pc_in(pc_out),
    		.instruction_out(if_id_instruction_out),
   		.pc_out(if_id_pc_out)
	);

	ControlUnit CU (
        	.opcode(opcode),
        	.func3(func3),   
        	.ALUOp(ALUOp),
        	.RegWrite(RegWrite),
        	.ALUSrc(ALUSrc),
        	.MemRead(MemRead),
        	.MemWrite(MemWrite),
        	.MemtoReg(MemtoReg),
        	.Branch(Branch),
        	.Jump(Jump),
        	.InstType(InstType)
	);


        ImmGen IG (
                .inst(if_id_instruction_out),
                .imm(imm)
        );

        reg_file RF (
                .clk(clk),
                .reset(reset),
                .reg_write(mem_wb_RegWrite_out),
                .rs1(rs1),
                .rs2(rs2),
                .rd(mem_wb_rd_out),
                .write_data(write_data),
                .read_data1(read_data1),
                .read_data2(read_data2)
        );
        //New unit added
        Branch_D brD (
                .rs1D_data(read_data1),
                .rs2D_data(read_data2),
                .pc(pcout),
                .imm(imm),
                .func3(func3),
                .branch_dec(),
                .branchpc()
        );
        
  	id_ex_reg ID_EX (
    		.clk(clk),
    		.reset(reset),
    		.pc_in(if_id_pc_out),
    		.rs1_D_in(rs1),
    		.rs2_D_in(rs2),
    		.rs1_data_in(read_data1),
    		.rs2_data_in(read_data2),
    		.imm_in(imm),
    		.rd_in(rd),
    		.func3_in(func3),
    		.func75_in(func75),
    		.ALUop_in(ALUOp),
    		.op5_in(op5),
    		.ALUSrc_in(ALUSrc),
    		.RegWrite_in(RegWrite),
    		.MemtoReg_in(MemtoReg),
    		.Branch_in(Branch),
    		.Jump_in(Jump),
    		.MemRead_in(MemRead),
    		.MemWrite_in(MemWrite),
    		.InstType_in(InstType),
    		.pc_out(id_ex_pc_out),
    		.rs1_E_out(id_ex_rs1_E_out),
    		.rs2_E_out(id_ex_rs2_E_out),
    		.rs1_data_out(id_ex_rs1_out),
    		.rs2_data_out(id_ex_rs2_out),
    		.imm_out(id_ex_imm_out),
    		.rd_out(id_ex_rd_out),
    		.func3_out(id_ex_func3_out),
    		.func75_out(id_ex_func75_out),
    		.ALUop_out(id_ex_ALUop_out),
    		.op5_out(id_ex_op5_out),
    		.ALUSrc_out(id_ex_ALUSrc_out),
    		.RegWrite_out(id_ex_RegWrite_out),
    		.MemtoReg_out(id_ex_MemtoReg_out),
    		.Branch_out(id_ex_Branch_out),
    		.Jump_out(id_ex_Jump_out),
    		.MemRead_out(id_ex_MemRead_out),
    		.MemWrite_out(id_ex_MemWrite_out),
    		.InstType_out(id_ex_InstType_out)
  	);


  	ALUControl ALUC (
    		.op5(id_ex_op5_out),
    		.func75(id_ex_func75_out),
    		.func3(id_ex_func3_out),
    		.AluOp(id_ex_ALUop_out),
    		.AluControlPort(ALUControlPort)
  	);


	ALU ALU64 (
    		.a(id_ex_rs1_out),
    		.b(id_ex_ALUSrc_out ? id_ex_imm_out : id_ex_rs2_out),
    		.control(ALUControlPort),
    		.out(alu_result),
    		//.branchAlu(branchAlu), No longer in use as branch moved to Decode
    		.valid(valid),
    		.InstType(id_ex_InstType_out)
  	);
        
  	ex_mem_reg EX_MEM (
    		.clk(clk),
    		.reset(reset),
    		.pc_in(id_ex_pc_out),
    		.func3_in(id_ex_func3_out),
    		.alu_result_in(alu_result),
    		.branchAlu_in(branchAlu),
    		.alu_input2_in(id_ex_rs2_out),
    		.rd_in(id_ex_rd_out),
    		.RegWrite_in(id_ex_RegWrite_out),
    		.MemRead_in(id_ex_MemRead_out),
    		.MemWrite_in(id_ex_MemWrite_out),
    		.MemReg_in(id_ex_MemtoReg_out),
    		.Branch_in(id_ex_Branch_out),
    		.Jump_in(id_ex_Jump_out),
    		.pc_out(ex_mem_pc_out),
    		.func3_out(ex_mem_func3_out),
    		.alu_result_out(ex_mem_alu_result_out),
    		.branchAlu_out(ex_mem_branchAlu_out),
    		.alu_input2_out(ex_mem_rs2_out),
    		.rd_out(ex_mem_rd_out),
    		.RegWrite_out(ex_mem_RegWrite_out),
    		.MemRead_out(ex_mem_MemRead_out),
    		.MemWrite_out(ex_mem_MemWrite_out),
    		.MemReg_out(ex_mem_MemtoReg_out),
    		.Branch_out(ex_mem_Branch_out),
    		.Jump_out(ex_mem_Jump_out)
  	);


  	dmem_top DMEM (
    		.clk(clk),
    		.we(ex_mem_MemWrite_out),
    		.re(ex_mem_MemRead_out),
    		.data(ex_mem_rs2_out),
    		.addr(ex_mem_alu_result_out),
    		.func3(ex_mem_func3_out),
    		.out_data(mem_data)
  	);
        
  	mem_wb_reg MEM_WB (
    		.clk(clk),
    		.reset(reset),
    		.mem_data_in(mem_data),
    		.alu_result_in(ex_mem_alu_result_out),
    		.pc_in(ex_mem_pc_out),
    		.rd_in(ex_mem_rd_out),
    		.RegWrite_in(ex_mem_RegWrite_out),
    		.MemtoReg_in(ex_mem_MemtoReg_out),
    		.mem_data_out(mem_wb_mem_data_out),
    		.alu_result_out(mem_wb_alu_result_out),
    		.pc_out(mem_wb_pc_out),
    		.rd_out(mem_wb_rd_out),
    		.RegWrite_out(mem_wb_RegWrite_out),
    		.MemtoReg_out(mem_wb_MemtoReg_out)
  	);




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
        
        
        assign debug_pc = pc_out;
       // assign debug_alu_result = alu_result;
        assign inst_debug=instruction;
       // assign debug_alu_input1=read_data1;
       // assign debug_regfile_out2=read_data2;
      //  assign debug_imm_out=imm;
      //  assign debug_alu_input2=ALUSrc ? imm : read_data2;
      //  assign valid_alu_debug=valid;
      //  assign debug_alu_control=ALUControlPort;


endmodule

