//
// File: reset_generator.v
// Description: Generates a reset pulse signal
//

`default_nettype none

//Module description
module reset_generator( clk_25, sys_reset );

//I/O definitions
input clk_25;
output sys_reset;

//Registers
reg reset = 1;
reg [7:0] timer_t = 8'b0;

//Assignments
assign sys_reset = reset;

//Always
always @ (posedge clk_25) begin
  if(timer_t > 250) begin
    reset <= 0;
  end else begin
    reset <= 1;
    timer_t <= timer_t + 1;
  end
end

endmodule
 
