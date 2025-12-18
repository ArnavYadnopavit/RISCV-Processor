module datapath(
        input  wire clk,
        input  wire reset,
        output wire [63:0] debug_pc,
        output wire [32:0] inst_debug
);
        wire [63:0] pc_out;
        wire [63:0] pc_next;

        wire [31:0] instruction;

        wire [6:0] opcode   = instruction[6:0];
        wire [4:0] rd       = instruction[11:7];
        wire [2:0] func3    = instruction[14:12];
        wire [4:0] rs1      = instruction[19:15];
        wire [4:0] rs2      = instruction[24:20];
        wire [6:0] func7    = instruction[31:25];
        wire op5      = opcode[5];
        wire func75   = func7[5];   


        wire [2:0] ALUOp;
        wire RegWrite, ALUSrc, MemtoReg, Branch, Jump;
        wire MemRead, MemWrite;
        wire InstType;

        wire [63:0] read_data1;
        wire [63:0] read_data2;
        wire [63:0] write_data;

        wire [63:0] imm;

        wire [63:0] alu_result;
        wire [4:0]  ALUControlPort;
        wire branchAlu;
        wire valid;

        wire [63:0] mem_data;
        
        wire take_branch;

    	imem_ip IM(
        	.clka(clk),
        	.ena(1'b1),
        	.wea(4'b0),
        	.addra(pc_out[9:2]),
        	.dina(32'd0),
        	.douta(instruction)
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
                .inst(instruction),
                .imm(imm)
        );

        reg_file RF (
                .clk(clk),
                .reset(reset),
                .reg_write(RegWrite),
                .rs1(rs1),
                .rs2(rs2),
                .rd(rd),
                .write_data(write_data),
                .read_data1(read_data1),
                .read_data2(read_data2)
        );

        ALUControl ALUC (
                .op5(op5),
                .func75(func75),
                .func3(func3),
                .AluOp(ALUOp),
                .AluControlPort(ALUControlPort)
        );

        ALU ALU64 (
                .a(read_data1),
                .b(ALUSrc ? imm : read_data2),
                .control(ALUControlPort),
                .out(alu_result),
                .branchAlu(branchAlu),
                .valid(valid),
                .InstType(InstType)
        );

	dmem_top DMEM (
    		.clk(clk),
    		.we(MemWrite),         
    		.re(MemRead),          
    		.data(read_data2),       
    		.addr(alu_result),       
    		.func3(func3),           
            .out_data(mem_data)      
);


        assign write_data = ((opcode == 7'b1101111) ||     // JAL
                     (opcode == 7'b1100111)) ? pc_out :  // JAL / JALR
                    (MemtoReg) ? mem_data :              // load
                                 alu_result;             // ALU result (includes LUI)

        assign take_branch = (Branch && branchAlu) || Jump;
        wire [63:0]jumpimm;
        assign jumpimm=imm<<1;
        assign pc_next = take_branch ? 
                    ((Jump && (opcode == 7'b1100111)) ? (read_data1 + imm) :     // JALR
                     (Jump && (opcode == 7'b1101111)) ? (pc_out - 64'd4 + jumpimm) : // JAL
                     (pc_out - 64'd8 + jumpimm))                                     // other branch
                 : (opcode == 7'b0010111) ? imm                                       // AUIPC
                 : (pc_out + 64'd4);                                                  // normal PC increment


        program_counter PC (
                .clk(clk),
                .reset(reset),
                .pc_next(pc_next),
                .pc_out(pc_out)
        );

        assign debug_pc = pc_out;
        assign inst_debug=instruction;

endmodule

