//
// File: vga_test_pattern.v
// Description: Generates VGA test pattern
//

`default_nettype none

//Module description
module vga_test_pattern( clk_25, sys_reset, vga_r, vga_g, vga_b, vga_disp_en, vga_pos_hor, vga_pos_ver, ram_addr, ram_data );

//IO definitions
input clk_25;
input sys_reset;

output [2:0] vga_r;
output [2:0] vga_g;
output [2:0] vga_b;

input vga_disp_en;
input [9:0] vga_pos_hor;
input [9:0] vga_pos_ver;

output [17:0] ram_addr;
input [15:0] ram_data;

//VGA parameters
parameter h_pixels = 640; //H-PIX Number of pixels horisontally
parameter v_pixels = 480; //V-PIX Number of pixels vertically

//IO registers
reg [2:0] vga_r_r;
reg [2:0] vga_g_r;
reg [2:0] vga_b_r;
reg [17:0] ram_addr_r;

//IO assignments
assign vga_r = vga_r_r;
assign vga_g = vga_g_r;
assign vga_b = vga_b_r;
assign ram_addr = ram_addr_r;

always @ (posedge clk_25) begin
  ram_addr_r = vga_pos_hor+(vga_pos_ver*h_pixels);
  if(vga_disp_en == 1 && sys_reset == 0) begin
    if(vga_pos_hor == 0 || vga_pos_ver == 0 || vga_pos_hor == h_pixels-1 || vga_pos_ver == v_pixels-1) begin //Border
      vga_r_r <= 7;
      vga_g_r <= 0;
      vga_b_r <= 0;
    end else begin //Everything else
      vga_r_r <= ram_data[2:0];
      vga_g_r <= ram_data[5:3];
      vga_b_r <= ram_data[8:6];
    end
  end else begin //When display is not enabled
    vga_r_r <= 0;
    vga_g_r <= 0;
    vga_b_r <= 0;
  end
end

endmodule
