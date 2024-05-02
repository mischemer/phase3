module Register( clk, rst, D, WriteReg, ReadEnable1, ReadEnable2, Bitline1, Bitline2);
    input clk, rst, ReadEnable1, ReadEnable2, WriteReg;
    input [15:0] D;
    inout [15:0] Bitline1, Bitline2;

    BitCell B[15:0] (.clk(clk), .rst(rst), .D(D), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1), .Bitline2(Bitline2));


endmodule
