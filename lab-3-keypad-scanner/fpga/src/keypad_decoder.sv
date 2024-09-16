/* 
 * Stephen Xu
 * September 14th, 2024
 * stxu@g.hmc.edu
 * Scans input from a keyboard matrix
 * Puts current through rows one at a time
 * Checks rows to see which key is pressed
 */

module keypad_decoder(
    input logic clk,
    input logic [1:0] row,
    input logic [1:0] col,
    output logic [3:0] key
);

    always_comb begin
        case( {row, col} )
            default: key = 4'h0;
        endcase
    end

endmodule