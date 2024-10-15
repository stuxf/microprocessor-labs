// STM32L432KC_TIM.c
// Source code for TIM functions
// Stephen Xu
// stxu@g.hmc.edu
// October 7th, 2024

#include "STM32L432KC_TIM.h"

#define SYSTEM_CLOCK 80000000 // Assuming 80 MHz system clock
#define DELAY_PSC 999         // Balance between max and min time...
#define PWM_PSC 59            // 60 - 1, seems to be best for optimizing between 20 Hz and 20kHz
#define DUTY_CYCLE 0.5        // 50% duty cycle for Square Wave

void TIMx_Init(TIMx_TypeDef *TIMx)
{
    // Select correct clock source in TIM control
    TIMx->TIMx_SMCR &= ~(0b111 << 0);
    TIMx->TIMx_SMCR &= ~(1 << 16);

    // Reset auto-reload value
    TIMx->TIMx_ARR = 0;

    // See pg. 862 and downwards of reference manual
    if (TIMx == TIM2)
    {
        // Set prescaler for PWM so that I can play between 20 Hz and 20 kHz (range of human hearing)
        TIMx->TIMx_PSC = PWM_PSC;

        // CC2 channel as output (CC2S)
        TIMx->TIMx_CCMR1 &= ~(0b11 << 8);
        // PWM mode 2 (OCM), use second set.
        TIMx->TIMx_CCMR1 |= (0b110 << 12);
        // Enable preload for CCR2
        TIMx->TIMx_CCMR1 |= (1 << 11);

        // Enable capture/compare output
        TIMx->TIMx_CCER |= (1 << 4);
        // TIMx->TIMx_CCER &= ~(1 << 5);
    }
    else if (TIMx == TIM6)
    {
        // Set prescaler for delay so that it does 1 ms. (off by 8 cuz max is 65536)
        TIMx->TIMx_PSC = DELAY_PSC;
        // 16 bit ARR
        TIMx->TIMx_ARR = 0xFFFF;
    }

    // Enable auto-reload so its buffered
    TIMx->TIMx_CR1 |= (1 << 7);

    // Enable event generation register
    TIMx->TIMx_EGR |= (1 << 0);

    // Enable counter
    TIMx->TIMx_CR1 |= (1 << 0);
}

// Could be better using update things but I'm lazy...
// Maximum delay of 65535/80 = 819.1875
// Obviously does 1 ms properly..
void TIMx_Delay_ms(TIMx_TypeDef *TIMx, uint32_t ms)
{
    // Reset counter
    TIMx->TIMx_CNT = 0;

    uint16_t wait_ticks = ms * 80; // 80 kHz timer clock, so 80 ticks per ms

    // Wait until delay is over .. hope it doesn't overflow :rofl:
    while (TIMx->TIMx_CNT < wait_ticks)
    {
    }
}

void TIMx_SetFrequency(TIMx_TypeDef *TIMx, uint32_t frequency)
{
    // Disable output for frequency 0 (kills the counter)
    if (frequency == 0)
    {
        TIMx->TIMx_CR1 &= ~(1 << 0);
        return;
    }

    // Enable counter
    TIMx->TIMx_CR1 |= (1 << 0);

    // Calculate period and duty cycle
    uint32_t timer_clock = SYSTEM_CLOCK / (PWM_PSC + 1);
    uint32_t period = timer_clock / frequency;
    uint32_t duty = (uint32_t)(period * DUTY_CYCLE);

    // Set auto-reload value (period)
    TIMx->TIMx_ARR = period - 1;

    // Set compare value (duty cycle)
    TIMx->TIMx_CCR2 = duty;

    // Generate update event
    TIMx->TIMx_EGR |= (1 << 0);
}