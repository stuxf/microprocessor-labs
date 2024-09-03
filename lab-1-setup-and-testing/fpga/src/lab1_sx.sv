/* 
 * Stephen Xu
 * September 2nd, 2024
 * stxu@g.hmc.edu
 * This is the top level module for the first lab
 * Its purpose is to allow for us to control a seven segment display
 * We control the seven segment display using 4 DIP switches
 */

module lab1_sx(
    // the four DIP switches (on the board, SW6)
    input logic [3:0] s,
    // 3 LEDs (you may use the on-board LEDs)
    output logic [2:0] led,
    // the segments of a common-anode 7-segment display
    output logic [6:0] seg
);

    // led[0] can be modeled as XOR of S1 and S0 switches
    assign led[0] = s[1] ^ s[0];

    // led[1] can be modeled as AND of S2 and S3 switches
    assign led[1] = s[3] & s[2];

    // TODO: led[2] blinks at every 2.4 hz. 

    // TODO: seven segment decoder here


endmodule