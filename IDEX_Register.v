
module IDEX_Register(    
    input clk, rst, wen,
    input rf_write_d, dm_write_d, memtoreg_d,
    output rf_write_q, dm_write_q, memtoreg_q,
    input [1:0] lb_d, alu_src_d,
    output [1:0] lb_q, alu_src_q,
	input stall_d,
	output stall_q,
input flush_d,
	output flush_q,
    input [2:0] branch_d,
    output [2:0] branch_q,

    input [15:0] inst_d, pc_new_d,
    output [15:0] inst_q, pc_new_q,

    input [15:0] rf_data_out1_d, rf_data_out2_d, 
    input [3:0] rf_read_reg1_d, rf_read_reg2_d, rf_write_reg_d,
    output [15:0] rf_data_out1_q, rf_data_out2_q, 
    output [3:0] rf_read_reg1_q, rf_read_reg2_q, rf_write_reg_q
);

    dff DFF1(.q(rf_write_q), .d(rf_write_d), .wen(wen), .clk(clk), .rst(rst));
	dff DFF2(.q(dm_write_q), .d(dm_write_d), .wen(wen), .clk(clk), .rst(rst));
dff DFF15(.q(stall_q), .d(stall_d), .wen(wen), .clk(clk), .rst(rst));
dff DFF16(.q(flush_q), .d(flush_d), .wen(wen), .clk(clk), .rst(rst));
	dff DFF3(.q(memtoreg_q), .d(memtoreg_d), .wen(wen), .clk(clk), .rst(rst));
	dff DFF4[1:0](.q(lb_q), .d(lb_d), .wen(wen), .clk(clk), .rst(rst));
	dff DFF5[1:0](.q(alu_src_q), .d(alu_src_d), .wen(wen), .clk(clk), .rst(rst));   
	dff DFF6[2:0](.q(branch_q), .d(branch_d), .wen(wen), .clk(clk), .rst(rst)); 
	dff DFF7[15:0](.q(inst_q), .d(inst_d), .wen(wen), .clk(clk), .rst(rst));  
	dff DFF8[15:0](.q(pc_new_q), .d(pc_new_d), .wen(wen), .clk(clk), .rst(rst));   
	dff DFF10[15:0](.q(rf_data_out1_q), .d(rf_data_out1_d), .wen(wen), .clk(clk), .rst(rst)); 
	dff DFF11[15:0](.q(rf_data_out2_q), .d(rf_data_out2_d), .wen(wen), .clk(clk), .rst(rst)); 
	dff DFF12[3:0](.q(rf_read_reg1_q), .d(rf_read_reg1_d), .wen(wen), .clk(clk), .rst(rst)); 
	dff DFF13[3:0](.q(rf_read_reg2_q), .d(rf_read_reg2_d), .wen(wen), .clk(clk), .rst(rst)); 
	dff DFF14[3:0](.q(rf_write_reg_q), .d(rf_write_reg_d), .wen(wen), .clk(clk), .rst(rst)); 
	
endmodule

/**clk, rst, wen, inst_d, inst_q, pc_new_d, pc_new_q,
	pc_next_d, pc_next_q, rf_write_d, rf_write_q, dm_write_d, dm_write_q,
	memtoreg_d, memtoreg_q, lb_d, lb_q, alu_src_d, alu_src_q, branch_d, branch_q,
	rf_data_out1_d, rf_data_out1_q, rf_data_out2_d, rf_data_out2_q, rf_read_reg1_d,
	rf_read_reg1_q, rf_read_reg2_d, rf_read_reg2_q, rf_write_reg_d, rf_write_reg_q);**/

