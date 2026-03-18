`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

interface intf2;
    logic clk;
    logic rst_n;
    logic start;
    logic [7:0] a;
    logic [7:0] b;
    logic [7:0] sum;
    logic Cout;
    logic done;
endinterface 


class transaction2;
    rand bit [7:0] a;
    rand bit [7:0] b;
    bit [7:0] sum;
    bit Cout;
    

endclass

////////////////////////////////////GENERATOR/////////////////////////////////////////////

class generator2;
    transaction2 trans;
    virtual intf2 inf;
    mailbox #(transaction2) mbx_gen2drv;
    function new(mailbox #(transaction2) mbx_gen2drv);
    this.mbx_gen2drv=mbx_gen2drv;
    endfunction

    task run();
        repeat(3) @(posedge inf.clk);
        trans=new();
        trans.randomize();
        mbx_gen2drv.put(trans);
    endtask
endclass

////////////////////////////////////DRIVER/////////////////////////////////////////////

class driver2;
    transaction2 trans_cont;
    virtual intf2 inf;
    mailbox #(transaction2) mbx_gen2drv;
    function new(mailbox #(transaction2) mbx_gen2drv);
    this.mbx_gen2drv=mbx_gen2drv;
    endfunction


    task run();
        trans_cont=new();
        mbx_gen2drv.get(trans_cont);
        
        
        repeat(3) @(posedge inf.clk); 
        inf.rst_n = 1;
        // @(posedge inf.clk);  //fail statement
        inf.start = 1;
        // @(posedge inf.clk);
        inf.a<=trans_cont.a;
        inf.b<=trans_cont.b;
        repeat(2)@(posedge inf.clk);
        inf.start = 0;
        @(posedge inf.clk);
        @(posedge inf.clk);
        inf.start = 0;
    endtask
    
endclass


////////////////////////////////////MONITOR/////////////////////////////////////////////

class monitor2;

    mailbox #(transaction2) mbx;
    virtual intf2 inf;
    transaction2 trans;
    
    
    function new(mailbox #(transaction2) mbx);
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

////////////////////////////////////SCOREBOARD/////////////////////////////////////////////


class scoreboard2;
    
    transaction2 trans_cont;
    mailbox #(transaction2) mbx;
    virtual intf2 inf; 
    
    function new(mailbox #(transaction2) mbx);
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



////////////////////////////////////MODULE/////////////////////////////////////////////


module my_tb2(

    );
    
    intf2 inf(); 
    transaction2 trans;
    monitor2 mon;
    scoreboard2 sco;
    
    generator2 gen;
    driver2 dri;
    
    mailbox #(transaction2) mbx;
    mailbox #(transaction2) mbx_gen2drv;
    
    srcSerialAdder dut2(inf.clk, inf.rst_n, inf.start, inf.a, inf.b, inf.sum, inf.Cout, inf.done);
    
    initial begin
    inf.clk=0;    
    end
    
    always #10 inf.clk=~inf.clk;
    
    
    initial begin
        mbx = new();
        mon = new(mbx);
        sco = new(mbx);

        mbx_gen2drv = new();
        gen = new(mbx_gen2drv);
        dri = new(mbx_gen2drv);

        mon.inf = inf;          //DO NOT FORGET this part*********
        gen.inf = inf;
        dri.inf = inf;
        sco.inf = inf;
        
        fork
            gen.run();
            dri.run();
            mon.run();
            sco.run();
        join
    end
    
    initial begin
        inf.rst_n = 0;
        inf.start = 0;
        inf.a     = 0;
        inf.b     = 0;
        // repeat(3) @(posedge inf.clk); 
        // inf.rst_n = 1;
        // // @(posedge inf.clk);  //fail statement
        // inf.start = 1;
        // // inf.a = $urandom;
        // // inf.b = $urandom;
        // repeat(2)@(posedge inf.clk);
        // inf.start = 0;
        // @(posedge inf.clk);
        // @(posedge inf.clk);
        // inf.start = 0;
    end
    
    
endmodule
