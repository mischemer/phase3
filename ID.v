module ID(
    input clk,
    input rst,
    //pass in flags for ID branch resolution
    input [2:0] flags,
    input rf_write_in,
    //pass in rf_write, rf_data_in and rf_write_reg from instruction currently in wb stage
    input [15:0] pc_in, inst, rf_data_in_in, 
    input [3:0] rf_write_reg_in,
   
    output rf_write_out, dm_write_out, memtoreg_out,
    output [1:0] lb_out, alu_src_out,
    output [2:0] branch_out,
    output [15:0] inst_out, pc_new_out,
    output [15:0] rf_data_out1_out, rf_data_out2_out,
    output [3:0] rf_read_reg1_out, rf_read_reg2_out, rf_write_reg_out,
    output stall_out,
    output flush_out
	
);

    
    //Control signals to propagate through pipeline registers
    wire rf_write, dm_write, memtoreg;
    wire [1:0] lb, alu_src;
    wire [2:0] branch;
    wire [3:0] rf_read_reg1, rf_read_reg2, rf_write_reg;
    wire [15:0] rf_data_in, rf_data_out1, rf_data_out2;

    //also pass new pc for the pcs signal
    wire [15:0] pc_new;

    wire took;
    // Create all control signals
    Control CM(
        .opcode(inst[15:12]),
        .rf_write(rf_write),
        .dm_write(dm_write),
        .memtoreg(memtoreg),
        .lb(lb),
        .alu_src(alu_src),
        .branch(branch)
    );
    assign flag_setter = (inst_out[15:12] == 4'b0000) || 
		(inst_out[15:12] == 4'b0001) ||
		(inst_out[15:12] == 4'b0010) ||
		(inst_out[15:12] == 4'b0100) ||
		(inst_out[15:12] == 4'b0101) ||
		(inst_out[15:12] == 4'b0110);
//stall logic
    assign stall = (memtoreg_out && ( (rf_write_reg_out == rf_read_reg1) || 
		(rf_write_reg_out == rf_read_reg2) )) ||
		( ^branch[1:0] && flag_setter );

    assign flush = ( ^branch[1:0] && ~stall && took);

    // Assign register file control signals
    assign rf_read_reg1 = lb[0] ? inst[11:8] : inst[7:4];
    assign rf_read_reg2 = dm_write ? inst[11:8] : inst[3:0];
    assign rf_write_reg = inst[11:8];

    // Instantiate Register File module
    RegisterFile RF(
        .clk(clk),
        .rst(rst),
        .SrcReg1(rf_read_reg1),
        .SrcReg2(rf_read_reg2),
   	//write into register from instruction in WB stage
        .DstReg(rf_write_reg_in),
        .WriteReg(rf_write_in),
        .DstData(rf_data_in_in),
        .SrcData1(rf_data_out1),
        .SrcData2(rf_data_out2)
    );

    // Instantiate PC control module
    PC_control PCC(
        .C(inst[11:9]),
        .F(flags),
        .I(inst[8:0]),
        .PC_in(pc_in),
        .PC_out(pc_new),
        .Control_PC(branch),
        .PC_jump(rf_data_out1),
	.took(took)
    );

    // Instantiate IDEX register module
    IDEX_Register IDEX(
        .clk(clk),
        .rst(rst),
        .wen(1'b1),
	.stall_d(stall),
	.flush_d(flush),
        .inst_d(stall ? 16'h0000: inst),
        .inst_q(inst_out),
        .pc_new_d(stall ? 16'h0000: pc_new),
        .pc_new_q(pc_new_out),
        .rf_write_d(stall ? 1'h0: rf_write),
        .rf_write_q(rf_write_out),
        .dm_write_d(stall ? 1'h0: dm_write),
        .dm_write_q(dm_write_out),
        .memtoreg_d(stall ? 1'h0: memtoreg),
        .memtoreg_q(memtoreg_out),
        .lb_d(stall ? 2'h0: lb),
        .lb_q(lb_out),
        .alu_src_d(stall ? 2'h0: alu_src),
        .alu_src_q(alu_src_out),
        .branch_d(stall ? 2'h0: branch),
        .branch_q(branch_out),
        .rf_data_out1_d(stall ? 16'h0000: rf_data_out1),
        .rf_data_out1_q(rf_data_out1_out),
        .rf_data_out2_d(stall ? 16'h0000: rf_data_out2),
        .rf_data_out2_q(rf_data_out2_out),
        .rf_read_reg1_d(stall ? 4'h0: rf_read_reg1),
        .rf_read_reg1_q(rf_read_reg1_out),
        .rf_read_reg2_d(stall ? 4'h0: rf_read_reg2),
        .rf_read_reg2_q(rf_read_reg2_out),
        .rf_write_reg_d(stall ? 4'h0: rf_write_reg),
        .rf_write_reg_q(rf_write_reg_out),
	.stall_q(stall_out),
	.flush_q(flush_out)
    );

endmodule

/**
module ID(
	input clk, rst,

	input [2:0] flags,

	//input from IF stage
	input [15:0] pc_in, inst,
	
    	output rf_write_out, dm_write_out, memtoreg_out,
    	output [1:0] lb_out, alu_src_out,   
    	output [2:0] branch_out,
    	output [15:0] inst_out, pc_new_out,   
    	output [15:0] rf_data_out1_out, rf_data_out2_out, rf_read_reg1_out, rf_read_reg2_out, rf_write_reg_out
);

	//control signals
	reg rf_write, dm_write, memtoreg;
	reg [1:0] lb, alu_src;
	reg [2:0] branch;

	//register input output signals
   	wire [3:0] rf_read_reg1, rf_read_reg2, rf_write_reg;
    	wire [15:0] rf_data_in, rf_data_out1, rf_data_out2;

 	wire [15:0] pc_new;

	//create all control signals
	Control CM( .opcode(inst[15:12]), .rf_write(rf_write), .dm_write(dm_write), .memtoreg(memtoreg), .lb(lb), .alu_src(alu_src),. branch(branch) );
    	
	assign rf_read_reg1 = lb[0] ? inst[11:8] : inst[7:4] ;
    	assign rf_read_reg2 = dm_write ? inst[11:8] :inst[3:0];
    	assign rf_write_reg = inst[11:8];

	RegisterFile RF( .clk(clk), .rst(rst), .SrcReg1(rf_read_reg1), .SrcReg2(rf_read_reg2), .DstReg(rf_write_reg), 
	.WriteReg(rf_write), .DstData(rf_data_in), .SrcData1(rf_data_out1), .SrcData2(rf_data_out2));

	PC_control PCC(.C(inst[11:9]), .F(flags), .I(inst[8:0]), .PC_in(pc), .PC_out(pc_new), .Control_PC(branch), .PC_jump(rf_data_out1));

	IDEX_Register IDEX(.clk(clk), .rst(rst), .wen(1'b1), .inst_d(inst), .inst_q(inst_out), .pc_new_d(pc_new), .pc_new_q(pc_new_out),
	 .rf_write_d(rf_write), .rf_write_q(rf_write_out), .dm_write_d(dm_write), .dm_write_q(dm_write_out),
	.memtoreg_d(memtoreg), .memtoreg_q(memtoreg_out), .lb_d(lb), .lb_q(lb_out), .alu_src_d(alu_src), .alu_src_q(alu_src_out), .branch_d(branch), .branch_q(branch_out),
	.rf_data_out1_d(rf_data_out1), .rf_data_out1_q(rf_data_out1_out), .rf_data_out2_d(rf_data_out2), .rf_data_out2_q(rf_data_out2_out), .rf_read_reg1_d(rf_read_reg1),
	.rf_read_reg1_q(rf_read_reg1_out), .rf_read_reg2_d(rf_read_reg2), .rf_read_reg2_q(rf_read_reg2_out), .rf_write_reg_d(rf_write_reg), .rf_write_reg_q(rf_write_reg_out));

endmodule
**/
