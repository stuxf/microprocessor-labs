/*
 * Stephen Xu
 * November 4th, 2024
 * stxu@g.hmc.edu
 * This module performs SubBytes for aes
 * Applies sbox to each byte
 */
module SubBytes (
    input logic clk,
    input logic en,
    input logic [127:0] in,
    output logic [127:0] out
);

  logic [127:0] out_swap;

  sbox_sync byte_zero (
      .a  (in[7:0]),
      .clk(clk),
      .y  (out_swap[7:0])
  );
  sbox_sync byte_one (
      .a  (in[15:8]),
      .clk(clk),
      .y  (out_swap[15:8])
  );
  sbox_sync byte_two (
      .a  (in[23:16]),
      .clk(clk),
      .y  (out_swap[23:16])
  );
  sbox_sync byte_three (
      .a  (in[31:24]),
      .clk(clk),
      .y  (out_swap[31:24])
  );
  sbox_sync byte_four (
      .a  (in[39:32]),
      .clk(clk),
      .y  (out_swap[39:32])
  );
  sbox_sync byte_five (
      .a  (in[47:40]),
      .clk(clk),
      .y  (out_swap[47:40])
  );
  sbox_sync byte_six (
      .a  (in[55:48]),
      .clk(clk),
      .y  (out_swap[55:48])
  );
  sbox_sync byte_seven (
      .a  (in[63:56]),
      .clk(clk),
      .y  (out_swap[63:56])
  );
  sbox_sync byte_eight (
      .a  (in[71:64]),
      .clk(clk),
      .y  (out_swap[71:64])
  );
  sbox_sync byte_nine (
      .a  (in[79:72]),
      .clk(clk),
      .y  (out_swap[79:72])
  );
  sbox_sync byte_ten (
      .a  (in[87:80]),
      .clk(clk),
      .y  (out_swap[87:80])
  );
  sbox_sync byte_eleven (
      .a  (in[95:88]),
      .clk(clk),
      .y  (out_swap[95:88])
  );
  sbox_sync byte_twelve (
      .a  (in[103:96]),
      .clk(clk),
      .y  (out_swap[103:96])
  );
  sbox_sync byte_thirteen (
      .a  (in[111:104]),
      .clk(clk),
      .y  (out_swap[111:104])
  );
  sbox_sync byte_fourteen (
      .a  (in[119:112]),
      .clk(clk),
      .y  (out_swap[119:112])
  );
  sbox_sync byte_fifteen (
      .a  (in[127:120]),
      .clk(clk),
      .y  (out_swap[127:120])
  );

  assign out = en ? out_swap : in;

endmodule
