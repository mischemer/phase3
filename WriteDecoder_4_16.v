module WriteDecoder_4_16(RegId, WriteReg, Wordline);
    input [3:0] RegId;
    output [15:0] Wordline;
    input WriteReg;

         
    assign Wordline[0]  = (WriteReg) ? (~RegId[3] & ~RegId[2] & ~RegId[1] & ~RegId[0]) : 1'b0;
    assign Wordline[1]  = (WriteReg) ? (~RegId[3] & ~RegId[2] & ~RegId[1] &  RegId[0]) : 1'b0;
    assign Wordline[2]  = (WriteReg) ? (~RegId[3] & ~RegId[2] &  RegId[1] & ~RegId[0]) : 1'b0;
    assign Wordline[3]  = (WriteReg) ? (~RegId[3] & ~RegId[2] &  RegId[1] &  RegId[0]) : 1'b0;
    assign Wordline[4]  = (WriteReg) ? (~RegId[3] &  RegId[2] & ~RegId[1] & ~RegId[0]) : 1'b0;
    assign Wordline[5]  = (WriteReg) ? (~RegId[3] &  RegId[2] & ~RegId[1] &  RegId[0]) : 1'b0;
    assign Wordline[6]  = (WriteReg) ? (~RegId[3] &  RegId[2] &  RegId[1] & ~RegId[0]) : 1'b0;
    assign Wordline[7]  = (WriteReg) ? (~RegId[3] &  RegId[2] &  RegId[1] &  RegId[0]) : 1'b0;
    assign Wordline[8]  = (WriteReg) ? ( RegId[3] & ~RegId[2] & ~RegId[1] & ~RegId[0]) : 1'b0;
    assign Wordline[9]  = (WriteReg) ? ( RegId[3] & ~RegId[2] & ~RegId[1] &  RegId[0]) : 1'b0;
    assign Wordline[10] = (WriteReg) ? ( RegId[3] & ~RegId[2] &  RegId[1] & ~RegId[0]) : 1'b0;
    assign Wordline[11] = (WriteReg) ? ( RegId[3] & ~RegId[2] &  RegId[1] &  RegId[0]) : 1'b0;
    assign Wordline[12] = (WriteReg) ? ( RegId[3] &  RegId[2] & ~RegId[1] & ~RegId[0]) : 1'b0;
    assign Wordline[13] = (WriteReg) ? ( RegId[3] &  RegId[2] & ~RegId[1] &  RegId[0]) : 1'b0;
    assign Wordline[14] = (WriteReg) ? ( RegId[3] &  RegId[2] &  RegId[1] & ~RegId[0]) : 1'b0;
    assign Wordline[15] = (WriteReg) ? ( RegId[3] &  RegId[2] &  RegId[1] &  RegId[0]) : 1'b0;


endmodule
