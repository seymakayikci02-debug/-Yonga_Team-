module srcSerialAdder (
    
    input logic clk,
    input logic rst_n,
    input logic start,
    input logic [7:0] a,
    input logic [7:0] b,
    output logic [7:0] sum,
    output logic Cout,
    output logic done

);

integer counter=0;
logic [7:0] a_reg,b_reg;
logic sum_bit_reg;
logic cout_reg,cin_reg;
logic [7:0] sum_shift_reg;
logic [8:0] sum_final;
FullAdder f1(.a(a_reg[0]),.b(b_reg[0]),.cin(cin_reg),.sum(sum_bit_reg),.cout(cout_reg));
    
    
    always_ff @(posedge clk,negedge rst_n) begin
        if(rst_n==0) begin
            sum<=0;
            Cout<=0;
            done<=0;
            sum_shift_reg<=0;
            cin_reg<=0;
            sum_final<=0;
            a_reg<=0;
            b_reg<=0; 
        end
        
        
        else begin
        
            if(start==1) begin
            Cout<=0;
            a_reg<=a;
            b_reg<=b;       
            end
            
            else begin
                if(counter<8) begin
                    a_reg<=a_reg>>1;
                    b_reg<=b_reg>>1;
                    sum_shift_reg <= {sum_bit_reg, sum_shift_reg[7:1]};
                    cin_reg <= cout_reg;
                    counter<=counter+1;
                end
                
                if(counter==7) begin
                    sum<={sum_bit_reg, sum_shift_reg[7:1]};
                    sum_final<={cout_reg,sum_bit_reg, sum_shift_reg[7:1]};
                    Cout<=cout_reg;
                    done<=1;
                end
            
            end       
        end 
    end
endmodule







