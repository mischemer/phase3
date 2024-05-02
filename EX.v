module EX(
    input clk, 
    input rst,
    input rf_write, dm_write, memtoreg,
    input [1:0] lb, alu_src,
    input [2:0] branch,
    input [15:0] inst, pc_new, rf_data_out1, rf_data_out2, 
    input [3:0] rf_read_reg1, rf_read_reg2, rf_write_reg,

    input [15:0] exex_data1, exex_data2, memex_data1, memex_data2,
    input [1:0] mux1, mux2,
    output rf_write_out, dm_write_out, memtoreg_out,
    output [15:0] rf_data_out2_out, result_out,
    output [3:0] rf_read_reg1_out, rf_read_reg2_out, rf_write_reg_out,
    output [2:0] flags_out, branch_out
);

    wire [15:0] alu_input, alu_result, lb_input, result;
    wire [2:0] flags, flags_r;
    
     wire[15:0] alu_in1, alu_in2;

    assign alu_in1 = mux1[1] ? exex_data1 : (mux1[0] ? memex_data1 : rf_data_out1);
    assign alu_in2 = mux2[1] ? exex_data2 : (mux2[0] ? memex_data2 : rf_data_out2);
    // ALU input selection
    assign alu_input = alu_src[0] ? {{12{1'b0}}, inst[3:0]} :
                       (alu_src[1]) ? {{12{inst[3]}}, inst[3:0]} << 1 :
                       alu_in2;

    // ALU module instantiation
    ALU lu (.Opcode(inst[15:12]), .rs(alu_in1), .rt(alu_input), .flag_out(flags), .rd(alu_result), .flags_in(flags_r));

    // Flag_Register module instantiation
    Flag_Register FG(.clk(clk), .rst(rst), .D(flags), .Q(flags_r));
    assign flags_out = flags_r;
    // Load byte input selection
    assign lb_input = lb[1] ? ((alu_in1 & 16'h00FF) | inst[7:0] << 8) :
                      ((alu_in1 & 16'hFF00) | inst[7:0]);

    // Result selection
    assign result = lb[0] ? lb_input :
                    (branch[1] & branch[0]) ? pc_new :
                    alu_result;

    // EXMEM_Register module instantiation
    EXMEM_Register EXMEM(
        .clk(clk),
        .rst(rst),
        .wen(1'b1),
	.branch_d(branch),
        .rf_write_d(rf_write),
        .dm_write_d(dm_write),
        .memtoreg_d(memtoreg),
        .rf_data_out2_d(rf_data_out2),
        .rf_read_reg1_d(rf_read_reg1),
        .rf_read_reg2_d(rf_read_reg2),
        .rf_write_reg_d(rf_write_reg),
        .result_d(result),
        .rf_write_q(rf_write_out),
        .dm_write_q(dm_write_out),
        .memtoreg_q(memtoreg_out),
        .rf_data_out2_q(rf_data_out2_out),
        .rf_read_reg1_q(rf_read_reg1_out),
        .rf_read_reg2_q(rf_read_reg2_out),
        .rf_write_reg_q(rf_write_reg_out),
        .result_q(result_out),
	.branch_q(branch_out)
    );

endmodule

/**
module EX(
	input clk, rst,
	
	input rf_write, dm_write, memtoreg,
	input[1:0] lb, alu_src,
	input[2:0] branch,
	input[15:0] inst, pc_new, rf_data_out1, rf_data_out2, rf_read_reg1, rf_read_reg2, rf_write_reg

    output reg rf_write_out, dm_write>out, memtoreg_out,
    output [15:0]rf_data_out2_out, rf_read_reg1_out, rf_read_reg2_out,rf_write_reg_out, result_out; 
);

	wire [15:0] alu_input, alu_result, lb_input, result;
	wire [2:0] flags, flags_r;
	
	assign alu_input = alu_src[0] ? { {12{1'b0}}, inst[3:0] } :  
	(alu_src[1]) ? { {12{inst[3]}}, inst[3:0] } << 1 : rf_data_out2;

   	 // alu module here 
   	ALU lu (.Opcode(inst[15:12]), .rs(rf_data_out1), .rt(alu_input), .flag_out(flags), .rd(alu_result), .flags_in(flags_r));


    Flag_Register FG(.clk(clk), .rst(rst), .D(flags), .Q(flags_r));

    assign lb_input = lb[1] ? ((rf_data_out1 & 16'h00FF) | inst[7:0] << 8)  : ((rf_data_out1 & 16'hFF00) | inst[7:0] );
    assign result = lb[0] ? lb_input : (branch[1] & branch[0]) ? pc_new : alu_result;

    EXMEM_Register EXMEM( .clk(clk), .rst(rst), .wen(1'b1)


endmodule
**/
