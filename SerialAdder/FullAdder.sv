`timescale 1ns / 1ps


module FullAdder(
    input a,b,cin,
    output sum,cout
    );
    
    assign {cout,sum}=a+b+cin;
endmodule
