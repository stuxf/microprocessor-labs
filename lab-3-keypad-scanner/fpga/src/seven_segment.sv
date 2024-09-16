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
    // 0 is on, 1 is off

    always_comb
        case(in)                   // abcdefg
            4'h0:       segments = 7'b0000001;
            4'h1:       segments = 7'b1001111;
            4'h2:       segments = 7'b0010010;
            4'h3:       segments = 7'b0000110;
            4'h4:       segments = 7'b1001100;
            4'h5:       segments = 7'b0100100;
            4'h6:       segments = 7'b0100000;
            4'h7:       segments = 7'b0001111;
            4'h8:       segments = 7'b0000000;
            4'h9:       segments = 7'b0001100;
            4'ha:       segments = 7'b0001000;
            4'hb:       segments = 7'b1100000;
            4'hc:       segments = 7'b0110001;
            4'hd:       segments = 7'b1000010;
            4'he:       segments = 7'b0110000;
            4'hf:       segments = 7'b0111000;
            default:    segments = 7'b1111111;
        endcase
endmodule