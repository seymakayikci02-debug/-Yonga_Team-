module srcClockDiveder (
 
    input logic clk_in,
    input logic rst_n,
    input logic [15:0] div_factor,
    output logic clk_out

);
int count=0;
logic [15:0] div_factor_temp;
always_comb begin
    div_factor_temp= (div_factor<2) ? 2 : div_factor;       //avoiding 0 and 1 values for div_factor

end

always_ff @(posedge clk_in ,negedge rst_n) begin        //asynchronous reset
    if(rst_n==0) begin
        clk_out<=0;
        end
    else begin   
        count <= (count<(div_factor_temp-1)) ? (count+1) : 0;       // to prevent infinite loop inequality condition statement is utilized.
        clk_out<= (count<(div_factor_temp)/2) ? 1: 0;
        end

end

endmodule