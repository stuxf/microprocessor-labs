/* 
 * Stephen Xu
 * September 2nd, 2024
 * stxu@g.hmc.edu
 * This is a submodule designed to control a 7 segment display
 * It takes four bits of input, and maps it to digits 0x0 to 0xf
 */

module seven_segment(
    // input to seven segment display
    input logic [3:0] in,
    // pins for segment output
    output logic [6:0] segments
);

    // For model UA5651-11EWR5 of 7-segment displays
    // May work for others as well
    // Currently does not support decimal points 
    // abcdefg is referring to the following layout
    // https://commons.wikimedia.org/wiki/File:7-segment_labeled.svg

    always_comb
        case(in)                   // abcdefg
            4'h0:       segments = 7'b1111110;
            4'h1:       segments = 7'b0110000;
            4'h2:       segments = 7'b1101101;
            4'h3:       segments = 7'b1111001;
            4'h4:       segments = 7'b0110011;
            4'h5:       segments = 7'b1011011;
            4'h6:       segments = 7'b1011111;
            4'h7:       segments = 7'b1110000;
            4'h8:       segments = 7'b1110000;
            4'h9:       segments = 7'b1110011;
            4'ha:       segments = 7'b1110110;
            4'hb:       segments = 7'b0011110;
            4'hc:       segments = 7'b1001110;
            4'hd:       segments = 7'b0111101;
            4'he:       segments = 7'b1111001;
            4'hf:       segments = 7'b1000111;
            default:    segments = 7'b0000000;
        endcase
endmodule