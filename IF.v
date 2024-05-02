module IF(
    input clk,
    input rst,
    input if_wr,
    input [2:0] branch,
    input [15:0] pc_in,
    output [15:0] pc_out,
    output [15:0] inst_out
);

    wire [15:0] pc_new, pc_next, pc, inst, holder, Cout, inc;

    assign inc = 2'b10;
    full_adder_1bit FA1[15:0]( .A(pc), .B(inc), .Cin({Cout[14:0],1'b0}), .S(pc_next), .Cout(Cout));
    assign pc_new = (branch == 3'b000) ? pc_next : pc_in;

    // PC register input is new pc, outputs current pc
    PC_Register PC(
        .clk(clk),
        .rst(rst),
        .D(pc_new),
        .Q(pc),
        .wen(if_wr)
    );

    // Instruction memory
    Inst_memory1c IM(
        .data_out(inst),
        .data_in(holder),
        .addr(pc),
        .enable(1'b1),
        .wr(1'b0),
        .clk(clk),
        .rst(rst)
    );

    // IFID register
    IFID_Register IFID(
        .clk(clk),
        .rst(rst),
        .wen(if_wr),
        .inst_d(inst),
        .inst_q(inst_out),
        .pc_d(pc),
        .pc_q(pc_out)
    );

endmodule
/**
module IF(clk, rst, pc_in, inst_out, pc_out, if_wr);
	input clk, rst, if_wr;
	//potential new pc (if branch inst)
	input [15:0] pc_in;
	//output pc and instruction
	output [15:0] pc_out, inst_out;

	wire [15:0] pc, inst, holder;

	//pc registre input is new pc, outputs curr pc
	PC_Register PC(.clk(clk), .rst(rst), .D(pc_in), .Q(pc), .wen(if_wr));

	Inst_memory1c IM(.data_out(inst), .data_in(holder), .addr(pc), .enable(1'b1), .wr(1'b0), .clk(clk), .rst(rst));
       
	IFID_Register IFID(.clk(clk), .rst(rst), .wen(if_wr), .inst_d(inst), .inst_q(inst_out), .pc_d(pc), .pc_q(pc_out));

	//add 2 to current pc
	//assign inc = 16'h0002;
	//full_adder_1bit FA1[15:0]( .A(pc), .B(inc), .Cin({Cout[14:0],1'b0}), .S(pc_next), .Cout(Cout));

	//new pc becomes either pc+2 or pc_in
	//assign pc_new = pc_mux ? pc_in : pc_next;


endmodule

**/
