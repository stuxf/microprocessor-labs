/*
 * Stephen Xu
 * November 4th, 2024
 * stxu@g.hmc.edu
 * This module performs ShiftRows for aes
 * Shifts rows of the state array by different offsets
 */
module ShiftRows (
    input logic en,
    input logic [127:0] in,
    output logic [127:0] out
);

  always_comb begin
    if (en) begin
      // First Row is Unchanged
      out[127:120] = in[127:120];
      out[95:88]   = in[95:88];
      out[63:56]   = in[63:56];
      out[31:24]   = in[31:24];

      // Second Row Gets Rotated Once
      out[119:112] = in[87:80];
      out[87:80]   = in[55:48];
      out[55:48]   = in[23:16];
      out[23:16]   = in[119:112];

      // Third Row Gets Rotated Twice
      out[111:104] = in[47:40];
      out[79:72]   = in[15:8];
      out[47:40]   = in[111:104];
      out[15:8]    = in[79:72];

      // Fourth Row Gets Rotated Three times
      out[103:96]  = in[7:0];
      out[71:64]   = in[103:96];
      out[39:32]   = in[71:64];
      out[7:0]     = in[39:32];
    end else begin
      out = in;
    end
  end

endmodule
