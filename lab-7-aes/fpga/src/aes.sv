/* 
 * Stephen Xu
 * November 3rd, 2024
 * stxu@g.hmc.edu
 * This is the top level module for the seventh lab
 * It performs AES encryption
 * It interacts with mcu over SPI
 */

/////////////////////////////////////////////
// aes
//   Top level module with SPI interface and SPI core
/////////////////////////////////////////////

module aes(input  logic sck, 
           input  logic sdi,
           output logic sdo,
           input  logic load,
           output logic done);

    logic clk;

    // Clk running 6 MHz
    HSOSC #(.CLKHF_DIV ("0b11")) OSCInst1 (
        // Enable low speed clock output
        .CLKHFEN(1'b1),
        // Power up the oscillator
        .CLKHFPU(1'b1),
        // Oscillator Clock Output
        .CLKHF(clk)
    );

    logic [127:0] key, plaintext, ciphertext;
            
    aes_spi spi(sck, sdi, sdo, done, key, plaintext, ciphertext);   
    aes_core core(clk, load, key, plaintext, done, ciphertext);
endmodule