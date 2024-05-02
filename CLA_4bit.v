module CLA_4bit(
    input [3:0] A,  // 4-bit input A
    input [3:0] B,  // 4-bit input B
    input Cin,      // Input carry
    output [3:0] Sum,  // 4-bit sum of A and B
    output Cout,      // Output carry
    output Ovfl
);
    wire [3:0] G; // Generate
    wire [3:0] P; // Propagate
    wire [4:0] C; // Carry

    // Generate and Propagate
    assign G = A & B; // Generate: A and B generate a carry if both are 1
    assign P = A ^ B; // Propagate: A and B propagate a carry if either is 1

    // Carry Lookahead Logic
    assign C[0] = Cin; // Initial carry
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);

    // Sum and Cout
    assign Sum = P ^ C[3:0]; // The sum is the XOR of P and the carries shifted right
    assign Cout = C[4]; // The final carry out is the last carry generated
    assign Ovfl = C[4] ^ C[3]; 

endmodule
