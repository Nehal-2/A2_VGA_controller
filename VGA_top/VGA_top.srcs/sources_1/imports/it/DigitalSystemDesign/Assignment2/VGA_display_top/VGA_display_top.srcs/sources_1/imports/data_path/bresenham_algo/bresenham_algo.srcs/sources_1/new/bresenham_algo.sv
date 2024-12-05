`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2024 01:07:08 PM
// Design Name: 
// Module Name: bresenham_algo
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


module bresenham_algo(
    input logic clk,
    input logic reset_n,
    input logic enC,
    input logic [6:0] radius,
    input logic [2:0] color,
    input logic en_xB, // for counter xB
    input logic load_xB,
    input logic load_yB,
    input logic en_yB, // for register yB
    input logic en_d, // for register d
    input logic px_count_reset,
    output logic xB_yB_comp,
    output logic d_comp,
    output logic max_px_count,
    output logic [7:0] x_out,
    output logic [6:0] y_out 
    );
    
    localparam XC = 80;
    localparam YC = 60;
    
    logic enC_ff, is_begin;
    
    logic [7:0] xB;
    logic [6:0] reg_yB, radius_capped;
        
    d_flipflop init_d(
        .clk(clk),
        .areset(reset_n),
        .en(enC),
        .d(enC),
        .qs(enC_ff)
    );
    
    assign is_begin = (~enC_ff & enC); // detect the global enable transition from 0 to 1
    
    // d logic:
    assign radius_capped = (radius <= 'd59) ? radius : 'd59;
    logic [6:0] initial_d, reg_d;
    
    assign initial_d = 3 - 2*radius_capped;
    
    always_ff @(posedge clk, negedge reset_n) begin
        if (!reset_n)
            reg_d <= 0;
        else if (en_d)
            reg_d <= is_begin ? initial_d : (d_comp ? reg_d + 4*xB + 6 : reg_d + 4*(xB - reg_yB) + 10);
     end
    
    assign d_comp = (reg_d < 0) & enC; // to generate en_d
    
    // x incrementer:
    nbit_counter#(.n(8)) xB_counter (
        .clk(clk),
        .areset(reset_n),
        .en(en_xB),
        .load(load_xB),
        .up_down(1'b0), // down count if high
        .d(8'b00000000),
        .q(xB) 
    );
    
    // Decrement y
    always_ff @(posedge clk, negedge reset_n) begin
        if (!reset_n)
            reg_yB <= 0;
        else if (en_yB)
            if (load_yB)
                reg_yB <= radius_capped;
            else
                reg_yB <= d_comp ? reg_yB : reg_yB - 1;
    end
    
    assign xB_yB_comp = (xB <= {1'b0,reg_yB}) & enC; // to generate en_xB
    
    // Set pixels:
    logic [7:0] px_x [0:7];
    logic [6:0] px_y [0:7];
    
    always_comb begin
        px_x[0] = XC + xB;
        px_x[1] = XC - xB;
        px_x[2] = XC + xB;
        px_x[3] = XC - xB;
        px_x[4] = XC + reg_yB;
        px_x[5] = XC - reg_yB;
        px_x[6] = XC + reg_yB;
        px_x[7] = XC - reg_yB;
        
        px_y[0] = YC + reg_yB;
        px_y[1] = YC + reg_yB;
        px_y[2] = YC - reg_yB;
        px_y[3] = YC - reg_yB;
        px_y[4] = YC + xB;
        px_y[5] = YC + xB;
        px_y[6] = YC - xB;
        px_y[7] = YC - xB;
    end 

    // Count pixels:
    logic [2:0] px_count;
    
    nbit_counter#(.n(3)) px_counter (
        .clk(clk),
        .areset(px_count_reset),
        .en(enC & ~en_xB),
        .up_down(1'b0), // down count if high
        .q(px_count)
    );
    
    assign max_px_count = (px_count < 8) ? 0 : 1;
    
    always_comb begin
        x_out = px_x[px_count];
        y_out = px_y[px_count];
    end
    
endmodule
