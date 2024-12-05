`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2024 06:27:08 PM
// Design Name: 
// Module Name: tb_bresenham_algo
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


module tb_bresenham_algo;
    logic clk, reset_n, enC;
    logic [6:0] radius;
    logic [2:0] color;
    logic en_xB, load_xB, load_yB, en_yB, en_d, xB_yB_comp, d_comp, px_count_reset, max_px_count;
    logic [7:0] x_out;
    logic [6:0] y_out;
    
    bresenham_algo dut(.*);
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10 time units clock period
    end
    
    initial begin
        enC = 0; en_xB = 0; load_xB = 0; en_yB = 0; en_d = 0; load_yB = 0; radius = 7'b0000100; color = 3'b100; 
        reset_n = 0; px_count_reset = 0; #10
        reset_n = 1; #10; reset_n = 0; #10; reset_n = 1;
        
        #10
        
        px_count_reset = 1; #10; px_count_reset = 0; #10; px_count_reset = 1;
        
        enC = 1; #10; 
        load_xB = 1; #10; load_xB = 0;
        load_yB = 1; #10; load_yB = 0;
        
        en_xB = 1; #10 en_xB = 0; 
        en_yB = 1; #50; en_yB = 0;
        en_d = 1; #50; en_d = 0; 
        
        en_xB = 1; load_xB = 1; en_yB = 1; en_d = 1;
        $finish;
        
    end
endmodule
