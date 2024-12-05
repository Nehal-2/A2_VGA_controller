`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2024 06:03:32 PM
// Design Name: 
// Module Name: tb_VGA_TOP
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


module tb_VGA_TOP;
    logic clk;    // using the same name as pin names
    logic reset_n;  
    logic circle, clear, line;
    logic [3:0] VGA_R, VGA_G, VGA_B; 
    logic VGA_HS, VGA_VS;   
    logic [15:0] SW;
    
    VGA_TOP dut(
    .CLK100MHZ(clk),    // using the same name as pin names
    .CPU_RESETN(reset_n),  
    .BTNC(circle), 
    .BTNR(clear), 
    .BTNL(line),
    .VGA_R(VGA_R), 
    .VGA_G(VGA_G), 
    .VGA_B(VGA_B), 
    .VGA_HS(VGA_HS), 
    .VGA_VS(VGA_VS),   
    .SW(SW)
    );

     initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10 time units clock period
    end
    
//    logic [6:0] radius;
//    logic [2:0] in_color;
    
//    assign radius = SW[9:3];
//    assign in_color = SW[2:0];
    
    initial begin
       clear = 0; line = 0; circle = 0;
       SW[15:10] = 6'b0;
       SW[9:3] = 7'b0001000; SW[2:0] = 3'b100;
       reset_n = 1; #10; reset_n = 0; #10; reset_n = 1;
       SW[9:3] = 7'b0001000; SW[2:0] = 3'b100; #10
       
       line = 1; #10; line = 0;
       
       clear = 1; #30; clear = 0; #30;
       circle = 1; #10; circle = 0; #50;
       clear = 1; #30; clear = 0; #10;
       
       line = 1; clear = 1; #20
       line = 1; circle = 1; 
       
       $finish;
    end
endmodule
