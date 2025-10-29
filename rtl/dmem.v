module data_memory (
    	input  wire         clk,
    	input  wire [2:0]   mem_read,   // 000:none, 001:byte, 010:half, 011:word, 100:dword
    	input  wire [2:0]   mem_write,  // same encoding as mem_read
    	input  wire [63:0]  addr,       // byte address (64-bit address bus from CPU)
    	input  wire [63:0]  write_data, // data to write
    	output reg  [63:0]  read_data
);
    	// 2 KB = 2048 bytes = 0x800 bytes
    	(* ram_style = "block" *) reg [7:0] memory [0:2047];

    	integer i;

    	// READ
    	always @(*) begin
        	case (mem_read)
            		3'b001:  // Byte
                		read_data = {{56{memory[addr][7]}}, memory[addr]};  // sign-extend
            		3'b010:  // Halfword (2 bytes)
                		read_data = {{48{memory[addr+1][7]}}, memory[addr+1], memory[addr]};
            		3'b011:  // Word (4 bytes)
                		read_data = {{32{memory[addr+3][7]}}, memory[addr+3], memory[addr+2], memory[addr+1], memory[addr]};
            		3'b100:  // Doubleword (8 bytes)
                	read_data = {memory[addr+7], memory[addr+6], memory[addr+5], memory[addr+4], memory[addr+3], memory[addr+2], memory[addr+1], memory[addr]};
            		default:
                	read_data = 64'b0;
        	endcase
    	end

    	// WRITE
    	always @(posedge clk) begin
        	case (mem_write)
        		3'b001: memory[addr] <= write_data[7:0]; // store byte
        	    	3'b010: begin
                		memory[addr]   <= write_data[7:0];
                		memory[addr+1] <= write_data[15:8];
            		end
            		3'b011: begin
                		for (i=0; i<4; i=i+1)
                    			memory[addr+i] <= write_data[8*i +: 8];
            		end
            		3'b100: begin
                		for (i=0; i<8; i=i+1)
                    			memory[addr+i] <= write_data[8*i +: 8];
            		end
            		default: ; // no write
        		endcase
    		end

	// preload program from file
    	initial begin
        	$readmemh("data.hex", memory);
    	end

endmodule

