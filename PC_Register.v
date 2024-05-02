module PC_Register(clk, rst, D, Q, wen);
    input clk, rst, wen;
    input [15:0] D;
    output [15:0] Q;

    wire [15:0] D2;
    dff DFF1[15:0](.q(Q), .d(D), .wen(wen), .clk(clk), .rst(rst));
    //dff DFF2[15:0](.q(Q), .d(D2), .wen(wen), .clk(clk), .rst(rst));


endmodule
