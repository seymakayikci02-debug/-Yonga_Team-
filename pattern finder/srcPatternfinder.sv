`timescale 1ns / 1ps
module srcPatternFinder (
    input logic clk_i,
    input logic rstn_i,
    input logic in_i,
    output logic out_o
);

// typedef keyword for defining parametr in system verilog
//One hot codded system is used.
typedef enum logic [3:0]{
    S0=4'b0000,
    S1=4'b0001,
    S2=4'b0010,
    S3=4'b0100,
    S4=4'b1000
}state_t;

state_t state,next_state;

//reset statement and next state to state asignment should be always in synchronous logic as a rule.  
always_ff @(posedge clk_i ,negedge rstn_i) begin        //asynchronous reset
    if(rstn_i==0) begin
        out_o<=0;
        state<=S0;
       
        end
    else begin   
         state<=next_state;
         end
end
    
//FSM should be proceed in combinational logic as a rule. 
//Output assihnment is also in combinational logic but it could be  seperated with the FSM case state.   
//Moore FSM for detecting 1011 pattern

always_comb begin        //asynchronous reset      
        case(state) 
            S0: begin
                out_o=0;
                if(in_i) next_state=S1;
                else next_state=state;
                end
            S1: begin
                out_o=0;
                if(in_i) next_state=state;
                else next_state=S2;            
                end
            S2: begin
                out_o=0;
                if(in_i) next_state=S3;
                else next_state=S0;               
                end
            S3: begin
                out_o=0;
                if(in_i) next_state=S4;
                else next_state=S2; 
                end       
            S4: begin
                out_o=1;
                if(in_i) next_state=S1;
                else next_state=S2;
                
                end                          
            endcase
        end
endmodule