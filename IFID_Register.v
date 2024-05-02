module IFID_Register(clk, rst, wen, inst_d, inst_q, pc_d, pc_q);
    input clk, rst, wen;
    input [15:0] inst_d, pc_d;
    output [15:0] inst_q, pc_q;

    dff DFF1[15:0](.q(inst_q), .d(inst_d), .wen(wen), .clk(clk), .rst(rst));
    dff DFF2[15:0](.q(pc_q), .d(pc_d), .wen(wen), .clk(clk), .rst(rst));
    


endmodule