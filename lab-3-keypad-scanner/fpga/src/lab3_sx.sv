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
    output logic [3:0] cols
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

    // Internal Logic
    logic [1:0] pressed_row;
    logic [1:0] pressed_col;
    logic press;

    // Instantiate Scanner Circuit
    scanner keypad(
        int_osc,
        !reset,
        ~rows,
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

    logic [3:0] digit_to_display;

    // Every time a key is pressed
    always_ff @(posedge press) begin
        digit_to_display <= key;
    end

    // seven segment decoder here
	seven_segment display (
        digit_to_display,
        seg
	);

    assign on1 = 1;
    assign on2 = 1;

endmodule