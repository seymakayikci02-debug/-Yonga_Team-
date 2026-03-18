module tbUART ();
     
logic clk=0;
logic rst_n;
logic tx_start;
logic [7:0]data_in;
logic tx_lin;
logic busy;

srcUART dut(
    
    .clk(clk),
    .rst_n(rst_n),
    .tx_start(tx_start),
    .data_in(data_in),   //(Parallel Data)
    .tx_lin(tx_lin),        //(UART TX)
    .busy(busy)

);

always #10 clk=~clk;
initial begin
rst_n=0;
#30;
rst_n=1;
tx_start=1;


data_in=60;
@(posedge clk);
@(posedge clk);
tx_start=0;
@(negedge busy);
tx_start=1;
data_in=80;
@(posedge clk);
@(posedge clk);
tx_start=0;
end

endmodule



