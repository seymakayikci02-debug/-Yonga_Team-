`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

interface intf;
    logic clk;
    logic rst_n;
    logic start;
    logic [7:0] a;
    logic [7:0] b;
    logic [7:0] sum;
    logic Cout;
    logic done;
endinterface 


class transaction;
    rand bit [7:0] a;
    rand bit [7:0] b;
    bit [7:0] sum;
    bit Cout;
endclass


class monitor;

    mailbox #(transaction) mbx;
    virtual intf inf;
    transaction trans;
    
    
    function new(mailbox #(transaction) mbx);
    this.mbx=mbx;
    endfunction

    task run;
    trans=new();
    @(posedge inf.done);        //previously it was captuaring too early right now it captures a and b inputs at correct time.
    @(posedge inf.clk);
    trans.a=inf.a;
    trans.b=inf.b;
    trans.Cout=inf.Cout;
    trans.sum=inf.sum;
    mbx.put(trans);
    endtask

endclass



class scoreboard;
    
    transaction trans_cont;
    mailbox #(transaction) mbx;
    virtual intf inf; 
    
    function new(mailbox #(transaction) mbx);
    this.mbx=mbx;
    endfunction


    task run;
    trans_cont=new();
    mbx.get(trans_cont);

    if({trans_cont.Cout,trans_cont.sum} == trans_cont.a+trans_cont.b) begin
        $display("Operation is successful!");
    end
    else $display("Failed!");
    endtask
    
endclass

module my_tb(

    );
    
    intf inf(); 
    transaction trans;
    monitor mon;
    scoreboard sco;
    mailbox #(transaction) mbx;
    srcSerialAdder dut2(inf.clk, inf.rst_n, inf.start, inf.a, inf.b, inf.sum, inf.Cout, inf.done);
    
    initial begin
    inf.clk=0;    
    end
    
    always #10 inf.clk=~inf.clk;
    
    
    initial begin
        mbx = new();
        mon = new(mbx);
        sco = new(mbx);

        mon.inf = inf;

        fork
            mon.run();
            sco.run();
        join
    end
    
    initial begin
        inf.rst_n = 0;
        inf.start = 0;
        inf.a     = 0;
        inf.b     = 0;
        repeat(3) @(posedge inf.clk); 
        inf.rst_n = 1;
        // @(posedge inf.clk);  //fail statement
        inf.start = 1;
        inf.a = $urandom;
        inf.b = $urandom;
        repeat(2)@(posedge inf.clk);
        inf.start = 0;
        @(posedge inf.clk);
        @(posedge inf.clk);
        inf.start = 0;
    end
    
    
endmodule





