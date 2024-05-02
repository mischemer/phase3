module CLA_16bit(
    input [15:0] A,  // 16-bit input A
    input [15:0] B,  // 16-bit input B
    input Cin,       // Input carry
    output [15:0] Sum,  // 16-bit sum of A and B
    output Cout,       // Output carry
    output Ovfl
);

// Intermediate carries between CLA blocks
wire C1, C2, C3;


// Instantiate the first 4-bit CLA block
CLA_4bit CLA1(
    .A(A[3:0]),
    .B(B[3:0]),
    .Cin(Cin),
    .Sum(Sum[3:0]),
    .Cout(C1),
    .Ovfl()
);

// Instantiate the second 4-bit CLA block
CLA_4bit CLA2(
    .A(A[7:4]),
    .B(B[7:4]),
    .Cin(C1),
    .Sum(Sum[7:4]),
    .Cout(C2),
    .Ovfl() 
);

// Instantiate the third 4-bit CLA block
CLA_4bit CLA3(
    .A(A[11:8]),
    .B(B[11:8]),
    .Cin(C2),
    .Sum(Sum[11:8]),
    .Cout(C3),
    .Ovfl() 
);

// Instantiate the fourth 4-bit CLA block
CLA_4bit CLA4(
    .A(A[15:12]),
    .B(B[15:12]),
    .Cin(C3),
    .Sum(Sum[15:12]),
    .Cout(Cout),
    .Ovfl(Ovfl)
);

endmodule

