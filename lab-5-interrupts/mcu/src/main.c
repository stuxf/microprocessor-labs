/**
 * Lab 5, Interrupts Lab
 * Stephen Xu, stxu@g.hmc.edu
 * Oct 22, 2024
 */

#include "STM32L432KC.h"
#include <stm32l432xx.h>

// Printf stuff from Kavi
// Necessary includes for printf to work
#include <stdio.h>
#include "stm32l432xx.h"

// Function used by printf to send characters to the laptop
int _write(int file, char *ptr, int len) {
  int i = 0;
  for (i = 0; i < len; i++) {
    ITM_SendChar((*ptr++));
  }
  return len;
}

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
    RCC->APB1ENR1 |= RCC_APB1ENR1_TIM2EN;
    initTIM(DELAY_TIM);

    // Some sort of local variables about speed
    int aRiseTime = 0;
    int aFallTime = 0;
    int bRiseTime = 0;
    int bRiseTime = 0;

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