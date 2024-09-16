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
            4'b0000: key = 4'h1;
            4'b0001: key = 4'h2;
            4'b0010: key = 4'h3;
            4'b0011: key = 4'ha;
            4'b0100: key = 4'h4;
            4'b0101: key = 4'h5;
            4'b0110: key = 4'h6;
            4'b0111: key = 4'hb;
            4'b1000: key = 4'h7;
            4'b1001: key = 4'h8;
            4'b1010: key = 4'h9;
            4'b1011: key = 4'hc;
            4'b1100: key = 4'he;
            4'b1101: key = 4'h0;
            4'b1110: key = 4'hf;
            4'b1111: key = 4'hd;
            default: key = 4'h0;
        endcase
    end

endmodule