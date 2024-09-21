/* 
 * Stephen Xu
 * September 8th, 2024
 * stxu@g.hmc.edu
 * This is a fractional clock divider
 * Is meant to toggle a signal on and off
 * It does so after every n clocks
 */

module fractional_clk_div(
    input logic clk,
    input logic reset,
    output logic out_clk
);

    integer counter;

    always_ff @(posedge clk) begin
        if (reset == 0) begin
            counter <= 1;
            out_clk <= 0;
        end
        if (counter >= 10000) begin
            out_clk <= ~out_clk;
            counter <= 1;
        end else begin
            counter <= counter + 1;
        end
    end
    
endmodule