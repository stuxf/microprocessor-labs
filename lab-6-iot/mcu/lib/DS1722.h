// DS1722.h
// Stephen XU
// stxu@g.hmc.edu
// Nov 2nd, 2024
// Header code for interactions with DS1722 Temp Sensor

#ifndef DS1722_H
#define DS1722_H

#include "STM32L432KC.h"
#include "STM32L432KC_SPI.h"

#define CS_PIN PA8

#define EIGHT_BIT   0b11100000
#define NINE_BIT    0b11100010
#define TEN_BIT     0b11100100
#define ELEVEN_BIT  0b11100110
#define TWELVE_BIT  0b11101000

void initSensor(uint8_t config);

double readTemp();

#endif