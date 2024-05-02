module BitCell(clk, rst, D, WriteEnable, ReadEnable1, ReadEnable2, Bitline1, Bitline2);
    input clk, rst, D, WriteEnable, ReadEnable1, ReadEnable2;
    inout Bitline1, Bitline2;

    wire Read;


    dff DFF(.q(Read), .d(D), .wen(WriteEnable), .clk(clk), .rst(rst));

    //assign Bitline1 = ReadEnable1 ? (WriteEnable ? D : Read) : 1'bz;
    //assign Bitline2 = ReadEnable2 ? (WriteEnable ? D : Read ) : 1'bZ;
    assign Bitline1 = ReadEnable1 ? Read : 1'bz;
    assign Bitline2 = ReadEnable2 ? Read : 1'bZ;




endmodule
