`timescale 1ns/1ns
`default_nettype none

module fractional_clk_div_tb();

    // Declare signals
    logic clk;
    logic reset;
    logic out_clk;

    // Instantiate the Device Under Test (DUT)
    fractional_clk_div dut (
        .clk(clk),
        .reset(reset),
        .out_clk(out_clk)
    );


    // Generate clock signal with a period of 10 timesteps.
    always begin
        clk = 1; #5;
        clk = 0; #5;
    end

    // Testbench stimulus
    initial begin
        // Initialize signals
        reset = 0;  // Active low reset
        
        // Apply reset
        #20 reset = 1;  // Release reset

        // Wait for multiple output clock cycles
        repeat(250000) @(posedge clk);

        // End simulation
        $finish;
    end

endmodule