/* 
 * Stephen Xu
 * September 23rd, 2024
 * stxu@g.hmc.edu
 * This is modified code from the second lab
 * Uses time multiplexing to display two SSDs
 */

module two_ssd(
    // Reset Switch
    input logic reset,
    // Clock
    input logic clk,
    // Four DIP switches on the board
    input logic [3:0] num1,
    // Additionally wired four DIP switches
    input logic [3:0] num2,
    // Indicates whether or not one of the displays is on
    output logic on1,
    // Indicates whether or not the other display is on
    output logic on2,
    // What the segments are
    output logic [6:0] seg
);

    // Logic for the clocks
    logic int_osc;
    logic out_clk;

    // Fractional clock divider, outputs a 250 hz clock
    fractional_clk_div smaller_hz(
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
        num1,
        num2,
        out
    );

	// seven segment decoder here
	seven_segment display (
		out,
		seg
	);

    // Drive the transistors alternately
    assign on1 = select;
    assign on2 = !select;
endmodule