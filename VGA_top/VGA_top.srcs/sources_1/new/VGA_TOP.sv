`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2024 05:19:17 PM
// Design Name: 
// Module Name: VGA_TOP
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


module VGA_TOP(
    input logic CLK100MHZ,    // using the same name as pin names
    input logic CPU_RESETN,   
    input logic BTNC, BTNR, BTNL,
    output logic [3:0] VGA_R, VGA_G, VGA_B, 
    output logic VGA_HS, VGA_VS,    
    input logic [15:0] SW

    );
    
    logic reset_n;
    logic clk;
    assign reset_n = CPU_RESETN;
    assign clk = CLK100MHZ;
    
    logic clear, line, circle;
    logic [6:0] radius;
    logic [2:0] in_color, color_out;
    
    assign clear = BTNR;
    assign line = BTNL;
    assign circle = BTNC;
    assign radius = SW[9:3];
    assign in_color = SW[2:0];
    
    logic [7:0] x_out;
    logic [6:0] y_out;
    
    logic plot;
    
    logic enX, enY, enC, en_xB, load_xB, load_yB, en_yB, en_d, y_count_reset, x_count_reset, px_count_en;
    
    vga_core core_inst(
        .clk(CLK100MHZ),                        // Clock input
        .resetn(reset_n),                      // resetn signal
        .x(x_out),                    // X-coordinate (8 bits for 160)
        .y(y_out),                    // Y-coordinate (7 bits for 120)
        .color(color_out),                // Pixel color input (3 bits)
        .plot(plot),                       // Write enable
        .VGA_R(VGA_R),               // VGA red channel
        .VGA_G(VGA_G),               // VGA green channel
        .VGA_B(VGA_B),               // VGA blue channel
        .VGA_HS(VGA_HS),                    // Horizontal sync
        .VGA_VS(VGA_VS) 
    );
    
    // Button Debouncing (detect high-to-low transition)
    
    logic clear_ff, clear_pressed, line_ff, line_pressed, circle_ff, circle_pressed;
    
    d_flipflop clear_press(
        .clk(clk),
        .areset(reset_n),
        .en(1'b1),
        .d(clear),
        .qs(clear_ff)
    );
    
    assign clear_pressed = (~clear_ff & clear);
    
    d_flipflop line_press(
        .clk(clk),
        .areset(reset_n),
        .en(1'b1),
        .d(line),
        .qs(line_ff)
    );
    
    assign line_pressed = (~line_ff & line);
    
    d_flipflop circl_press(
        .clk(clk),
        .areset(reset_n),
        .en(1'b1),
        .d(circle),
        .qs(circle_ff)
    );
    
    assign circle_pressed = (~circle_ff & circle);
    
    logic [7:0] x_line, x_circle;
    logic [6:0] y_line, y_circle;
    logic [2:0] color_line;
    logic max_x, max_y, max_px_count, xB_yB_comp, d_comp;
    
    // Instantiation of data path modules
    
    lineclear_algo lineclear_datapath(
        .clk(clk),
        .areset(reset_n),
        .clear(clear), 
        .line(line), 
        .enY(enY),
        .enX(enX),
        .y_count_reset(y_count_reset),
        .x_count_reset(x_count_reset),
        .max_x(max_x),
        .max_y(max_y),
        .x(x_line),
        .y(y_line),
        .color(color_line)
    );
    
    bresenham_algo cicrle_datapath(
        .clk(clk),
        .reset_n(reset_n),
        .enC(enC),
        .radius(radius),
        .color(in_color),
        .en_xB(en_xB),
        .load_xB(load_xB),
        .load_yB(load_yB),
        .en_yB(en_yB),
        .en_d(en_d),
        .px_count_en(px_count_en),
        .xB_yB_comp(xB_yB_comp),
        .max_px_count(max_px_count),
        .d_comp(d_comp),
        .x_out(x_circle),
        .y_out(y_circle) 
    );
    
    // Control path instantiation
    
    controlpath controlpath_inst(
        .clk(clk),
        .areset(reset_n),
        .max_x(max_x),
        .max_y(max_y),
        .clear(clear),
        //.line(line),
        //.circle(circle),
        .d_comp(d_comp),
        .XB_YB_comp(xB_yB_comp),
        .clear_pressed(clear_pressed),
        .line_pressed(line_pressed),
        .circle_pressed(circle_pressed),
        .max_px_count(max_px_count),
        .enX(enX),
        .enY(enY),
        .enC(enC),
        .x_count_reset(x_count_reset), 
        .y_count_reset(y_count_reset),
        .px_count_en(px_count_en),
        .en_XB(en_xB), 
        .load_XB(load_xB),
        .en_YB(en_yB),
        .load_YB(load_yB),
        .en_D(en_d),
        .plot(plot)
    );
    
    // Outputs
    
    assign color_out = enC ? in_color : color_line;
    assign x_out =  enC ? x_circle : x_line;
    assign y_out = enC ? y_circle : y_line;
    
endmodule
