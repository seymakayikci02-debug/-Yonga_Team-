`timescale 1ns / 1ps
module tbPatternFinder ();
    
logic clk_i;
logic rstn_i;
logic in_i;
logic out_o;    

srcPatternFinder PF(
    .clk_i(clk_i),
    .rstn_i(rstn_i),
    .in_i(in_i),
    .out_o(out_o)
);



//clock period is 20ns and posedge is occuring in every 20 ns. 
//Therefore time delay is defined as 20 nanosecond to give values at every posedge clk
always #10 clk_i=~clk_i;   
 
//-1011011-
initial begin
    clk_i=0;
    rstn_i=0;
    in_i=0;
    #20;
    rstn_i=1;
    #20;
    //first random numbers are sent.
    in_i=$urandom();
    #20;
    in_i=$urandom();
    #20;
    //The numbers is given from test case //-1011011-
    in_i=1;
    #20;
    in_i=0;   
    #20;
    in_i=1;
    #20;
    in_i=1;
    #20;
    in_i=0;
    #20;
    in_i=1;
    #20;
    in_i=1;
    #20;
    in_i=$urandom();
    #20;
    in_i=$urandom();
    #20;
    $finish();
  
end

endmodule  