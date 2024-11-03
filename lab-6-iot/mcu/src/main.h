/**
    Main Header: Contains general defines and selected portions of CMSIS files
    @file main.h
    @author Josh Brake
    @version 1.0 10/7/2020
*/

#ifndef MAIN_H
#define MAIN_H

#include "STM32L432KC.h"

#define LED_PIN PB3 // LED pin for blinking on Port B pin 3
#define BUFF_LEN 32

#define SDI_PIN PA12
#define SDO_PIN PA6
#define SCK_PIN PA5
#define CS_PIN  PA8

#endif // MAIN_H