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
    output logic [4:0] led
);

    logic int_osc;
    logic out_clk;

	// seven segment decoder here
	seven_segment display (
		s1,
		seg
	);

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

    fractional_clk_div sixty_hz(
        int_osc,
        reset,
        out_clk
    );

    assign led[0] = out_clk;

endmodule