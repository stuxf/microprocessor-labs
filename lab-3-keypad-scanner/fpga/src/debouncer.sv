/* 
 * Stephen Xu
 * September 22th, 2024
 * stxu@g.hmc.edu
 * This is a debouncer
 * It takes a four bit number input, and a press signal
 * When that input has been held constant for long enough, it'll indicate a press 
 */

module debouncer(
    input logic clk,
    input logic reset,
    input logic [3:0] num,
    input logic pressed,
    output logic debounce_pressed
);
    logic [5:0] counter;
    logic [3:0] last_num;

    always_ff @(posedge clk) begin
        if (reset == 0) begin
            counter <= '0;
            last_num <= '0;
            debounce_pressed <= 0;
        end else if (num != last_num || pressed == 0) begin
            counter <= '0;
            last_num <= num;
            debounce_pressed <= 0;
        end else if(counter < 50) begin
            counter <= counter + 1;
        end else begin
            debounce_pressed <= 1;
        end
    end
endmodule