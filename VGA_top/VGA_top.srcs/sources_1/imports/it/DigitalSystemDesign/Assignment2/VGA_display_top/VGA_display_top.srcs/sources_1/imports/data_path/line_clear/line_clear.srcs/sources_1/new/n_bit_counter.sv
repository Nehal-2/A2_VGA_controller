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


module nbit_counter#(
        parameter n = 4
)(
        input logic clk,
        input logic areset,
        input logic en,
        input logic load,
        input logic up_down, // down count if high
        input logic [n-1:0] d,
        output logic [n-1:0] q 
        
    );
    
    always @(posedge clk, negedge areset)
    begin 
        if(~areset) q <= 0;
        else if(en)
        begin 
            if(up_down) q <= q - 1;
            else        q <= q + 1;
        end
    end
endmodule