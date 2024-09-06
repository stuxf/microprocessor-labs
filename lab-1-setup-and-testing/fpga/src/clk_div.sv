/* 
 * Stephen Xu
 * September 5th, 2024
 * stxu@g.hmc.edu
 * This is the clock divider for Lab 1
 * Is meant to divide a 10k Hz Signal
 * Divides by power of 2^12
 * Returns a 2.4(4) Hz Pulse
 */

module clk_div(
    input logic clk,
    input logic reset,
    output logic out_clk
);

    logic [11:0] counter;

    always_ff @(posedge clk) begin
        if (reset == 0) counter <= 0;
        else            counter <= 12'(counter + 1);
    end

    assign out_clk = counter[11];

endmodule