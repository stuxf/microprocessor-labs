/* 
 * Stephen Xu
 * September 14th, 2024
 * stxu@g.hmc.edu
 * This is the top level module for the third lab
 * Its purpose is to allow for us to take keypad input
 * It displays those onto two seven segment displays
 */

module lab3_sx(
    // Reset Input
    input logic reset,
    // Outputs for the seven segment
    // Indicates whether or not one of the displays is on
    output logic on1,
    // Indicates whether or not the other display is on
    output logic on2,
    // What the segments are
    output logic [6:0] seg,
    // For keypad matrix
    input logic [3:0] rows,
    output logic [3:0] cols,
    // Debug LEDs
    output logic [2:0] help
);

    logic int_osc;

    // Internal low-speed oscillator
    LSOSC OSCInst1 (
        // Enable low speed clock output
        .CLKLFEN(1'b1),
        // Power up the oscillator
        .CLKLFPU(1'b1),
        // Oscillator Clock Output
        .CLKLF(int_osc)
    );

    // Fractional clock divider, outputs a 250 hz clock
    logic out_clk;
    fractional_clk_div tmux_clock(
        int_osc,
        reset,
        out_clk
    );


    // Internal Logic
    logic [1:0] pressed_row;
    logic [1:0] pressed_col;
    logic press;

    // Instantiate Scanner Circuit
    scanner keypad(
        int_osc,
        reset,
        rows,
        cols,
        pressed_row,
        pressed_col,
        press
    );

    logic [3:0] key;

    keypad_decoder decoder(
        pressed_row,
        pressed_col,
        key
    );

    logic [3:0] num1;
    logic [3:0] num2;

    logic debounce_pressed;
    debouncer debounce(
        int_osc,
        reset,
        key,
        press,
        debounce_pressed
    );

    two_digits digit_register(
        int_osc,
        reset,
        debounce_pressed,
        key,
        num1,
        num2
    );

    // seven segment display here
    two_ssd display(
        reset,
        out_clk,
        num2,
        num1,
        on1,
        on2,
        seg
    );

    assign help[0] = press;

    assign help[1] = rows[2];
    assign help[2] = rows[3];

endmodule