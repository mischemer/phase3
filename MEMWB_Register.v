module MEMWB_Register(
    input clk, 
    input rst, 
    input wen,
    input rf_write_d, memtoreg_d,
    output rf_write_q, memtoreg_q,
    input [2:0] branch_d,
    output [2:0] branch_q,
    input [15:0]  dm_data_d, result_d,
    input [3:0] rf_read_reg1_d, rf_read_reg2_d, rf_write_reg_d,
    output [15:0]   dm_data_q, result_q,
    output [3:0] rf_read_reg1_q, rf_read_reg2_q, rf_write_reg_q
);

    dff DFF1 (.q(rf_write_q), .d(rf_write_d), .wen(wen), .clk(clk), .rst(rst));
    dff DFF2 (.q(dm_write_q), .d(dm_write_d), .wen(wen), .clk(clk), .rst(rst));
    dff DFF3 (.q(memtoreg_q), .d(memtoreg_d), .wen(wen), .clk(clk), .rst(rst));
    //dff DFF4 [15:0] (.q(rf_data_out2_q), .d(rf_data_out2_d), .wen(wen), .clk(clk), .rst(rst)); 
    dff DFF5 [3:0] (.q(rf_read_reg1_q), .d(rf_read_reg1_d), .wen(wen), .clk(clk), .rst(rst)); 
    dff DFF6 [3:0] (.q(rf_read_reg2_q), .d(rf_read_reg2_d), .wen(wen), .clk(clk), .rst(rst)); 
    dff DFF7 [3:0] (.q(rf_write_reg_q), .d(rf_write_reg_d), .wen(wen), .clk(clk), .rst(rst)); 
    dff DFF8 [15:0] (.q(dm_data_q), .d(dm_data_d), .wen(wen), .clk(clk), .rst(rst)); 
    dff DFF9 [15:0] (.q(result_q), .d(result_d), .wen(wen), .clk(clk), .rst(rst));
    dff DFF10 [2:0] (.q(branch_q), .d(branch_d), .wen(wen), .clk(clk), .rst(rst));  

endmodule

