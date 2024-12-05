`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2024 10:07:44 AM
// Design Name: 
// Module Name: tb_lineclear_algo
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


module tb_lineclear_algo;

  logic clk = 0, enY,enX, plot, areset, clear,line;
  logic [2:0] color;
  logic [6:0]y;
  logic [7:0]x;


 lineclear_algo DUT(
.clk(clk),
.areset(areset),
.clear(clear), 
.line(line) , 
.enY(enY),
.enX(enX),
.x(x),
.y(y),
.color(color)
    );
  always #5 clk = ~clk;


  initial begin
    areset = 1;
    enY= 0;
    enX = 0;
   plot = 0;
    clear = 0;
    line= 0;
    #1 areset= 0;
    #1 areset= 1;
    #1 areset= 0;

    repeat (1) begin
      @(negedge clk);
     end
  areset= 1;
     enX = 1;

    line = 1'b1;
    plot = 1'b0;
    repeat (15) begin
      @(negedge clk);
   

     enX = 1;

    line = 'b1;
    plot = 1'b0;  
     end 
repeat (2) begin
      @(negedge clk);
    

     enX = 0;
     enY = 1;
    line = 'b1;
    plot = 1'b0;
    end
    repeat (120) begin
      @(negedge clk);
    

     enX = 1;
    enY = 0;
    line = 'b1;
    plot = 1'b0;   
    end
    $finish;
  end

endmodule
