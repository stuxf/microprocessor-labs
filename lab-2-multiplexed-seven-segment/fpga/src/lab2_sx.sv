/* 
 * Stephen Xu
 * September 8th, 2024
 * stxu@g.hmc.edu
 * This is the top level module for the second lab
 * Its purpose is to allow for us to control two seven segment displays
 * We control them using two DIP switches
 * It also includes logic to display the sum of the switches
 * We use a time based MUX in order to alternate displays
 */

module lab2_sx(
    // Reset Switch
    input logic reset,
    // Four DIP switches on the board
    input logic [3:0] s1,
    // Additionally wired four DIP switches
    input logic [3:0] s2,
    // Indicates whether or not one of the displays is on
    output logic on1,
    // Indicates whether or not the other display is on
    output logic on2,
    // What the segments are
    output logic [6:0] seg,
    // What the LED represents
    output logic [4:0] leds
);

    // Logic for the clocks
    logic int_osc;
    logic out_clk;

    // Internal high-speed oscillator
    // 0b11 makes it run at 6 MHz
    HSOSC #(.CLKHF_DIV ("0b11")) OSCInst1 (
        // Enable low speed clock output
        .CLKHFEN(1'b1),
        // Power up the oscillator
        .CLKHFPU(1'b1),
        // Oscillator Clock Output
        .CLKHF(int_osc)
    );

    // Fractional clock divider, outputs a 240 hz clock
    fractional_clk_div sixty_hz(
        int_osc,
        reset,
        out_clk
    );

    // Logic for the time multiplexer
    logic select;
    logic [3:0] out;

    always_ff @(posedge out_clk) begin
        if (reset == 0) select <= 0;
        else select <= !select;
    end

    // Take divided clock and select
    time_multiplexer tmux (
        out_clk,
        select,
        s1,
        s2,
        out
    );

	// seven segment decoder here
	seven_segment display (
		out,
		seg
	);

    assign leds = s1 + s2;

    assign on1 = select;
    assign on2 = !select;

endmodule