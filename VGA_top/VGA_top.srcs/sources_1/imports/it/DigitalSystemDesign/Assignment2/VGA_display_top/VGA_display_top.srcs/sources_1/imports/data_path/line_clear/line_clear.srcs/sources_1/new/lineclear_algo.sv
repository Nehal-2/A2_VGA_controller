`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2024 10:05:23 AM
// Design Name: 
// Module Name: n_bit_counter
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

module lineclear_algo(
input wire clk,
input wire areset,
input wire clear, 
input wire line , 
input wire enY,
input wire enX,
input wire y_count_reset,
input wire x_count_reset,
output reg max_x,
output reg max_y,
output reg [7:0]x,
output reg [6:0]y,
output reg [2:0] color
    );
    
  //localparam ycor_max=160;
  //localparam xcor_max=120;
  //wire [6:0]y_line;
  //wire [7:0]x_line;
//  reg y_count_reset, x_count_reset;
 
 
  //reset for counters 
  always @(*)begin
    
    if(y<120) max_y = 0;
    else max_y = 1;
    
    if(x<160) max_x = 0;
    else max_x = 1;  
   
  end
  
//  assign y_count_reset = ~(max_y | ~areset);
//  assign x_count_reset = ~(max_x | ~areset| ~enX);
  
  //count X 
   nbit_counter#(.n (8))
        x_counter
(
       .clk(clk),
       .areset(x_count_reset),
        .en(enX),
        .up_down(1'b0), // down count if high
        .q(x) 
    );
  
  //count Y   
  nbit_counter#(.n (7))
        y_counter
(
       .clk(clk),
       .areset(y_count_reset),
        .en(enY),
        .up_down(1'b0), // down count if high
        .q(y) 
    );
  //
  assign color= (line)? y[2:0]:3'b000;
endmodule