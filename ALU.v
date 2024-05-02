module ALU (rd, rs, rt, Opcode, flag_out, flags_in);
    input [15:0] rs, rt;
    input [3:0] Opcode;
    input [2:0] flags_in; 
    output reg [15:0] rd;
    output reg [2:0] flag_out; 


    

    wire [15:0] Sum;
    wire Ovfl;
    
    wire [15:0] A_complemented;
    wire [15:0] B_complemented;
    wire [15:0] Sum_intermediate;
    wire [15:0] Cin_intermediate;
    wire Cout;

    // Complement A
    assign A_complemented = rs;
    
    // Sequentially complement B for subtraction, handling the carry
    assign B_complemented = Opcode[0] ? ~rt : rt; 

    // Extend the full adder chain
    CLA_16bit CLAADDSUB(.Sum(Sum_intermediate), .A(rs), .B(B_complemented), .Cin(Opcode[0]), .Cout(Cout), .Ovfl(Ovfl));




    // Connect sum and carry out wires
    assign Sum = (Ovfl & ~(A_complemented[15] ^ B_complemented[15])) ? (A_complemented[15] ? 16'h100 : 16'h7FFF ) : Sum_intermediate; 





    wire [11:0] sum1, sum2;  // Intermediate sums
    wire [15:0] final_sum;  // Final sum before sign extension
    wire [3:0] lower_sum1, upper_sum1, lower_sum2, upper_sum2;
    wire [3:0] lower_final_sum, upper_final_sum, final_upper;
    wire carry1, carry2, carry_out1, carry_out2, final_carry, final_carry2, final_carry3;

    // Extract and add lower and upper halves of rs and rt
    CLA_4bit add_upper_rs_rt(.A(rs[3:0]), .B(rt[3:0]), .Cin(1'b0), .Sum(lower_sum1), .Cout(carry_out1));
    CLA_4bit add_lower_rs_rt(.A(rs[7:4]), .B(rt[7:4]), .Cin(carry_out1), .Sum(lower_sum2), .Cout(carry1));
  

    CLA_4bit add_upper_rs_rt_2(.A(rs[11:8]), .B(rt[11:8]), .Cin(1'b0), .Sum(upper_sum1), .Cout(carry_out2));
    CLA_4bit add_lower_rs_rt_2(.A(rs[15:12]), .B(rt[15:12]), .Cin(carry_out2), .Sum(upper_sum2), .Cout(carry2));
    

    // Combine the intermediate sums
    assign sum1 = {{3{carry1}}, carry1, lower_sum2, lower_sum1};
    assign sum2 = {{3{carry2}}, carry2, upper_sum2, upper_sum1};

    // Add the intermediate sums to produce final sum
    CLA_4bit add_final_lower(.A(sum1[3:0]), .B(sum2[3:0]), .Cin(1'b0), .Sum(lower_final_sum), .Cout(final_carry));
    CLA_4bit add_final_upper2(.A(sum1[7:4]), .B(sum2[7:4]), .Cin(final_carry), .Sum(upper_final_sum), .Cout(final_carry2));
    CLA_4bit add_final_upper3(.A(sum1[11:8]), .B(sum2[11:8]), .Cin(final_carry2), .Sum(final_upper), .Cout(final_carry3)); 
    
    

    assign final_sum = {{4{final_carry3}}, final_upper, upper_final_sum, lower_final_sum};


    wire [15:0] ror_data1, ror_data2, ror_data3, ror_data4;

    assign ror_data1 = rt[0] ? {rs[0], rs[15:1]} : rs;
    assign ror_data2 = rt[1] ? {ror_data1[1:0], ror_data1[15:2]} : ror_data1;
    assign ror_data3 = rt[2] ? {ror_data2[3:0], ror_data2[15:4]} : ror_data2;
    assign ror_data4 = rt[3] ? {ror_data3[7:0], ror_data3[15:8]} : ror_data3;

  wire [15:0] Sum_PADDSB; 

  PSA_16bit PSA(.A(rs), .B(rt), .Sum(Sum_PADDSB), .Error(/*Don't Need*/));


    wire [15:0] Shift_Out;

    wire [15:0] a, b, c, d;

    assign a = rt[0] ? ( Opcode[0] ? { rs[15], rs[15:1] } : { rs[14:0] , 1'b0 } ) : rs;
    assign b = rt[1] ? ( Opcode[0] ? { {2{a[15]}} , a[15:2] } : { a[13:0] , {2{1'b0}} } ) : a;
    assign c = rt[2] ? ( Opcode[0] ? { {4{b[15]}} , b[15:4] } : { b[11:0] , {4{1'b0}} } ) : b;
    assign d = rt[3] ? ( Opcode[0] ? { {8{c[15]}} , c[15:8] } : { c[7:0] , {8{1'b0}} } ) : c;

    assign Shift_Out = d;

//Mem Calculations

	
    wire [15:0] temp_addr; 
    wire [15:0] Sum_intermediate_mem;
    wire [16:0] Cout_intermediate_mem;

    assign temp_addr = rs & 16'hFFFE; 



        // Extend the full adder chain
     // Extend the full adder chain
CLA_16bit CLAMEM(.Sum(Sum_intermediate_mem), .A(temp_addr), .B(rt), .Cin(1'b0), .Cout(/*Not Needed*/)); 





    


    always@(*)begin
        case(Opcode)
         
            4'b0000: begin //ADD
		    rd = Sum;

    		    flag_out[2] = Sum[15];
    		    flag_out[1] = Ovfl; 
    		    flag_out[0] = Sum == 0 ? 1'b1 : 1'b0; 
	    end 

            4'b0001: begin //SUB
		    rd = Sum;

    		    flag_out[2] = Sum[15];
    		    flag_out[1] = Ovfl; 
    		    flag_out[0] = Sum == 0 ? 1'b1 : 1'b0; 


	    end 
            4'b0010: begin //XOR
		    rd = rs ^ rt; 
		    flag_out = (rd == 0) ? {flags_in[2:1], 1'b1} : flags_in; 

	    end 
            4'b0011: begin //RED
		    rd = final_sum;
		    flag_out = flags_in;

	    end 
            4'b0100: begin //SLL
		    rd = Shift_Out; 
		    flag_out = (rd == 0) ? {flags_in[2:1], 1'b1} : flags_in; 

	    end 
            4'b0101: begin //SRA
		    rd = Shift_Out; 
		    flag_out = (rd == 0) ? {flags_in[2:1], 1'b1} : flags_in; 

	    end 
            4'b0110: begin //ROR
		    rd = ror_data4; 
		    flag_out = (rd == 0) ? {flags_in[2:1], 1'b1} : flags_in; 

	    end 
            4'b0111: begin //PADDSB
		    rd = Sum_PADDSB; 
			flag_out = flags_in;

	    end 
            4'b1000: begin //LW
		    rd = Sum_intermediate_mem;
			flag_out = flags_in;
		    
	    end 
            4'b1001: begin //SW
		    rd = Sum_intermediate_mem;
			flag_out = flags_in;

	    end 

            default: begin //Add something later
 			rd = rs;
		   flag_out = flags_in;
	    end
        endcase

    end



endmodule
