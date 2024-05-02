
module cpu2( 
    input clk, rst_n,
    output hlt,
    output [15:0] pc
);

    wire rst;

    assign rst = !rst_n;

    // IF stage signals
    wire if_wr;
    wire [15:0] inst_if, pc_if;

    // ID stage signals
    wire rf_write_id, dm_write_id, memtoreg_id;
    wire [1:0] lb_id, alu_src_id;
    wire [2:0] branch_id;
    wire [15:0] inst_id, pc_new_id;
    wire [15:0] rf_data_out1_id, rf_data_out2_id;
    wire [3:0] rf_read_reg1_id, rf_read_reg2_id, rf_write_reg_id;

    // EX stage signals
    wire rf_write_ex, dm_write_ex, memtoreg_ex;
    wire [15:0] rf_data_out2_ex, result_ex;
    wire [3:0] rf_read_reg1_ex, rf_read_reg2_ex, rf_write_reg_ex;
    wire [2:0] flags_ex, branch_ex;
    
    // MEM stage signals
    wire rf_write_mem, memtoreg_mem;
    wire [15:0] result_mem, dm_data_mem;
    wire [3:0] rf_read_reg1_mem, rf_read_reg2_mem, rf_write_reg_mem;
    wire [2:0] branch_mem;
 
    // WB stage signals
    wire rf_write_wb;
    wire [15:0] rf_data_in_wb;
    wire [3:0]  rf_write_reg_wb;


    //test signals
    wire [15:0] test_rf_data;
    //assign if_wr = 1'b1;
    assign hlt = branch_mem[2];
    assign pc = pc_if;
    //forwarding signals
   wire [1:0] mux1, mux2;
   wire mux3;
   wire [15:0] exex_data1, memex_data1, exex_data2, memex_data2, memmem_data;

	wire flush;
   //assign flush = 1'b0;
    IF IF_stage(
        .clk(clk),
        .rst(rst),
  	.branch(branch_id),
        .pc_in(pc_new_id),
        .inst_out(inst_if),
        .pc_out(pc_if),
        .if_wr(~if_wr)
    );

    ID ID_state(
        .clk(clk),
        .rst(rst),
	//flags from ex stage
        .flags(flush ? 3'b000 :flags_ex),
	//pass in pc and inst from if
        .pc_in(flush ? 16'h0000 :pc_if),
        .inst(flush ? 16'h0000 :inst_if),
	//register file writing signals from wb
	.rf_write_in(flush ? 1'b0 : rf_write_wb),
	.rf_data_in_in( flush ? 16'h0000 :rf_data_in_wb),
	.rf_write_reg_in(flush ? 4'h0 : rf_write_reg_wb),
        .rf_write_out(rf_write_id),
        .dm_write_out(dm_write_id),
        .memtoreg_out(memtoreg_id),
        .lb_out(lb_id),
        .alu_src_out(alu_src_id),
        .branch_out(branch_id),
        .inst_out(inst_id),
        .pc_new_out(pc_new_id),
        .rf_data_out1_out(rf_data_out1_id),
        .rf_data_out2_out(rf_data_out2_id),
        .rf_read_reg1_out(rf_read_reg1_id),
        .rf_read_reg2_out(rf_read_reg2_id),
        .rf_write_reg_out(rf_write_reg_id),
	.stall_out(if_wr),
	.flush_out(flush)
    );

    EX EX_stage(
        .clk(clk),
        .rst(rst),
        .rf_write(rf_write_id),
        .dm_write(dm_write_id),
        .memtoreg(memtoreg_id),
        .lb(lb_id),
        .alu_src(alu_src_id),
        .branch(branch_id),
        .inst(inst_id),
        .pc_new(pc_new_id),
        .rf_data_out1(rf_data_out1_id),
        .rf_data_out2(rf_data_out2_id),
        .rf_read_reg1(rf_read_reg1_id),
        .rf_read_reg2(rf_read_reg2_id),
        .rf_write_reg(rf_write_reg_id),
	.exex_data1(exex_data1),
	.exex_data2(exex_data2),
	.memex_data1(memex_data1),
	.memex_data2(memex_data2),
 	.mux1(mux1),
	.mux2(mux2),
	.branch_out(branch_ex),
        .rf_write_out(rf_write_ex),
        .dm_write_out(dm_write_ex),
        .memtoreg_out(memtoreg_ex),
        .rf_data_out2_out(rf_data_out2_ex),
        .rf_read_reg1_out(rf_read_reg1_ex),
        .rf_read_reg2_out(rf_read_reg2_ex),
        .rf_write_reg_out(rf_write_reg_ex),
        .result_out(result_ex),
        .flags_out(flags_ex)
    );
  
    MEM MEM_stage(
        .clk(clk),
        .rst(rst),
	.mux(mux3),
	.memmem_data(memmem_data),
	.branch(branch_ex),
        .rf_write(rf_write_ex),      
        .memtoreg(memtoreg_ex),
        .dm_write(dm_write_ex),
        .rf_data_out2(rf_data_out2_ex),
        .rf_read_reg1(rf_read_reg1_ex),
        .rf_read_reg2(rf_read_reg2_ex),
        .rf_write_reg(rf_write_reg_ex),
	.result(result_ex),
        .rf_write_out(rf_write_mem),
        .memtoreg_out(memtoreg_mem),
        .rf_read_reg1_out(rf_read_reg1_mem),
        .rf_read_reg2_out(rf_read_reg2_mem),
        .rf_write_reg_out(rf_write_reg_mem),
        .result_out(result_mem),
	.dm_data_out(dm_data_mem),
	.branch_out(branch_mem)
    );

     WB WB_stage(
	.clk(clk),
        .rst(rst),
        .rf_write(rf_write_mem),      
        .memtoreg(memtoreg_mem),
        .rf_read_reg1(rf_read_reg1_mem),
        .rf_read_reg2(rf_read_reg2_mem),
        .rf_write_reg(rf_write_reg_mem),
	.result(result_mem),
	.dm_data(dm_data_mem),
	.rf_write_out(rf_write_wb),
        .rf_write_reg_out(rf_write_reg_wb),
        .rf_data_in_out(rf_data_in_wb)
);

    //ex to ex and mem to ex forwarding
    assign mux1 = (rf_write_id && (rf_read_reg1_id == rf_write_reg_ex)) ? 2'b10 : 
	(rf_write_id && (rf_read_reg1_id == rf_write_reg_mem))? 2'b01 : 2'b00;

    assign mux2 = (rf_write_id && (rf_read_reg2_id == rf_write_reg_ex)) ? 2'b10 : 
	(rf_write_id && (rf_read_reg2_id == rf_write_reg_mem))? 2'b01 : 2'b00;

    assign exex_data1 = result_ex;
    assign exex_data2 = result_ex;
    assign memex_data1 = rf_data_in_wb;
    assign memex_data2 = rf_data_in_wb;

    assign mux3 = (rf_write_mem && (rf_write_reg_mem == rf_read_reg2_ex));
    assign memmem_data = rf_data_in_wb;
    
    //hazard
 
    assign test_rf_data = memtoreg_mem ? dm_data_mem : result_mem;
   
endmodule

