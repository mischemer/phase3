module cpu( clk, rst_n, hlt, pc);
    input clk, rst_n;
    output hlt;
    output [15:0] pc;

    
    //instruction memory signals
    wire [15:0] inst;
    wire [15:0] holder1;
    //data memory signals 
    wire [15:0] dm_data_out;
    wire dm_write; 
    //register file signals
    wire [3:0] rf_read_reg1, rf_read_reg2, rf_write_reg;
    wire [15:0] rf_data_in, rf_data_out1, rf_data_out2, lb_input;
    wire rf_write;
    //pc control
    wire [2:0] flags, flags_r;
    wire [15:0] pc_new, pc_out;
    //wire [2:0] Control_PC;
    //control signals
    wire memtoreg;
    wire [1:0] alu_src,lb;
    wire [2:0] branch;
    //alu
    wire [15:0] alu_result;
    wire [15:0] alu_input;
    wire dm_read;

    wire rst;

    assign rst = !rst_n;


    assign dm_read = (inst[15:12] == 4'b1000);

    //pc register is always write enabled. input is new pc, output to pc
    PC_Register PC(.clk(clk), .rst(rst), .D(pc_out), .Q(pc), .wen(1'b1));

    //Instruction memory module, outputs inst, input pc_addr, always enabled to read, never write
    Inst_memory1c IM(.data_out(inst), .data_in(holder1), .addr(pc), .enable(1'b1), .wr(1'b0), .clk(clk), .rst(rst));
       
    //Control module takes in opcode and returns signals for all operations
    Control CM( .opcode(inst[15:12]), .rf_write(rf_write), .dm_write(dm_write), .memtoreg(memtoreg), .lb(lb), .alu_src(alu_src),. branch(branch) );
    
    assign rf_read_reg1 = lb[0] ? inst[11:8] : inst[7:4] ;
    assign rf_read_reg2 = dm_write ? inst[11:8] :inst[3:0];
    assign rf_write_reg = inst[11:8];

   

    //Register file module
    RegisterFile RF( .clk(clk), .rst(rst), .SrcReg1(rf_read_reg1), .SrcReg2(rf_read_reg2), .DstReg(rf_write_reg), 
	.WriteReg(rf_write), .DstData(rf_data_in), .SrcData1(rf_data_out1), .SrcData2(rf_data_out2));

    assign alu_input = alu_src[0] ? { {12{1'b0}}, inst[3:0] } :  
	(alu_src[1]) ? { {12{inst[3]}}, inst[3:0] } << 1 : rf_data_out2;

    // alu module here 
    ALU lu (.Opcode(inst[15:12]), .rs(rf_data_out1), .rt(alu_input), .flag_out(flags), .rd(alu_result), .flags_in(flags_r));


    Flag_Register FG(.clk(clk), .rst(rst), .D(flags), .Q(flags_r));
    //Data memory module, returns data out, takes in data in and mem addr, always enabled to read, write signal
    Data_memory1c DM(.data_out(dm_data_out), .data_in(rf_data_out2), .addr(alu_result), .enable(1'b1), .wr(dm_write), .clk(clk), .rst(rst));

    assign lb_input = lb[1] ? ((rf_data_out1 & 16'h00FF) | inst[7:0] << 8)  : ((rf_data_out1 & 16'hFF00) | inst[7:0] );
    assign rf_data_in = memtoreg ? dm_data_out : lb[0] ? lb_input : (branch[1] & branch[0]) ? pc_out : alu_result;

    
    PC_control PCC(.C(inst[11:9]), .F(flags), .I(inst[8:0]), .PC_in(pc), .PC_out(pc_out), .Control_PC(branch), .PC_jump(rf_data_out1));

    assign hlt = branch[2];

endmodule
