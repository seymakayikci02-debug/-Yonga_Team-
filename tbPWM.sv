module tbPWM ();

parameter RESOLUTION = 8;

logic clk=0;
logic rst_n;
logic [RESOLUTION-1:0] duty_cycle;
logic pwm_out;

srcPWM  dut(
    .clk(clk),
    .rst_n(rst_n),
    .duty_cycle(duty_cycle),
    .pwm_out(pwm_out)
);

always #10 clk=~clk;

initial begin

rst_n=0;

@(posedge clk);
rst_n=1;
@(posedge clk);
duty_cycle=0;
@(posedge clk);
duty_cycle=10;

#20_000;
duty_cycle=64;      //%25 duty cycle

#20_000;
duty_cycle=128;     //%50 duty cycle

#20_000;
duty_cycle=192;     //%75 duty cycle

#20_000;
duty_cycle=0;       //testing extreme cases: min point

#20_000;
duty_cycle=1;

#20_000;
duty_cycle=255;     //testing extreme cases: max point

#20_000;
#20_000;
#20_000;
#20_000;
$finish;

end

endmodule





