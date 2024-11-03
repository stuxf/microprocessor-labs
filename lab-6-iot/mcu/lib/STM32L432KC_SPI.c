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
    SPI1->CR1 |= _VAL2FLD(SPI_CR1_BR, br);
    // Configure CPOL and CPHA bits
    SPI1->CR1 |= _VAL2FLD(SPI_CR1_CPHA, cpha);
    SPI1->CR1 |= _VAL2FLD(SPI_CR1_CPOL, cpol);
    // Select simplex or half-duplex mode by configuring RXONLY or BIDIMODE and BIDIOE
    // Default is zero: 2-line unidirectional data mode selected
    // Configure the LSBFIRST bit to define the frame format
    // Configure the CRCL and CRCEN bits if CRC is needed (Not needed)
    // Default is zero, so disabled CRCEN
    // Configure SSM and SSI (Not needed, disabled)
    // Configure the MSTR bit (mcu)
    // MCU is controller
    SPI1->CR1 |= _VAL2FLD(SPI_CR1_MSTR, 1);

    // 3. Write to SPI_CR2 register

    // Configure the DS[3:0] bits to select the data length for the transfer
    // 8 bit
    SPI1->CR2 |= _VAL2FLD(SPI_CR2_DS, 0b0111);
    // Configure SSOE
    SPI1->CR2 |= _VAL2FLD(SPI_CR2_SSOE, 0b1);
    // Set the FRF bit if the TI protocol is required (default is motorola, we good w that)
    // Set the NSSP bit if the NSS pulse mode between two data units is required (Not needed)
    // Configure the FRXTH bit. The RXFIFO threshold must be aligned to the read access size for the SPIx_DR register.
    // We rollin w 8 bit
    SPI1->CR2 |= _VAL2FLD(SPI_CR2_FRXTH, 0b1);
    // Initialize LDMA_TX and LDMA_RX bits if DMA is used in packed mode (Not needed)

    // 4. Enable SPI Bus
    SPI1->CR1 |= (SPI_CR1_SPE);
}

char spiSendReceive(char send)
{
    // Wait for TX EMPTY
    while (!(SPI1->SR & SPI_SR_TXE))
        ;
    // Write to Data Register (Send)
    *(volatile char *)(&SPI1->DR) = send;
    // Wait for RX Empty
    while (!(SPI1->SR & SPI_SR_RXNE))
        ;
    // Return value from Data Register (Receive)
    return SPI1->DR;
}
