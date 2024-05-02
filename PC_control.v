module PC_control( C, F, I, PC_in, PC_out, Control_PC, PC_jump, took);
    input [2:0] C; //condition
    input [2:0] F; //flags
    input [8:0] I; //immediate
    input [15:0] PC_in; //cur pc
    output [15:0] PC_out; //output pc
    input [2:0] Control_PC; //control bits for pc instructions
    input [15:0] PC_jump; //pc address for BR instruction
    output took;
    wire Error1, Error2;
    reg flag;
    wire [15:0] PC_next, PC_branch, inc, branch_inc;
    reg [15:0] PC_new;
    

    //plus 2 for pc increment
    assign inc = 2'b10;
    //plus sign extend immediate times 2
    assign branch_inc = { {7{I[8]}}, I} << 1;
    //final pc output
    assign PC_out = PC_new;

    wire [15:0] Cout;
    wire [15:0] Cout2;
    //add 2 to pc
    //PSA_16bit PSA1( .A(PC_in), .B(inc), .Sum(PC_next), .Error(Error));
    full_adder_1bit FA1[15:0]( .A(PC_in), .B(inc), .Cin({Cout[14:0],1'b0}), .S(PC_next), .Cout(Cout));

    //add immediate to pc+2
    //PSA_16bit PSA2( .A(PC_next), .B(branch_inc), .Sum(PC_branch), .Error(Error));
    full_adder_1bit FA2[15:0]( .A(PC_next), .B(branch_inc), .Cin({Cout2[14:0],1'b0}), .S(PC_branch), .Cout(Cout2));

    //flag determines if condition has been met
    always @(*) begin
        case(C)
            3'b000: flag = (~F[0]) ? 1'b1 : 1'b0;
            3'b001: flag = (F[0]) ? 1'b1 : 1'b0;
            3'b010: flag = (~F[0] & ~F[2]) ? 1'b1 : 1'b0;
            3'b011: flag = (F[2]) ? 1'b1 : 1'b0;
            3'b100: flag = (F[0] | (~F[0] & ~F[2])) ? 1'b1 : 1'b0;
            3'b101: flag = (F[2] | F[0]) ? 1'b1 : 1'b0;
            3'b110: flag = (F[1]) ? 1'b1 : 1'b0;
            3'b111: flag = 1'b1;
            default: flag = 1'b0;
        endcase
    end

    always @(*) begin
        case(Control_PC)
	    3'b000: PC_new = PC_next;
	    //B instruction: if condition met, pc is PC_branch, PC+2 otherwise
            3'b001: PC_new = flag ? PC_branch : PC_next;
	    //BR instruction: if condition is met, pc is 
	    3'b010: PC_new = flag ? PC_jump : PC_next;
	    3'b011: PC_new = PC_next;
	    3'b100: PC_new = PC_in;
            default: PC_new = PC_next;
        endcase
    end

    assign took = (Control_PC == 3'b001 || Control_PC == 3'b010) & flag;

endmodule
