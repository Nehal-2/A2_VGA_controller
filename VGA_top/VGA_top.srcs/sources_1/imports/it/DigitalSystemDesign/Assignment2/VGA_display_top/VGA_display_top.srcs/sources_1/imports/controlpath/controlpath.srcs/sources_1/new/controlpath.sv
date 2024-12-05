`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2024 10:33:29 AM
// Design Name: 
// Module Name: controlpath
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


module controlpath(
  input logic clk,
    input logic areset,
    input logic max_x,
    input logic max_y,
    input logic clear,
    input logic line,
    input logic circle,
    input logic d_comp,
    input logic XB_YB_comp,
    input logic clear_pressed,
    output logic enX,
    output logic enY,
    output logic enC,
    output logic x_count_reset, 
    output logic y_count_reset,
    output logic px_count_reset,
    output logic en_XB, 
    output logic load_XB,
    output logic en_YB,
    output logic load_YB,
    output logic en_D,
    output logic plot
    );
    
    typedef enum logic [6:0] {
        IDLE,
        Next_px,
        Next_row,
        Initcircle,
        IncX,
        Dlessthanzero,
        Dmorethanzero
    } state_t;
    
    state_t current_state, next_state;
    
     
     // State transition:
     always_ff @(posedge clk or negedge areset) begin
        if (!areset)
            current_state <= IDLE;
        else
            current_state <= next_state;
      end
      
      
      // Next-state logic:
      always_comb begin
        case (current_state)
            IDLE: next_state = (line | clear) ? Next_px :((circle)? Initcircle:IDLE);
            Next_px: next_state = clear_pressed ? IDLE : ((max_x&~max_y) ? Next_row:((max_x&max_y) ?IDLE:Next_px));
            Next_row: next_state = clear_pressed ? IDLE : Next_px;
            Initcircle:next_state = clear_pressed ? IDLE : ((circle)?IncX:IDLE);
            IncX:next_state = clear_pressed ? IDLE : ((XB_YB_comp)?((d_comp)? Dlessthanzero:Dmorethanzero):IDLE);
            Dlessthanzero:next_state= clear_pressed ? IDLE : IncX;
            Dmorethanzero:next_state= clear_pressed ? IDLE : IncX;
            default: next_state = IDLE;
         endcase

       end
       
       // Output logic:
       always_comb begin
            enX= (current_state == Next_px&~Next_row);
            enY= (current_state == Next_row&~Next_px);
            enC= (current_state == (Initcircle|IncX|Dlessthanzero|Dmorethanzero));
            y_count_reset=(current_state == Next_px|Next_row);
            x_count_reset=(current_state == Next_px);
            px_count_reset=(current_state == Initcircle);
            en_XB=(current_state == IncX);
            load_XB=(current_state == Initcircle);
            load_YB = (current_state == Initcircle);
            en_YB =(current_state == Dmorethanzero);
            en_YB =(current_state == Initcircle);
            en_D=(current_state == Dlessthanzero|Dmorethanzero);
            plot = (current_state == Next_px | IncX);
       end
        
endmodule