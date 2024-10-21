/* 
 * Stephen Xu
 * September 15th, 2024
 * stxu@g.hmc.edu
 * Testbench for scanner module
 */

`timescale 1ns/1ns
`default_nettype none

module debouncer_tb();
    // Set up test signals
    logic clk, reset;
    logic [3:0] num;
    logic pressed, debounce_pressed;

    // Instantiate the device under test
    debouncer dut(
        clk,
        reset,
        num,
        pressed,
        debounce_pressed
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
        num = 4'b0000;
    end

    initial begin
        pressed = 1;
        #104;
        num = 4'b1000;
        #500;
        pressed = 0;
        num = 4'b0000;
        #500;
        num = 4'b1000;
        pressed = 1;
        #5;
        num = 4'b0000;
        pressed = 0;
        #5;
        num = 4'b1000;
        pressed = 1;
        #5;
        num = 4'b0000;
        pressed = 0;
        #5;
        num = 4'b1000;
        pressed = 1;
        #500;
    end


endmodule