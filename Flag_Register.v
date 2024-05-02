
module Flag_Register(clk, rst, D, Q);
    input clk, rst;
    input [2:0] D;
    output [2:0] Q;

    dff N(.q(Q[2]), .d(D[2]), .wen(1'b1), .clk(clk), .rst(rst));
    dff V(.q(Q[1]), .d(D[1]), .wen(1'b1), .clk(clk), .rst(rst));
    dff Z(.q(Q[0]), .d(D[0]), .wen(1'b1), .clk(clk), .rst(rst));





endmodule