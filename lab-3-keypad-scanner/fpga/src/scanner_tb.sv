/* 
 * Stephen Xu
 * September 15th, 2024
 * stxu@g.hmc.edu
 * Testbench for scanner module
 */

`timescale 1ns/1ns
`default_nettype none

module scanner_tb();
    // Set up test signals
    logic clk, reset;
    logic [3:0] rows;
    logic [3:0] cols;
    logic [1:0] pressed_row, pressed_col;
    logic press;

    // Instantiate the device under test
    scanner dut(
        clk,
        reset,
        rows,
        cols,
        pressed_row,
        pressed_col,
        press
    );

    // Generate clock signal with a period of 10 timesteps.
    always begin
        clk = 1; #5;
        clk = 0; #5;
    end

    // At the start of sim, pulse reset line
    // Also load test vectors
    initial begin
        reset = 0; #27; reset = 1;
        rows = 4'b0000;
    end

    initial begin
        // Wait until next clock cycle
        #104;

        rows = 4'b0010;

        #600;

        rows = 4'b0000;

        #50;

        rows = 4'b0100;
    end

    // Monitor output
    always @(posedge press) begin
        $display("Time %t: Key pressed at row %d, col %d", $time, pressed_row, pressed_col);
    end

endmodule