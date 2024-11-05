/*
 * Stephen Xu
 * November 4th, 2024
 * stxu@g.hmc.edu
 * This module performs key expansion for aes
 * Generates round keys from key
 */
module KeyExpansion (
    input logic clk,
    input logic [127:0] inkey,
    input logic [3:0] round,
    output logic [127:0] outkey
);
  // Split into words
  logic [31:0] w0, w1, w2, w3;
  assign {w0, w1, w2, w3} = inkey;

  // Apply RotWord and SubWord to w3
  logic [31:0] rot_out, sub_out;

  RotWord rot (
      .in (w3),
      .out(rot_out)
  );
  SubWord sub (
      .clk(clk),
      .in (rot_out),
      .out(sub_out)
  );

  // Get rcon constant
  logic [31:0] rcon;
  always_comb begin
    case (round)
      4'h1:    rcon = 32'h01_00_00_00;
      4'h2:    rcon = 32'h02_00_00_00;
      4'h3:    rcon = 32'h04_00_00_00;
      4'h4:    rcon = 32'h08_00_00_00;
      4'h5:    rcon = 32'h10_00_00_00;
      4'h6:    rcon = 32'h20_00_00_00;
      4'h7:    rcon = 32'h40_00_00_00;
      4'h8:    rcon = 32'h80_00_00_00;
      4'h9:    rcon = 32'h1B_00_00_00;
      4'hA:    rcon = 32'h36_00_00_00;
      default: rcon = 32'h00_00_00_00;
    endcase
  end

  // Generate new key
  always_ff @(posedge clk) begin
    if (round == 0) begin
      outkey <= inkey;
    end else begin
      outkey[127:96] <= w0 ^ sub_out ^ rcon;
      outkey[95:64]  <= w1 ^ outkey[127:96];
      outkey[63:32]  <= w2 ^ outkey[95:64];
      outkey[31:0]   <= w3 ^ outkey[63:32];
    end
  end

endmodule


module RotWord (
    input  logic [31:0] in,
    output logic [31:0] out
);
  assign out = {in[23:0], in[31:24]};
endmodule

module SubWord (
    input  logic        clk,
    input  logic [31:0] in,
    output logic [31:0] out
);
  sbox_sync s0 (
      .clk(clk),
      .a  (in[31:24]),
      .y  (out[31:24])
  );
  sbox_sync s1 (
      .clk(clk),
      .a  (in[23:16]),
      .y  (out[23:16])
  );
  sbox_sync s2 (
      .clk(clk),
      .a  (in[15:8]),
      .y  (out[15:8])
  );
  sbox_sync s3 (
      .clk(clk),
      .a  (in[7:0]),
      .y  (out[7:0])
  );
endmodule
