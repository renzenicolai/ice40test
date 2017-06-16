//
// File: vga_clock.v
// Description: Divides the clock signal four times
//

`default_nettype none

//Module description
module vga_clock( clk_100, clk_25 );

//I/O definitions
input clk_100;
output clk_25;

//Registers
reg	[1:0] clk_div;

//Assignments
assign clk_25 = clk_div[1];

//Clock divider
always @ (posedge clk_100) begin
  clk_div <= clk_div + 2'b1;
end

endmodule
