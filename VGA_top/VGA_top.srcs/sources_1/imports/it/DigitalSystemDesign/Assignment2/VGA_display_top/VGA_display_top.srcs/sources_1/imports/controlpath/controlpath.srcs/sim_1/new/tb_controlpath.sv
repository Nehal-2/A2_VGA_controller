`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2024 11:49:37 AM
// Design Name: 
// Module Name: tb_controlpath
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_controlpath;

 logic clk = 0, enY,enX, max_x,max_y, areset, line_clear,px_count_reset,circle,d_comp,XB_YB_comp,enC,en_XB,load_XB,en_D,en_YB,x_count_reset,y_count_reset;
controlpath DUT(
  .clk(clk),
  .areset(areset),
   .max_x(max_x),
   .max_y(max_y),
   .line_clear(line_clear),
   .circle(circle),
   .d_comp(d_comp),
   .XB_YB_comp(XB_YB_comp),
   .enX(enX),
   .enY(enY),
   .x_count_reset(x_count_reset),
   .y_count_reset(y_count_reset),
   .px_count_reset(px_count_reset),
   .enC(enC),
   .en_XB(en_XB), 
   .load_XB(load_XB),
   .en_YB(en_YB),
   .en_D(en_D)
    );
always #5 clk = ~clk;


  initial begin
    areset = 1;
    line_clear=0;
    circle=0;    
    max_x= 0;
    max_y = 0;
    d_comp=0;
    XB_YB_comp=0;
    #1 areset= 0;
    #1 areset= 1;
    #1 areset= 0;
    #1 areset= 1;
    
  #10    @(negedge clk);
   line_clear=1;
    circle=0;    
    max_x= 0;
    max_y = 0;
    d_comp=0;
    XB_YB_comp=0;
    
#10   @(negedge clk);
   line_clear=1;
    circle=0;    
    max_x= 1;
    max_y = 0;
    d_comp=0;
    XB_YB_comp=0;
 #10   @(negedge clk);
   line_clear=1;
    circle=0;    
    max_x= 0;
    max_y = 0;
    d_comp=0;
    XB_YB_comp=0; 
 #10   @(negedge clk);
   line_clear=1;
    circle=0;    
    max_x= 0;
    max_y = 1;
    d_comp=0;
    XB_YB_comp=0; 
  #10   @(negedge clk);
   line_clear=1;
    circle=0;    
    max_x= 1;
    max_y = 1;
    d_comp=0;
    XB_YB_comp=0; 
    
 #10   @(negedge clk);
   line_clear=0;
    circle=1;    
    max_x= 0;
    max_y = 0;
    d_comp=0;
    XB_YB_comp=1; 
  #10   @(negedge clk);
   line_clear=0;
    circle=1;    
    max_x= 0;
    max_y = 0;
    d_comp=0;
    XB_YB_comp=1; 
     #10   @(negedge clk);
   line_clear=0;
    circle=1;    
    max_x= 0;
    max_y = 0;
    d_comp=1;
    XB_YB_comp=1; 
   #10   @(negedge clk);
   line_clear=0;
    circle=1;    
    max_x= 0;
    max_y = 0;
    d_comp=0;
    XB_YB_comp=1; 
    #30
    $finish;
  end

endmodule
