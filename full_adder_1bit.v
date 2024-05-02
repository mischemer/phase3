module full_adder_1bit (A, B, Cin, S, Cout);
    input A, B, Cin;
    output S, Cout;
    wire D;

    assign D = A ^ B;
    assign S = Cin ^ D;
    assign Cout = (Cin & D) | (A & B);
    

endmodule