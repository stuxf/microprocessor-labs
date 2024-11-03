// DS1722.c
// Stephen XU
// stxu@g.hmc.edu
// Nov 2nd, 2024
// Implementation code for interactions with DS1722 Temp Sensor

#include "DS1722.h"
#include "STM32L432KC_SPI.h"

void initSensor(int resolution)
{
    // OPERATION-Programming Section
    // See Figure 2
    // Write 0x80 to indicate config
    spiSendReceive(0x80);
    // Set MSB to 111
    // Don't want one shot
    // Set lsb (shutdown bit) to 1 for continuous (0 for shutdown if low power)
    char config = 0b11100001;
    config |= resolution << 1;
    spiSendReceive(config);
}

double readTemp()
{
    // Chip enable
    digitalWrite(CS_PIN, PIO_HIGH);
    // Read MSB (send 0x2)
    spiSendReceive(0x2);
    // Send 0x0 to get
    char msb = spiSendReceive(0x0);
    // Read LSB (send 0x1)
    spiSendReceive(0x1);
    // Send 0x0 to get
    char lsb = spiSendReceive(0x1);
    // Set to low
    // Chip disable
    digitalWrite(CS_PIN, PIO_LOW);

    int16_t msb_lsb = (msb << 8) | lsb;

    return (double) msb_lsb / 256.0;
}
