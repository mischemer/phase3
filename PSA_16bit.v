
module PSA_16bit(Sum, Error, A, B, );
    input [15:0] A, B;
    output [15:0] Sum;
    output Error;
    wire O1, O2, O3, O4;
    wire [15:0] checkSum;

    addsub_4bit A1( .A(A[15:12]), .B(B[15:12]), .Sum(checkSum[15:12]), .Ovfl(O1), .sub(1'b0));
    addsub_4bit A2( .A(A[11:8]), .B(B[11:8]), .Sum(checkSum[11:8]), .Ovfl(O2), .sub(1'b0));
    addsub_4bit A3( .A(A[7:4]), .B(B[7:4]), .Sum(checkSum[7:4]), .Ovfl(O3), .sub(1'b0));
    addsub_4bit A4( .A(A[3:0]), .B(B[3:0]), .Sum(checkSum[3:0]), .Ovfl(O4), .sub(1'b0));

    
    assign Sum[3:0] = (O4 & ~(A[3] ^ B[3])) ? (A[3] ? 4'h1 : 4'h7 ) : checkSum[3:0]; 
    assign Sum[7:4] = (O3 & ~(A[7] ^ B[7])) ? (A[7] ? 4'h1 : 4'h7 ) : checkSum[7:4]; 
    assign Sum[11:8] = (O4 & ~(A[11] ^ B[11])) ? (A[11] ? 4'h1 : 4'h7 ) : checkSum[11:8]; 
    assign Sum[15:12] = (O4 & ~(A[15] ^ B[15])) ? (A[15] ? 4'h1 : 4'h7 ) : checkSum[15:12]; 
 
    assign Error = O1 | O2 | O3 | O4;

endmodule
