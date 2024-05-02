module RegisterFile( clk, rst, SrcReg1, SrcReg2, DstReg, WriteReg, DstData, SrcData1, SrcData2);
    input clk, rst, WriteReg;
    input [3:0] SrcReg1, SrcReg2, DstReg;
    input [15:0] DstData;
    inout [15:0] SrcData1, SrcData2;

    wire [15:0] ReadEnable1, ReadEnable2, WriteEnable;

    wire [15:0] bypass1, bypass2;

    ReadDecoder_4_16 RD1( .RegId(SrcReg1), .Wordline(ReadEnable1));
    ReadDecoder_4_16 RD2( .RegId(SrcReg2), .Wordline(ReadEnable2));

    WriteDecoder_4_16 WD( .RegId(DstReg), .WriteReg(WriteReg), .Wordline(WriteEnable));


    Register R[15:0] (.clk(clk), .rst(rst), .D(DstData), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .WriteReg(WriteEnable), .Bitline1(bypass1), .Bitline2(bypass2));

    assign SrcData1 = ( (ReadEnable1 == WriteEnable) & WriteReg ) ? DstData : bypass1;
    assign SrcData2 = ( (ReadEnable2 == WriteEnable) & WriteReg ) ? DstData : bypass2;




endmodule
