//TO be editted (make memwrite and mem red buses to handle word,byte,double word)
module data_memory (
    	input  wire         clk,
    	input  wire         mem_read,      
    	input  wire         mem_write,      // 1 = write to memory
    	input  wire [9:0]  addr,           
    	input  wire [63:0]  write_data,     
    	output reg  [63:0]  read_data     
);
    // 2 KB memory = 2048 x 8-bit 
    	(* ram_style = "block" *)reg [7:0] memory [0:2047];

    // Word index: ignore lower 3 bits since each word = 8 bytes
    	wire [7:0] word_index = addr[9:2];

    // Combinational read (OK for single-cycle CPU)
    	always @(posedge clk) begin
        	if (mem_read)
            		read_data <= memory[word_index];
        else
            	read_data <= 64'b0;
    	end

    // Synchronous write (on clock edge)
    	always @(posedge clk) begin
        	if (mem_write)
            		memory[word_index] <= write_data;
    	end
    
    	initial begin
        	$readmemh("data.hex",memory);
    	end

endmodule

