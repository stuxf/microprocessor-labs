/**
 * Lab 5, Interrupts Lab
 * Stephen Xu, stxu@g.hmc.edu
 * Oct 22, 2024
 */

#include "STM32L432KC.h"
#include <stm32l432xx.h>

#define QUAD_A PA5
#define QUAD_B PA4
#define DELAY_TIM TIM2

int main(void)
{
    // Polling approach

    // Enable QUAD_A and QUAD_B as GPIO input
    gpioEnable(GPIO_PORT_A);
    pinMode(QUAD_A, GPIO_INPUT);
    pinMode(QUAD_B, GPIO_INPUT);

    // Initialize Timer

    while(1) {

        // Motor spins at 600 rpm. 
        // We want to sample at twice the rate
        // Makes 120 Pulses per rotation
        // 120 * 600 / 60 = 1200 Hz
        // We want to sample at at least 2400 Hz
        // Delay of 0.41 ms
        // Unfortunately, the minimum delay we can do is 1 ms
        // At least with current implementation
        // We can do more minute delays with different timer config
        // Unfortunately, I'm lazy.
        delay_millis(DELAY_TIM, 1);
    }

    // Interrupt Approach
}

// Some sort of interrupt handler