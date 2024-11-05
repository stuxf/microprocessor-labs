/* 
 * Stephen Xu
 * November 4th, 2024
 * stxu@g.hmc.edu
 * This module performs AddRoundKey for aes
 * Combines round_key with state
 */
module AddRoundKey(
    input logic[127:0] in,
    input logic[127:0] round_key,
    output logic[127:0] out
);
    assign out = in ^ round_key;
endmodule