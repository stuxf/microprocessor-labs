
/*
 * Stephen Xu
 * November 4th, 2024
 * stxu@g.hmc.edu
 * This is the SPI module for AES
 * It performs communication with MCU
 */

/////////////////////////////////////////////
// aes_spi
//   SPI interface.  Shifts in key and plaintext
//   Captures ciphertext when done, then shifts it out
//   Tricky cases to properly change sdo on negedge clk
/////////////////////////////////////////////

module aes_spi (
    input logic sck,
    input logic sdi,
    output logic sdo,
    input logic done,
    output logic [127:0] key,
    plaintext,
    input logic [127:0] ciphertext
);

  logic sdodelayed, wasdone;
  logic [127:0] ciphertextcaptured;

  // assert load
  // apply 256 sclks to shift in key and plaintext, starting with plaintext[127]
  // then deassert load, wait until done
  // then apply 128 sclks to shift out ciphertext, starting with ciphertext[127]
  // SPI mode is equivalent to cpol = 0, cpha = 0 since data is sampled on first edge and the first
  // edge is a rising edge (clock going from low in the idle state to high).
  always_ff @(posedge sck)
    if (!wasdone) {ciphertextcaptured, plaintext, key} = {ciphertext, plaintext[126:0], key, sdi};
    else {ciphertextcaptured, plaintext, key} = {ciphertextcaptured[126:0], plaintext, key, sdi};

  // sdo should change on the negative edge of sck
  always_ff @(negedge sck) begin
    wasdone = done;
    sdodelayed = ciphertextcaptured[126];
  end

  // when done is first asserted, shift out msb before clock edge
  assign sdo = (done & !wasdone) ? ciphertext[127] : sdodelayed;
endmodule
