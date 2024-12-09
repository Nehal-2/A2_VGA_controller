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
    //input logic line,
    //input logic circle,
    input logic d_comp,
    input logic XB_YB_comp,
    input logic clear_pressed,
    input logic line_pressed,
    input logic circle_pressed,
    input logic max_px_count,
    output logic enX,
    output logic enY,
    output logic enC,
    output logic x_count_reset, 
    output logic y_count_reset,
    output logic px_count_en,
    output logic en_XB, 
    output logic load_XB,
    output logic en_YB,
    output logic load_YB,
    output logic en_D,
    output logic plot
    );
    
    typedef enum logic [2:0] {
        IDLE,
        Next_px,
        Next_row,
        Initcircle,
        pixel,
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
      
//      // Next-state logic:
//      always_comb begin
//        case (current_state)
//            IDLE: next_state = (line_pressed | clear) ? Next_px :((circle)? Initcircle:IDLE);
//            Next_px: next_state = clear_pressed ? IDLE : ((max_x&~max_y) ? Next_row:((max_x&max_y) ?IDLE:Next_px));
//            Next_row: next_state = clear_pressed ? IDLE : Next_px;
//            Initcircle:next_state = clear_pressed ? IDLE : pixel;
//            pixel: next_state = max_px_count ? IncX : pixel;
//            IncX:next_state = clear_pressed ? IDLE : ((XB_YB_comp)?((d_comp)? Dmorethanzero:Dlessthanzero):IDLE);
//            Dlessthanzero:next_state= clear_pressed ? IDLE : pixel;
//            Dmorethanzero:next_state= clear_pressed ? IDLE : pixel;
//            default: next_state = IDLE;
//         endcase
      
      // Next-state logic:
      always_comb begin
        case (current_state)
            IDLE: begin
                if (line_pressed | clear_pressed)
                    next_state = Next_px;
                else if (circle_pressed) 
                    next_state = Initcircle;
                else 
                    next_state = IDLE;
            end
            Next_px: begin
//                if (clear_pressed)
//                    next_state = IDLE;
               if (max_x & ~max_y)
                    next_state = Next_row;
                else if (max_x & max_y)
                    next_state = IDLE;
                else
                    next_state = Next_px;
            end
            Next_row: begin
                if (clear_pressed)
                    next_state = IDLE;
                else 
                    next_state = Next_px;
            end 
            Initcircle: begin
                if (clear_pressed)
                    next_state = IDLE;
                else 
                    next_state = pixel;
            end 
            pixel: begin
                if (clear_pressed)
                    next_state = IDLE;
                else if (max_px_count)
                    next_state = IncX;
                else
                    next_state = pixel;
            end
            IncX: begin
                if (clear_pressed)
                    next_state = IDLE;
                else if (!XB_YB_comp)
                    next_state = IDLE;
                else begin 
                    if (d_comp)
                        next_state = Dmorethanzero;
                    else
                        next_state = Dlessthanzero;
                end
            end
            Dlessthanzero:begin
                if (clear_pressed)
                    next_state = IDLE;
                else 
                    next_state = pixel;
            end
            Dmorethanzero: begin
                if (clear_pressed)
                    next_state = IDLE;
                else 
                    next_state = pixel;
            end
            default: next_state = IDLE;
         endcase

       end
       
       // Output logic:
//       always_comb begin
//            enX= (current_state == Next_px)&~(current_state == Next_row);
//            enY= (current_state == Next_row)&~(current_state == Next_px);
//            enC= (current_state == Initcircle)|(current_state == IncX)|(current_state == Dlessthanzero)|(current_state == Dmorethanzero); //(current_state == Initcircle|IncX|Dlessthanzero|Dmorethanzero); //Initcircle|IncX|Dlessthanzero|Dmorethanzero
//            y_count_reset=(current_state == Next_px)|(current_state == Next_row);
//            x_count_reset=(current_state == Next_px);
//            px_count_en=(current_state == Initcircle) |(current_state == IncX); //(current_state == IDLE)|(current_state == Dlessthanzero)|(current_state == Dmorethanzero);
//            en_XB=(current_state == IncX & max_px_count);
//            load_XB=(current_state == Initcircle);
//            load_YB = (current_state == Initcircle);
//            en_YB =((current_state == Dmorethanzero) & max_px_count) |(current_state == Initcircle);
//            en_D=(current_state == Dlessthanzero)|(current_state == Dmorethanzero);
//            plot = (current_state == Next_px)|(current_state == IncX);// ((current_state == Initcircle)|(current_state == IncX)|(current_state == Dlessthanzero)|(current_state == Dmorethanzero));//(current_state == IncX);//|(current_state == Dmorethanzero)|(current_state == Dlessthanzero);
//       end
       
       always_comb begin 
        case(current_state)
        IDLE: begin 
            enX = 0;
            enY = 0;
            enC = 0;
            y_count_reset = 0;
            x_count_reset = 0;
            px_count_en = 0;
            en_XB = 0;
            load_XB = 0;
            en_YB = 0;
            load_YB = 0;
            en_D = 0;
            plot = 0;
        end
        Next_px: begin 
            enX = 1;
            enY = 0;
            enC = 0;
            y_count_reset = 1;
            x_count_reset = 1;
            px_count_en = 0;
            en_XB = 0;
            load_XB = 0;
            en_YB = 0;
            load_YB = 0;
            en_D = 0;
            plot = 1;
        end
        Next_row: begin 
            enX = 0;
            enY = 1;
            enC = 0;
            y_count_reset = 1;
            x_count_reset = 0;
            px_count_en = 0;
            en_XB = 0;
            load_XB = 0;
            en_YB = 0;
            load_YB = 0;
            en_D = 0;
            plot = 0;
        end
        Initcircle: begin 
            enX = 0;
            enY = 0;
            enC = 1;
            y_count_reset = 0;
            x_count_reset = 0;
            px_count_en = 0;
            en_XB = 1;
            load_XB = 1;
            en_YB = 1;
            load_YB = 1;
            en_D = 1;
            plot = 0;
        end
        pixel: begin 
            enX = 0;
            enY = 0;
            enC = 1;
            y_count_reset = 0;
            x_count_reset = 0;
            px_count_en = 1;
            en_XB = 0;
            load_XB = 0;
            en_YB = 0;
            load_YB = 0;
            en_D = 0;
            plot = 1;
        end 
        IncX: begin 
            enX = 0;
            enY = 0;
            enC = 1;
            y_count_reset = 0;
            x_count_reset = 0;
            px_count_en = 0;
            en_XB = 1;
            load_XB = 0;
            en_YB = 0;
            load_YB = 0;
            en_D = 0;
            plot = 1;
        end
        Dlessthanzero: begin 
            enX = 0;
            enY = 0;
            enC = 1;
            y_count_reset = 0;
            x_count_reset = 0;
            px_count_en = 0;
            en_XB = 0;
            load_XB = 0;
            en_YB = 0;
            load_YB = 0;
            en_D = 1;
            plot = 0;
        end 
        Dmorethanzero: begin 
            enX = 0;
            enY = 0;
            enC = 1;
            y_count_reset = 0;
            x_count_reset = 0;
            px_count_en = 0;
            en_XB = 0;
            load_XB = 0;
            en_YB = 1;
            load_YB = 0;
            en_D = 1;
            plot = 0;
        end
        default: begin
            enX = 0;
            enY = 0;
            enC = 0;
            y_count_reset = 0;
            x_count_reset = 0;
            px_count_en = 0;
            en_XB = 0;
            load_XB = 0;
            en_YB = 0;
            load_YB = 0;
            en_D = 0;
            plot = 0;
        end         
        endcase
       end
        
endmodule