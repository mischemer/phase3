module addsub_4bit (Sum, Ovfl, A, B, sub);
	input [3:0] A, B;
	input sub;
	output [3:0] Sum;
	output Ovfl;

    wire c1, c2, c3, c4;

	full_adder_1bit FA1( .A(A[0]), .B(B[0] ^ sub), .Cin(sub), .S(Sum[0]), .Cout(c1));
	full_adder_1bit FA2( .A(A[1]), .B(B[1] ^ sub), .Cin(c1), .S(Sum[1]), .Cout(c2));
	full_adder_1bit FA3( .A(A[2]), .B(B[2] ^ sub), .Cin(c2), .S(Sum[2]), .Cout(c3));
	full_adder_1bit FA4( .A(A[3]), .B(B[3] ^ sub), .Cin(c3), .S(Sum[3]), .Cout(c4));

    assign Ovfl = c4 ^ c3;


endmodule
