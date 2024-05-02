module Shifter(Shift_Out, Shift_In, Shift_Val, Mode);
    input [15:0] Shift_In;
    input[3:0] Shift_Val;
    input Mode;
    output [15:0] Shift_Out;

    wire [15:0] a, b, c, d;

    assign a = Shift_Val[0] ? ( Mode ? { Shift_In[15], Shift_In[15:1] } : { Shift_In[14:0] , 1'b0 } ) : Shift_In;
    assign b = Shift_Val[1] ? ( Mode ? { {2{a[15]}} , a[15:2] } : { a[13:0] , {2{1'b0}} } ) : a;
    assign c = Shift_Val[2] ? ( Mode ? { {4{b[15]}} , b[15:4] } : { b[11:0] , {4{1'b0}} } ) : b;
    assign d = Shift_Val[3] ? ( Mode ? { {8{c[15]}} , c[15:8] } : { c[7:0] , {8{1'b0}} } ) : c;

    assign Shift_Out = d;




endmodule