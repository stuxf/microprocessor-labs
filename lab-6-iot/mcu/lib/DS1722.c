// DS1722.c
// Stephen XU
// stxu@g.hmc.edu
// Nov 2nd, 2024
// Implementation code for interactions with DS1722 Temp Sensor

#include "DS1722.h"

void initSensor(int resolution)
{
    // OPERATION-Programming Section
    // See Figure 2
    // Write 0x80 to indicate config
    // Set MSB to 111
    // Don't want one shot
    // Set lsb (shutdown bit) to 1 for continuous (0 for shutdown if low power)
}

double readTemp()
{
    // Chip enable
    // Read MSB (send 0x2)
    // Send 0x0 to get
    // Read LSB (send 0x1)
    // Send 0x0 to get
    // Set to low
    // Chip disable
}
