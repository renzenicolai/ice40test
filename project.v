`default_nettype none
`include "vga_clock.v"
`include "vga_sync.v"
`include "vga_test_pattern.v"
`include "reset_generator.v"
`include "sram_ctrl.v"

//Top-level description
module top(
  clk_100,
  btn,
  led,
  vga_r,
  vga_g,
  vga_b,
  vga_hs,
  vga_vs,
  ps2_clk,
  ps2_data,
  sram_addr,
  sram_data,
  sram_cs,
  sram_oe,
  sram_we
);

//IO definitions
input clk_100;
input ps2_clk;
input ps2_data;
input [1:0] btn;
output [1:0] led;
output [2:0] vga_r;
output [2:0] vga_g;
output [2:0] vga_b;
output vga_hs;
output vga_vs;
output sram_cs;
output sram_oe;
output sram_we;
output [17:0] sram_addr;
inout [15:0] sram_data;

//Wires
wire clk_25;
wire sys_reset;
wire vga_disp_en;
wire [9:0] vga_pos_hor;
wire [9:0] vga_pos_ver;

wire [17:0] ramctl_read_address;
wire [17:0] ramctl_write_address;
wire ramctl_write;
wire [15:0] ramctl_data_out;
wire [15:0] ramctl_data_in;

//Assignments
assign led[0] = 0; //btn[0];
//assign led[1] = 0; //btn[1];

assign ramctl_write = btn[0];
assign ramctl_data_in = 0;
assign ramctl_write_address = 0;

/*assign sram_we = 1; //Force off sram
assign sram_oe = 1;
assign sram_cs = 1;
assign sram_addr = 0;*/


//Modules
vga_clock U_vga_clock (
  .clk_100 (clk_100),
  .clk_25 (clk_25)
);

reset_generator U_reset_generator (
  .clk_25 (clk_25),
  .sys_reset (sys_reset)
);

vga_sync U_vga_sync (
  .clk_25 (clk_25),
  .sys_reset (sys_reset),
  .vga_hs (vga_hs),
  .vga_vs (vga_vs),
  .vga_disp_en (vga_disp_en),
  .vga_pos_hor (vga_pos_hor),
  .vga_pos_ver (vga_pos_ver)
);

vga_test_pattern U_vga_test_pattern (
  .clk_25 (clk_25),
  .sys_reset (sys_reset),
  .vga_r (vga_r),
  .vga_g (vga_g),
  .vga_b (vga_b),
  .vga_disp_en (vga_disp_en),
  .vga_pos_hor (vga_pos_hor),
  .vga_pos_ver (vga_pos_ver),
  .ram_addr (ramctl_read_address),
  .ram_data (ramctl_data_out)
);

sram_ctrl U_sram_ctrl (
  .clk_100 (clk_100),
  .sys_reset (sys_reset),
  .sram_addr (sram_addr),
  .sram_data (sram_data),
  .sram_cs (sram_cs),
  .sram_oe (sram_oe),
  .sram_we (sram_we),
  .ramctl_read_address (ramctl_read_address),
  .ramctl_write_address (ramctl_write_address),
  .ramctl_write (ramctl_write),
  .ramctl_data_out (ramctl_data_out),
  .ramctl_data_in (ramctl_data_in),
  .debug (led[1])
);

endmodule
