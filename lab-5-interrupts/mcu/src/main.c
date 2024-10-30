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
int _write(int file, char *ptr, int len)
{
    int i = 0;
    for (i = 0; i < len; i++)
    {
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
    uint32_t aRiseTime = 0;
    uint32_t aFallTime = 0;
    uint32_t bRiseTime = 0;
    uint32_t bFallTime = 0;

    uint32_t pulses = 0;
    uint32_t pulseTime = 0;
    uint32_t time = 0;

    float revsPerSec;

    // Local variables about the current state
    int volatile curAState = digitalRead(QUAD_A);
    int volatile prevAState = curAState;
    int volatile curBState = digitalRead(QUAD_B);
    int volatile prevBState = curBState;
    int direction = 1;

    while (1)
    {
        // Motor spins at 600 rpm.
        // We want to sample at twice the rate
        // Makes 120 Pulses per rotation
        // 120 * 600 / 60 = 1200 Hz
        // We want to sample at at least 2400 Hz
        // Equivalent to a delay of 0.41 ms
        // So we delay for 200 microseconds
        // TIM2 is a CHONKY 32 bit timer so we chilling asf
        // Can keep this going for an hour haha
        delay_micros(TIM2, 200);
        time += 200;

        curAState = digitalRead(QUAD_A);
        curBState = digitalRead(QUAD_B);

        // Rising Edge A
        if ((prevAState == 0) && (curAState == 1))
        {
            aRiseTime = time;
            if (curBState) {
                direction = -1; 
                pulseTime += aRiseTime - bRiseTime;
            } else {
                direction = 1;
                pulseTime += bRiseTime - aRiseTime;
            }
            pulses++;
        }
        // Rising Edge B
        if ((prevBState == 0) && (curBState == 1))
        {
            bRiseTime = time;
        }
        // Falling Edge A
        if ((prevAState == 1) && (curAState == 0))
        {
            aFallTime = time;
        }
        // Falling Edge B
        if ((prevBState == 1) && (curBState == 0))
        {
            bFallTime = time;
        }
        if (time % 100000 == 0 && time != 0)
        {
            // Running average of pulses
            revsPerSec = direction * (pulses * 1.0)/(pulseTime * 1.0) * (1.0/120.0);
            printf("Rev/s: %f\n", revsPerSec);
            printf("Debug info: %d, %d, %d \n", aRiseTime, bRiseTime, time);
            printf("Debug info 2: %d, %d \n", prevAState, curAState);
        }
        // check state changes
        prevBState = curBState;
        prevAState = curAState;
    }

    // Interrupt Approach
}

// Some sort of interrupt handler