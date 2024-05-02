module MEM(
    input clk, rst,
    input rf_write, dm_write, memtoreg,
    input mux,
    input [15:0] rf_data_out2,  result, memmem_data,
    input [3:0] rf_read_reg1, rf_read_reg2, rf_write_reg,
    input [2:0] branch,
    output [2:0] branch_out,
    
    output  rf_write_out, memtoreg_out,
    output [15:0] result_out, dm_data_out,
    output [3:0] rf_read_reg1_out, rf_read_reg2_out, rf_write_reg_out
);

    wire [15:0]rf_data_in, dm_data, data_in;
    assign data_in = mux ? memmem_data : rf_data_out2;
    
    Data_memory1c DM(.data_out(dm_data), .data_in(data_in), .addr(result), .enable(1'b1), .wr(dm_write), .clk(clk), .rst(rst));

    MEMWB_Register EXMEM(
        .clk(clk),
        .rst(rst),
        .wen(1'b1),
        .rf_write_d(rf_write),
        .memtoreg_d(memtoreg),
	.branch_d(branch),
	.branch_q(branch_out),
        //.rf_data_out2_d(rf_data_out2),
        .rf_read_reg1_d(rf_read_reg1),
        .rf_read_reg2_d(rf_read_reg2),
        .rf_write_reg_d(rf_write_reg),
        .result_d(result),
        .dm_data_d(dm_data),
        .rf_write_q(rf_write_out),
        .memtoreg_q(memtoreg_out),
       // .rf_data_out2_q(rf_data_out2_out),
        .rf_read_reg1_q(rf_read_reg1_out),
        .rf_read_reg2_q(rf_read_reg2_out),
        .rf_write_reg_q(rf_write_reg_out),
        .result_q(result_out),
        .dm_data_q(dm_data_out)
    );



endmodule
    
