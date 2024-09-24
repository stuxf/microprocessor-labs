/* 
 * Stephen Xu
 * September 23rd, 2024
 * stxu@g.hmc.edu
 * Displays the last two digits pressed
 * Essentially a shift register
 */

module two_digits(
    input logic clk,
    input logic reset,
    input logic press,
    input logic [3:0] key,
    output logic [3:0] num1,
    output logic [3:0] num2
);

    // We do this so that we can detect when it changes from low -> high
    logic press_prev;

    always_ff @(posedge clk) begin
        if (reset == 0) begin
            press_prev <= '0;
            num1 <= '0;
            num2 <= '0;
        end else begin
            press_prev <= press;
            // Only change num on press
            if (press && !press_prev) begin
                num2 <= num1;
                num1 <= key;
            end
        end
    end
endmodule