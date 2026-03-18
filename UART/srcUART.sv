module srcUART (
    
    input logic clk,
    input logic rst_n,
    input logic tx_start,
    input logic [7:0]data_in,   //(Parallel Data)
    output logic tx_lin,        //(UART TX)
    output logic busy

);
reg [7:0] tx_final;
/////////////////////// Clock Tick ////////////////////////////////// 
 parameter clk_frq=50_000_000;
 parameter baud_rate=9600;
 parameter [31:0] baud_tick=clk_frq/baud_rate;
 parameter m=$clog2(baud_tick);
 
 logic [m-1:0] counter;
 logic bit_done;
 always_ff @(posedge clk, negedge rst_n) begin
 
    if(rst_n==0) begin
         counter<=0;
          end          
    else begin
        counter<= (counter<baud_tick) ? (counter+1) : 0;  
       end
 end
 
 assign bit_done=(counter==baud_tick); 
 
 
 /////////////////////////// TX  ////////////////////////////////
 
 
 
 logic [9:0] temp_tx_line;
 logic [3:0] data_index;
 logic tx_done;
 typedef enum  logic [3:0]{
                           IDLE=4'b0000, 
                           START=4'b0001, 
                           DATA=4'b0010,
                           STOP=4'b0100
                           }state_t;
                            
 state_t state;
 
 
 always_ff @(posedge clk, negedge rst_n) begin
    if(rst_n==0) begin
      data_index<=0;
      busy<=0;
      state<=IDLE;
      tx_lin <= 1'b1;
      temp_tx_line=1;
      tx_final<=0;
      //tx_done<=0;
        end
    
    else begin
        case (state)
        
        IDLE: begin
            tx_lin<=1;
            data_index<=0;
            //tx_done<=0;
            
            if(tx_start==1) begin
                temp_tx_line<={1'b1,data_in,1'b0};
                busy<=1;
                state<=START;        
            end
            
            else begin
                state<=IDLE;
            end
            
        end
        
        START: begin
       
            tx_lin<=temp_tx_line[data_index];
            state<=DATA;
        end
            
        
        DATA: begin 
            if(data_index<9) begin          
                if(bit_done) begin
                    data_index<=data_index+1;
                    state<=START;
                end
                
                else begin
                    state<=DATA;
                end
            end
            else begin
                state<=STOP;
            end
        end
        
        STOP: begin
        if(bit_done) begin
                    //tx_done<=1;
                    state<=IDLE;
                    busy<=0;
                end
                
                else begin
                    state<=STOP;
            
                end
        
        end
        endcase
        end
    end   

   
always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        tx_final <= 8'b0;
    end
    else if(bit_done) begin
        tx_final <= {tx_lin, tx_final[7:1]};
    end
end
endmodule






