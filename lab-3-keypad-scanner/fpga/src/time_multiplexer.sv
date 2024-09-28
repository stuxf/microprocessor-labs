/* 
 * Stephen Xu
 * September 9th, 2024
 * stxu@g.hmc.edu
 * This is a submodule designed to select one of two 4 bit inputs
 * It does so every clock signal, given a select signal
 */

module time_multiplexer(
    input logic clk,
    input logic select,
    input logic [3:0] in1,
    input logic [3:0] in2,
    output logic [3:0] out
);

    // Change on clock
    always_ff @(posedge clk) begin
        // Basic multiplexer with select signal
        out <= select ? in1 : in2;
    end

endmodule