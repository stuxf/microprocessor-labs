/* 
 * Stephen Xu
 * September 15th, 2024
 * stxu@g.hmc.edu
 * Testbench for scanner module
 */

`timescale 1ns/1ns
`default_nettype none

module two_digits_tb();
    // Set up test signals
    logic clk, reset, press;
    logic [3:0] key, num1, num2;

    // Instantiate the device under test
    two_digits dut(
        clk,
        reset,
        press,
        key,
        num1,
        num2
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
        key = 4'b0000;
    end

    initial begin
        // Wait until next clock cycle
        #104;

        // Press Down Key 8
        key = 4'b1000;

        press = 1;

        #100;

        press = 0;

        #100;

        key = 4'b0100;
        press = 1;

        #100;

        press = 0;

        #100;

        key = 4'b0010;
        press = 1;

        #100;
    end
endmodule