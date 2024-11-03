// STM32L432KC_SPI.c
// Stephen XU
// stxu@g.hmc.edu
// Nov 2nd, 2024
// Implementation code for SPI

#include "STM32L432KC_SPI.h"

// Page 1313/1600 RM0394
void initSPI(int br, int cpol, int cpha)
{
    // 1. Already done. (Configure GPIO Pins)

    // 2. Write to the SPI_CR1 register

    // Configure the serial clock baud rate using the BR[2:0] bits (Note: 4)
    // Configure CPOL and CPHA bits
    // Select simplex or half-duplex mode by configuring RXONLY or BIDIMODE and BIDIOE
    // Configure the LSBFIRST bit to define the frame format 
    // Configure the CRCL and CRCEN bits if CRC is needed (Not needed)
    // Configure SSM and SSI
    // Configure the MSTR bit (mcu)

    // 3. Write to SPI_CR2 register

    // Configure the DS[3:0] bits to select the data length for the transfer
    // Configure SSOE
    // Set the FRF bit if the TI protocol is required
    // Set the NSSP bit if the NSS pulse mode between two data units is required (Not needed)
    // Configure the FRXTH bit. The RXFIFO threshold must be aligned to the read access size for the SPIx_DR register.
    // Initialize LDMA_TX and LDMA_RX bits if DMA is used in packed mode (Not needed)

    // 4. Enable SPI Bus
}

char spiSendReceive(char send)
{
    // Wait for TX EMPTY
    // Write to Data Register (Send)
    // Wait for RX Empty
    // Return value from Data Register (Receive)
}
