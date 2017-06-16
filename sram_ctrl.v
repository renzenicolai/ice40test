//
// File: sram_ctrl.v
// Description: SRAM controller
//

`default_nettype none

//Module description
module sram_ctrl(
  clk_100,
  sys_reset,
  sram_addr,
  sram_data,
  sram_cs,
  sram_oe,
  sram_we,

  ramctl_read_address,
  ramctl_write_address,
  ramctl_write,
  ramctl_data_out,
  ramctl_data_in,

  debug
);

//I/O definitions
input clk_100;
input sys_reset;

output sram_cs;
output sram_oe;
output sram_we;
output [17:0] sram_addr;
inout [15:0] sram_data;
input [17:0] ramctl_read_address;
input [17:0] ramctl_write_address;
input ramctl_write;

input [15:0] ramctl_data_in;
output [15:0] ramctl_data_out;

output debug;

//Registers
reg sram_cs_r;
reg sram_oe_r;
reg sram_we_r;
reg [17:0] sram_addr_r;
reg [15:0] data_buffer_r;
reg [15:0] ramctl_data_out_r;

//Assignments
assign sram_cs = sram_cs_r;
assign sram_oe = sram_oe_r;
assign sram_we = sram_we_r;
assign sram_addr = sram_addr_r;
assign sram_data = (sram_we_r==0) ? data_buffer_r : 16'bz;
assign debug = (sram_we_r==0) ? 'b1 : 'b0;
assign ramctl_data_out = ramctl_data_out_r;

//Always
always @ (posedge clk_100) begin
  if(sys_reset == 1) begin
    data_buffer_r = 0;
    sram_addr_r <= 0;
    sram_oe_r <= 1;
    sram_cs_r <= 1;
    sram_we_r <= 1;
  end else begin
    if (ramctl_write == 1) begin
      data_buffer_r <= ramctl_data_in;
      sram_addr_r <= ramctl_write_address;
      sram_oe_r <= 1;
      sram_cs_r <= 0;
      sram_we_r <= 0;
    end else begin //Read from SRAM
      data_buffer_r = 0;
      sram_addr_r <= ramctl_read_address;
      sram_oe_r <= 0; 
      sram_cs_r <= 0;
      sram_we_r <= 1;
    end
  end
end

always @ (negedge clk_100) begin
  if (ramctl_write == 0) begin
    ramctl_data_out_r = sram_data;
  end
end

endmodule
 
