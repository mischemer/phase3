module WB(
    input clk, rst,
    input rf_write, memtoreg,
    input [15:0] dm_data, result,
    input [3:0] rf_read_reg1, rf_read_reg2, rf_write_reg,
    output [15:0] rf_data_in_out,
    output rf_write_out,
    output [3:0] rf_write_reg_out
);

assign rf_write_out = rf_write;
assign rf_write_reg_out = rf_write_reg;
assign rf_data_in_out = memtoreg ? dm_data : result;

endmodule
