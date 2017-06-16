//
// File: vga_sync.v
// Description: Generates VGA timing signals
//

`default_nettype none

//Module description
module vga_sync( clk_25, sys_reset, vga_hs, vga_vs, vga_disp_en, vga_pos_hor, vga_pos_ver );

//IO definitions
input clk_25;
input sys_reset;

output vga_hs; //h-sync
output vga_vs; //v-sync

output vga_disp_en; //Color output enabled / sync in visible area
output [9:0] vga_pos_hor;
output [9:0] vga_pos_ver;

//VGA parameters
parameter h_pulse = 96; //H-SYNC pulse width 96 * 40 ns (25 Mhz) = 3.84 uS
parameter h_bp = 48; //H-BP back porch pulse width
parameter h_pixels = 640; //H-PIX Number of pixels horisontally
parameter h_fp = 16; //H-FP front porch pulse width
parameter h_pol = 1'b0; //H-SYNC polarity
parameter h_frame = 800; //800 = 96 (H-SYNC) + 48 (H-BP) + 640 (H-PIX) + 16 (H-FP)
parameter v_pulse = 2; //V-SYNC pulse width
parameter v_bp = 33; //V-BP back porch pulse width
parameter v_pixels = 480; //V-PIX Number of pixels vertically
parameter v_fp = 10; //V-FP front porch pulse width
parameter v_pol = 1'b1; //V-SYNC polarity
parameter v_frame = 525; // 525 = 2 (V-SYNC) + 33 (V-BP) + 480 (V-PIX) + 10 (V-FP)

//IO registers
reg vga_hs_r;
reg vga_vs_r;
reg disp_en;

//IO assignments
assign vga_hs = vga_hs_r;
assign vga_vs = vga_vs_r;
assign vga_disp_en = disp_en;
assign vga_pos_hor = c_col;
assign vga_pos_ver = c_row;

//Internal registers
reg [9:0] c_hor;
reg [9:0] c_ver;
reg [9:0] c_row;
reg [9:0] c_col;

always @ (posedge clk_25) begin	

  if(sys_reset == 1) begin //If in reset state initialize registers
    disp_en <= 0;
    c_hor <= 0;
    c_ver <= 0;
    vga_hs_r <= 1;
    vga_vs_r <= 0;
  end else begin //If started update beam position
    if(c_hor < h_frame - 1) begin
      c_hor <= c_hor + 1;
	end else begin
      c_hor <= 0;
      if(c_ver < v_frame - 1) begin
        c_ver <= c_ver + 1;
      end else begin
        c_ver <= 0;
      end
    end
  end
  
  if(c_hor < h_pixels + h_fp + 1 || c_hor > h_pixels + h_fp + h_pulse) begin // H-SYNC generator
    vga_hs_r <= ~h_pol;
  end else begin
    vga_hs_r <= h_pol;
  end
  
  if(c_ver < v_pixels + v_fp || c_ver > v_pixels + v_fp + v_pulse) begin //V-SYNC generator
    vga_vs_r <= ~v_pol;
  end else begin
    vga_vs_r <= v_pol;
  end
  
  if(c_hor < h_pixels && c_ver < v_pixels) begin
    disp_en <= 1;
  end else begin
    disp_en <= 0;
  end
  
  if(c_hor < h_pixels) begin
    c_col <= c_hor;
  end
  
  if(c_ver < v_pixels) begin
    c_row <= c_ver;
  end
	
end

endmodule
