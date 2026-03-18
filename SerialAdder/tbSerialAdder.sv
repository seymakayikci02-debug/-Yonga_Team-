module tbSerialAdder ();
        
logic clk=0;
logic rst_n;
logic start;
logic [7:0] a;
logic [7:0] b;
logic [7:0] sum;
logic Cout;
logic done;


srcSerialAdder dut(
    
    clk,
    rst_n,
    start,
    a,
    b,
    sum,
    Cout,
    done

);

always #10 clk=~clk;

initial begin

    rst_n=0;
    
    repeat(2) @(posedge clk);
    rst_n=1;
    start=1;
    @(posedge clk);
    start=1;

    a=$urandom;
    b=$urandom;
    @(posedge clk);
    start=0;
    repeat(11) @(posedge clk);
    $stop;
    end
    
endmodule



