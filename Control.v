module Control( opcode, rf_write, dm_write, memtoreg, lb, alu_src, branch );
	input [3:0] opcode;
	output reg rf_write, dm_write, memtoreg;
	output reg [1:0] lb, alu_src;
	output reg [2:0] branch;


	always @(*) begin
        case(opcode)
	///add
            4'b0000: begin rf_write = 1; dm_write = 0; memtoreg = 0; lb = 2'b00; alu_src = 2'b00; branch = 3'b000; end
	///sub
            4'b0001: begin rf_write = 1; dm_write = 0; memtoreg = 0; lb = 2'b00; alu_src = 2'b00; branch = 3'b000; end
	///xor
            4'b0010: begin rf_write = 1; dm_write = 0; memtoreg = 0; lb = 2'b00; alu_src = 2'b00; branch = 3'b000; end
	///red
            4'b0011: begin rf_write = 1; dm_write = 0; memtoreg = 0; lb = 2'b00; alu_src = 2'b00; branch = 3'b000; end
	///sll
            4'b0100: begin rf_write = 1; dm_write = 0; memtoreg = 0; lb = 2'b00; alu_src = 2'b01; branch = 3'b000; end
	//sra
            4'b0101: begin rf_write = 1; dm_write = 0; memtoreg = 0; lb = 2'b00; alu_src = 2'b01; branch = 3'b000; end
	///ror
            4'b0110: begin rf_write = 1; dm_write = 0; memtoreg = 0; lb = 2'b00; alu_src = 2'b01; branch = 3'b000; end
	///paddsb
            4'b0111: begin rf_write = 1; dm_write = 0; memtoreg = 0; lb = 2'b00; alu_src = 2'b00; branch = 3'b000; end
	///lw
            4'b1000: begin rf_write = 1; dm_write = 0; memtoreg = 1; lb = 2'b00; alu_src = 2'b10; branch = 3'b000; end
	///sw
            4'b1001: begin rf_write = 0; dm_write = 1; memtoreg = 0; lb = 2'b00; alu_src = 2'b10; branch = 3'b000; end
	///llb
            4'b1010: begin rf_write = 1; dm_write = 0; memtoreg = 0; lb = 2'b01; alu_src = 2'b00; branch = 3'b000; end 
	///lhb 
            4'b1011: begin rf_write = 1; dm_write = 0; memtoreg = 0; lb = 2'b11; alu_src = 2'b00; branch = 3'b000; end 
	///b  
            4'b1100: begin rf_write = 0; dm_write = 0; memtoreg = 0; lb = 2'b00; alu_src = 2'b00; branch = 3'b001; end
	///br
            4'b1101: begin rf_write = 0; dm_write = 0; memtoreg = 0; lb = 2'b00; alu_src = 2'b00; branch = 3'b010; end 
	///pcs 
            4'b1110: begin rf_write = 1; dm_write = 0; memtoreg = 0; lb = 2'b00; alu_src = 2'b00; branch = 3'b011; end 
	///hlt
            4'b1111: begin rf_write = 0; dm_write = 0; memtoreg = 0; lb = 2'b00; alu_src = 2'b00; branch = 3'b100; end        
	    
           
            default: begin rf_write = 1; dm_write = 0; memtoreg = 0; lb = 2'b00; alu_src = 2'b00; branch = 3'b000; end
        endcase
    end






endmodule
