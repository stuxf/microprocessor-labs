`timescale 1ns/1ns
`default_nettype none

module time_multiplexer_tb();

    // Declare signals
    logic clk;
    logic select;
    logic [3:0] in1, in2;
    logic [3:0] out;

    // Instantiate the Device Under Test (DUT)
    time_multiplexer dut (
        clk,
        select,
        in1,
        in2,
        out
    );

    always begin
        clk = 1; #5;
        clk = 0; #5;
    end

    // Testbench stimulus
    initial begin
        select = 0;
        in1 = 4'b0000;
        in2 = 4'b1111;
        
        #10;

        // Test case 1: select = 0
        select = 0;
        in1 = 4'b1010;
        in2 = 4'b0101;
        #5;

        // Test case 2: select = 1
        select = 1;
        #5;

        // Test case 3: Change inputs
        in1 = 4'b1100;
        in2 = 4'b0011;
        #5;

        // Test case 4: Change select
        select = 0;
        #5;

        #25;

        // End simulation
        $finish;
    end

endmodule