module srcPWM #(parameter RESOLUTION=8 )(
    input logic clk,
    input logic rst_n,
    input logic [RESOLUTION-1:0] duty_cycle,
    output logic pwm_out
);
   
    logic [RESOLUTION-1:0] counter;

    
    always_ff @(posedge clk , negedge rst_n) begin
        if(!rst_n) begin
            counter<=0;  
        end
        
        ///////// pwm logic /////////////
        else begin
        counter <= (counter==( (1<<RESOLUTION) -1) ) ?  0 : (counter+1);        // '1<<RESOLUTION' is used to calculate 2^(RESOLUTION) -1     
                                                                                // at duty_cucle = 0 it is 0 already therefore it is not defined another condition  
        end
    
    end
    
    //assign pwm_out = (counter <= duty_cycle && duty_cycle );
    assign pwm_out = (duty_cycle == ((1<<RESOLUTION)-1)) ? 1'b1 : (counter < duty_cycle && duty_cycle ); 
    
    //duty_cycle == ((1<<RESOLUTION)-1)     :for max case it gives always HIGH
    //counter < duty_cycle                  :it gşives HIGH when it is smaller than duty cycle
    //&& duty_cycle                         :prevents 0 condition
endmodule



