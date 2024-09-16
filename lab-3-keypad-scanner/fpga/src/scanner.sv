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
    logic [3:0] stable_rows;
    sync synchronizer (
        clk,
        rows,
        stable_rows
    );

    typedef enum logic [3:0] {
        col0,
        col0_check,
        col1,
        col1_check,
        col2,
        col2_check,
        col3,
        col3_check,
        debounce,
        pressed
    } statetype;

    statetype state, nextstate;

    // Internal Logic
    logic [5:0] counter;

    // State register
    always_ff @(posedge clk)
        if (reset)  state <= col0;
        else        state <= nextstate;

    // Next state register
    always_comb begin

        case (state)
            col0:       nextstate = col0_check;
            col0_check: if ($onehot(stable_rows)) begin
                            nextstate = debounce;
                        end
                        else nextstate = col1;
            col1:       nextstate = col1_check;
            col1_check: if ($onehot(stable_rows)) begin
                            nextstate = debounce;
                        end
                        else nextstate = col2;
            col2: nextstate = col2_check;
            col2_check: if ($onehot(stable_rows)) begin
                            nextstate = debounce;
                        end
                        else nextstate = col3;
            col3:       nextstate = col3_check;
            col3_check: if ($onehot(stable_rows)) begin
                            nextstate = debounce;
                        end
                        else nextstate = col0;
            debounce:   if (counter >= 50) begin
                            nextstate = pressed;
                        end
                        else if (!stable_rows[pressed_row]) begin
                            nextstate = col0;
                        end 
                        else nextstate = debounce;
            pressed:    if (stable_rows == 0) begin
                            nextstate = col0;
                        end
                        else nextstate = pressed;
            default: nextstate = col0;
        endcase
    end

    // Pressed Col logic
    always_ff @(posedge clk) begin
        if (reset) begin
            pressed_col <= '0;
        end 
        else begin
            if (state != debounce && nextstate == debounce) begin
                case (state)
                    col0_check: pressed_col <= 2'd0;
                    col1_check: pressed_col <= 2'd1;
                    col2_check: pressed_col <= 2'd2;
                    col3_check: pressed_col <= 2'd3;
                    default: pressed_col <= pressed_col;
                endcase
            end
        end
    end

    // Pressed Row logic
    always_ff @(posedge clk) begin
        if (reset) begin
            pressed_row <= 2'd0;
        end 
        else begin
            if (state != debounce && nextstate == debounce) begin
                case (stable_rows)
                    4'b0001: pressed_row <= 2'd0;
                    4'b0010: pressed_row <= 2'd1;
                    4'b0100: pressed_row <= 2'd2;
                    4'b1000: pressed_row <= 2'd3;
                    default: pressed_row <= pressed_row;
                endcase
            end
        end
    end

    // Debounce logic
    always_ff @(posedge clk)
        if (reset)
            counter <= '0;
        else if (state != debounce && nextstate == debounce)
            counter <= '0;
        else if (state == debounce && counter < 50)
            counter <= counter + 1;

    // output logic
    always_comb begin
        if (state == debounce || state == pressed) begin
            cols = (4'b0001 << pressed_col);
        end
        case (state)
            col0:       cols = 4'b0001;
            col1:       cols = 4'b0010;
            col2:       cols = 4'b0100;
            col3:       cols = 4'b1000;
            default:    cols = 4'b0000;
        endcase
    end

    assign press = (state == pressed);

endmodule