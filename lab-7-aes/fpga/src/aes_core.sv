/*
 * Stephen Xu
 * November 3rd, 2024
 * stxu@g.hmc.edu
 * This is the encryption module for AES
 * It performs AES encryption
 */


/////////////////////////////////////////////
// aes_core
//   top level AES encryption module
//   when load is asserted, takes the current key and plaintext
//   generates ciphertext and asserts done when complete 11 cycles later
//
//   See FIPS-197 with Nk = 4, Nb = 4, Nr = 10
//
//   The key and message are 128-bit values packed into an array of 16 bytes as
//   shown below
//        [127:120] [95:88] [63:56] [31:24]     S0,0    S0,1    S0,2    S0,3
//        [119:112] [87:80] [55:48] [23:16]     S1,0    S1,1    S1,2    S1,3
//        [111:104] [79:72] [47:40] [15:8]      S2,0    S2,1    S2,2    S2,3
//        [103:96]  [71:64] [39:32] [7:0]       S3,0    S3,1    S3,2    S3,3
//
//   Equivalently, the values are packed into four words as given
//        [127:96]  [95:64] [63:32] [31:0]      w[0]    w[1]    w[2]    w[3]
/////////////////////////////////////////////

module aes_core (
    input  logic         clk,
    input  logic         load,
    input  logic [127:0] key,
    input  logic [127:0] plaintext,
    output logic         done,
    output logic [127:0] ciphertext
);

  // TODO: Your code goes here

  logic [127:0] state_text = plaintext;

  typedef enum logic [2:0] {
    r_idle,
    r_start,
    r_middle,
    r_end,
    r_done
  } state_t;

  state_t state, nextstate;

  logic [3:0] round;

  always_ff @(posedge clk) begin
    if (load) begin
      round <= 0;
      state <= r_start;
    end else begin
      state <= nextstate;
    end
  end

  always_comb begin
    case (state)
      r_start: nextstate = r_middle;
      r_middle: nextstate = r_end;
      r_end: nextstate = r_done;
      r_done: nextstate = r_done;
      r_idle: nextstate = r_idle;
      default: nextstate = r_idle;
    endcase
  end

  // Controller Module (THIS ONE!)
  // SubBytes (uses sbox)
  // ShiftRows (need to be figured out)
  // MixCols (alr done!)
  // AddRoundKey (supposedly easy)
  // KeyExpansion

  logic sub_en, shift_en, mix_en;

  // SubBytes is enabled for all rounds except start (middle and end)
  assign sub_en   = (state == r_middle || state == r_end) ? 1 : 0;
  // ShiftBytes is enabled for all rounds except start (middle and end)
  assign shift_en = (state == r_middle || state == r_end) ? 1 : 0;
  // Mix is enabled only in middle rounds
  assign mix_en   = (state == r_middle) ? 1 : 0;

  // AddRoundKey is always enabled so chilling ... (?)

  // We need to generate a different key to put into AddRoundKey though ... :thinking:

  // That is the job of KeyExpansion! But for our purposes we should probably modify it so that key gets generate each cycle ... seems easier

  logic [127:0] sub_output;
  logic [127:0] shift_output;
  logic [127:0] mix_output;
  logic [127:0] add_output;

  SubBytes sub(
    .in(state_text),
    .clk(clk),
    .en(sub_en),
    .out(sub_output)
  );

  ShiftRows shift(
    .in (sub_output),
    .en(shift_en),
    .out(shift_output)
  );

  mixcolumns mix(
    .a(shift_output),
    .en(mix_en),
    .y(mix_output)
  );

endmodule
