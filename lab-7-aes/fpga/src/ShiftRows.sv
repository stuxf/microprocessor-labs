/* 
 * Stephen Xu
 * November 4th, 2024
 * stxu@g.hmc.edu
 * This module performs ShiftRows for aes
 * Shifts rows of the state array by different offsets
 */
module ShiftRows(
    input logic clk,
    input logic en,
    input logic[127:0] in,
    output logic[127:0] out
);

always_comb begin : blockName
    if (en) begin
        out = in;
    end
    else out = in;
end
// First Row is Unchanged

// Second Row Gets Rotated Once

// Third Row Gets Rotated Twice

// Fourth Row Gets Rotated Three times

endmodule