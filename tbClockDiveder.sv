module tbClockDiveder ();

logic clk_in;
logic rst_n;
logic [15:0] div_factor;
logic clk_out;

srcClockDiveder cd(
 
    .clk_in(clk_in),
    .rst_n(rst_n),
    .div_factor(div_factor),
    .clk_out(clk_out)

);
    
always #10 clk_in=~clk_in;    
initial begin
    clk_in=0;
    rst_n=0;
    #20;
    rst_n=1;
    //First give a known value 
    div_factor=200;
    #100000;
    //give random values to test different scenarios
    div_factor=$urandom();
    #100000;
    div_factor=$urandom();
    #100000;
    div_factor=$urandom();
    #100000;
    div_factor=$urandom();
    #100000;
    div_factor=$urandom();
    #100000;
    //give 0 and 1 to test behaviour of combinational circuit.
    div_factor=0;
    #100000;
    div_factor=1;
    #100000;
    div_factor=200;
    
end

endmodule











