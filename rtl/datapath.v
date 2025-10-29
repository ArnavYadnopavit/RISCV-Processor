module datapath(
        input  wire clk,
        input  wire reset
);
        // Program Counter
        wire [63:0] pc_out;
        wire [63:0] pc_next;

        // Instruction
        wire [31:0] instruction;

        // Instruction Field Extraction 
        wire [6:0] opcode   = instruction[6:0];
        wire [4:0] rd       = instruction[11:7];
        wire [2:0] func3    = instruction[14:12];
        wire [4:0] rs1      = instruction[19:15];
        wire [4:0] rs2      = instruction[24:20];
        wire [6:0] func7    = instruction[31:25];
        wire       op5      = opcode[5];
        wire       func75   = func7[5];   // ALUControl

        // Control Signal
        wire [1:0] ALUOp;
        wire RegWrite, ALUSrc, MemtoReg, Branch, Jump;
        wire [2:0] MemRead, MemWrite;
        wire [2:0] InstType;

        // Register File Wires 
        wire [63:0] read_data1;
        wire [63:0] read_data2;
        wire [63:0] write_data;

        // Immediate 
        wire [63:0] imm;

        // Connections 
        wire [63:0] alu_result;
        wire [3:0]  ALUControlPort;
        wire flagzero;
        wire valid;

        // Data Memory Output
        wire [63:0] mem_data;

        // Instruction Memory
        instruction_memory IM (
                .clk(clk),
                .pc(pc_out),
                .instruction(instruction)
        );

        // Control Unit
        ControlUnit CU (
                .opcode(opcode),
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

        // Immediate Generator
        ImmGen IG (
                .inst(instruction),
                .imm(imm)
        );

        // Register File 
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

        // ALU Control 
        ALUControl ALUC (
                .op5(op5),
                .func75(func75),
                .func3(func3),
                .AluOp(ALUOp),
                .AluControlPort(ALUControlPort)
        );

        // ALU 
        ALU ALU64 (
                .a(read_data1),
                .b(ALUSrc ? imm : read_data2),
                .control(ALUControlPort),
                .out(alu_result),
                .flagzero(flagzero),
                .valid(valid)
        );

        // Data Memory
        data_memory DM (
                .clk(clk),
                .mem_read(MemRead),
                .mem_write(MemWrite),
                .addr(alu_result),
                .write_data(read_data2),
                .read_data(mem_data)
        );

        // Write Back Mux
        assign write_data = MemtoReg ? mem_data : alu_result;

        // Branch / Jump Decision
        wire take_branch;
        assign take_branch = (Branch && flagzero) || Jump;

        // Next PC Calculation
        assign pc_next = take_branch ? ((Jump && (opcode == 7'b1100111)) ? (read_data1 + imm) : (pc_out + imm)) : (pc_out + 64'd4);


        // Program Counter
        program_counter PC (
                .clk(clk),
                .reset(reset),
                .pc_next(pc_next),
                .pc_branch(take_branch),
                .pc_out(pc_out)
        );

endmodule

