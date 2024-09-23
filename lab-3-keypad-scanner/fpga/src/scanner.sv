/* 
 * Stephen Xu
 * September 14th, 2024
 * stxu@g.hmc.edu
 * Scans input from a keyboard matrix
 * Puts current through rows one at a time
 * Checks rows to see which key is pressed
 */

module scanner(
    input logic clk,
    input logic reset,
    input logic [3:0] rows,
    output logic [3:0] cols,
    output logic [1:0] pressed_row,
    output logic [1:0] pressed_col,
    output logic press
);

    // Use synchronizer for metastability
    // Adds two clock delay
    logic [3:0] stable_rows;
    sync synchronizer (
        clk,
        rows,
        stable_rows
    );

    typedef enum logic [2:0] {
        col0,
        col0_hold,
        col1,
        col1_hold,
        col2,
        col2_hold,
        col3,
        col3_hold
    } statetype;

    statetype state, nextstate;

    // Hold timer
    logic [1:0] hold_timer;

    // State register
    always_ff @(posedge clk)
        if (reset == 0) begin
            state <= col0;
            hold_timer <= 2'b00;
        end else begin
            state <= nextstate;
            if (state == col0_hold || state == col1_hold || state == col2_hold || state == col3_hold) begin
                if (hold_timer < 2'b11)
                    hold_timer <= hold_timer + 1;
            end else
                hold_timer <= 2'b00;
        end

    // Next state register
    always_comb begin

        case (state)
            col0: if ($onehot(stable_rows)) begin
                            nextstate = col3_hold;
                        end
                        else nextstate = col1;
            col1: if ($onehot(stable_rows)) begin
                            nextstate = col0_hold;
                        end
                        else nextstate = col2;
            col2: if ($onehot(stable_rows)) begin
                            nextstate = col1_hold;
                        end
                        else nextstate = col3;
            col3: if ($onehot(stable_rows)) begin
                            nextstate = col2_hold;
                        end
                        else nextstate = col0;
            col0_hold: if (stable_rows[pressed_row] && hold_timer < 2'b11) begin
                            nextstate = col0_hold;
                       end
                       else nextstate = col1;
            col1_hold: if (stable_rows[pressed_row] && hold_timer < 2'b11) begin
                            nextstate = col1_hold;
                       end
                       else nextstate = col2;
            col2_hold: if (stable_rows[pressed_row] && hold_timer < 2'b11) begin
                            nextstate = col2_hold;
                       end
                       else nextstate = col3;
            col3_hold: if (stable_rows[pressed_row] && hold_timer < 2'b11) begin
                            nextstate = col3_hold;
                       end
                       else nextstate = col0;
            default: nextstate = col0;
        endcase
    end

    // Pressed Row logic
    always_ff @(posedge clk) begin
        if (reset == 0) begin
            pressed_row <= 2'd0;
        end 
        else begin
            case (stable_rows)
                4'b0001: pressed_row <= 2'd0;
                4'b0010: pressed_row <= 2'd1;
                4'b0100: pressed_row <= 2'd2;
                4'b1000: pressed_row <= 2'd3;
                default: pressed_row <= pressed_row;
            endcase
        end
    end

    // output logic
    always_comb begin
        // Assign columns
        case (nextstate)
            col0, col0_hold:    cols = 4'b0001;
            col1, col1_hold:    cols = 4'b0010;
            col2, col2_hold:    cols = 4'b0100;
            col3, col3_hold:    cols = 4'b1000;
            default:            cols = 4'b0000;
        endcase

        case (nextstate)
            col0, col0_hold:    pressed_col = 2'd0;
            col1, col1_hold:    pressed_col = 2'd1;
            col2, col2_hold:    pressed_col = 2'd2;
            col3, col3_hold:    pressed_col = 2'd3;
            default:            pressed_col = 2'd0;
        endcase

        press = (state == col0_hold || state == col1_hold || state == col2_hold || state == col3_hold);
    end
endmodule