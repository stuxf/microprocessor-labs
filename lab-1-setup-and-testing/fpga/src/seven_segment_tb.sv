`timescale 1ns/1ns
`default_nettype none
`define N_TV 16

module seven_segment_tb();
    // Set up test signals
    logic clk, reset;
    logic [3:0] in;
    logic [6:0] segments;
    logic [6:0] segments_expected; 
    logic [31:0] vectornum, errors;
    logic [10:0] testvectors[`N_TV]; // Vectors of format s[3:0]_seg[6:0]

    // Instantiate the device under test
    seven_segment dut(
        .in(in),
        .segments(segments)
    );

    // Generate clock signal with a period of 10 timesteps.
    always
        begin
            clk = 1; #5;
            clk = 0; #5;
        end

    // At the start of the simulation:
    //  - Load the testvectors
    initial
        begin
            $readmemb("seven_segment_testvectors.tv", testvectors);
            vectornum = 0; errors = 0;
            reset = 1; #27; reset = 0;
        end

    // Apply test vector on the rising edge of clk
    always @(posedge clk)
        begin
            #1; {in, segments_expected} = testvectors[vectornum];
        end
    initial
        begin
            // Create Dumpfile for signals
            $dumpfile("seven_segment_tb.vcd");
            $dumpvars(0, seven_segment_tb);
        end

    // Check results on the falling edge of clk
    always @(negedge clk)
        begin
            if (~reset) // skip during reset
                begin
                    if (segments != segments_expected)
                        begin
                            $display("Error: inputs: in=%b", in);
                            $display(" outputs: segments=%b (%b expected)", segments, segments_expected);
                            errors = errors + 1;
                        end

                    vectornum = vectornum + 1;

                    if (testvectors[vectornum] === 11'bx)
                        begin
                            $display("%d tests completed with %d erorrs.", vectornum, errors);
                            $finish;
                        end
                end
        end



endmodule