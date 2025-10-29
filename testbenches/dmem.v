module data_memory (
        input  wire         clk,
        input  wire [2:0]   mem_read,    
        input  wire [2:0]   mem_write,  
        input  wire [63:0]  addr,        // byte address
        input  wire [63:0]  write_data,  // data to write
        output reg  [63:0]  read_data
);
        (* ram_style = "block" *) reg [7:0] memory [0:2047];
        integer i;
        wire [10:0] addr_index = addr[10:0];  

        // read
        always @(*) begin
                case (mem_read)
                
                        3'b001: read_data = {{56{memory[addr_index][7]}}, memory[addr_index]}; // LB
                        
                        3'b010: read_data = {{48{memory[addr_index+1][7]}}, memory[addr_index+1], memory[addr_index]}; // LH
                        
                        3'b011: read_data = {{32{memory[addr_index+3][7]}}, memory[addr_index+3], memory[addr_index+2], memory[addr_index+1], memory[addr_index]}; // LW
                        
                        3'b100: read_data = {memory[addr_index+7], memory[addr_index+6], memory[addr_index+5], memory[addr_index+4], memory[addr_index+3], memory[addr_index+2], memory[addr_index+1], memory[addr_index]}; // LD

                        3'b101: read_data = {{56{1'b0}}, memory[addr_index]}; // LBU
                        
                        3'b110: read_data = {{48{1'b0}}, memory[addr_index+1], memory[addr_index]}; // LHU
                        
                        3'b111: read_data = {{32{1'b0}}, memory[addr_index+3], memory[addr_index+2], memory[addr_index+1], memory[addr_index]}; // LWU

                        default: read_data = 64'b0;
                endcase
        end

        // store
        always @(posedge clk) begin
                case (mem_write)
                        3'b001: begin // SB
                                memory[addr_index] <= write_data[7:0];
                        end
                        
                        3'b010: begin // SH
                                memory[addr_index]     <= write_data[7:0];
                                memory[addr_index+1]   <= write_data[15:8];
                        end
                        
                        3'b011: begin // SW
                                for (i = 0; i < 4; i = i + 1)
                                        memory[addr_index + i] <= write_data[8*i +: 8];
                        end
                        
                        3'b100: begin // SD
                                for (i = 0; i < 8; i = i + 1)
                                        memory[addr_index + i] <= write_data[8*i +: 8];
                        end
                        
                        default: ; // no write
                endcase
        end

        initial begin
                $readmemh("data.hex", memory);
        end

endmodule

