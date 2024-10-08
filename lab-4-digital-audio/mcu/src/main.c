// Stephen Xu
// stxu@g.hmc.edu
// October 7th, 2024

#include "STM32L432KC_RCC.h"
#include "STM32L432KC_GPIO.h"
#include "STM32L432KC_FLASH.h"
#include "STM32L432KC_TIM.h"

// Define macros for constants
#define LED_PIN 3
#define DELAY_DURATION_MS 200

// Pitch in Hz, duration in ms
const int notes[][2] = {
    {659, 125},
    {623, 125},
    {659, 125},
    {623, 125},
    {659, 125},
    {494, 125},
    {587, 125},
    {523, 125},
    {440, 250},
    {0, 125},
    {262, 125},
    {330, 125},
    {440, 125},
    {494, 250},
    {0, 125},
    {330, 125},
    {416, 125},
    {494, 125},
    {523, 250},
    {0, 125},
    {330, 125},
    {659, 125},
    {623, 125},
    {659, 125},
    {623, 125},
    {659, 125},
    {494, 125},
    {587, 125},
    {523, 125},
    {440, 250},
    {0, 125},
    {262, 125},
    {330, 125},
    {440, 125},
    {494, 250},
    {0, 125},
    {330, 125},
    {523, 125},
    {494, 125},
    {440, 250},
    {0, 125},
    {494, 125},
    {523, 125},
    {587, 125},
    {659, 375},
    {392, 125},
    {699, 125},
    {659, 125},
    {587, 375},
    {349, 125},
    {659, 125},
    {587, 125},
    {523, 375},
    {330, 125},
    {587, 125},
    {523, 125},
    {494, 250},
    {0, 125},
    {330, 125},
    {659, 125},
    {0, 250},
    {659, 125},
    {1319, 125},
    {0, 250},
    {623, 125},
    {659, 125},
    {0, 250},
    {623, 125},
    {659, 125},
    {623, 125},
    {659, 125},
    {623, 125},
    {659, 125},
    {494, 125},
    {587, 125},
    {523, 125},
    {440, 250},
    {0, 125},
    {262, 125},
    {330, 125},
    {440, 125},
    {494, 250},
    {0, 125},
    {330, 125},
    {416, 125},
    {494, 125},
    {523, 250},
    {0, 125},
    {330, 125},
    {659, 125},
    {623, 125},
    {659, 125},
    {623, 125},
    {659, 125},
    {494, 125},
    {587, 125},
    {523, 125},
    {440, 250},
    {0, 125},
    {262, 125},
    {330, 125},
    {440, 125},
    {494, 250},
    {0, 125},
    {330, 125},
    {523, 125},
    {494, 125},
    {440, 500},
    {0, 0}};

int main(void)
{
    // Configure flash to add waitstates to avoid timing errors
    configureFlash();

    // Setup the PLL and switch clock source to the PLL
    configureClock();

    // Set up timer 2
    RCC->APB1ENR1 |= (1 << 0);
    // Set up timer 6
    RCC->APB1ENR1 |= (1 << 4);

    // Turn on clock to GPIOB
    RCC->AHB2ENR |= (1 << 1);

    // Set up timer
    TIMx_Init(TIM2);
    TIMx_Init(TIM6);

    // Set LED_PIN as output
    pinMode(LED_PIN, GPIO_OUTPUT);

    // Blink LED
    while (1)
    {
        TIMx_Delay_ms(TIM6, 200);
        ms_delay(DELAY_DURATION_MS);
        togglePin(LED_PIN);
    }
    return 0;
}

// TODO: Implement playNote function
void playNote(int frequency, int time)
{
    TIMx_SetFrequency(TIM2, frequency);
    TIMx_Delay_ms(TIM6, time);
}

void playFurElise()
{
    for (int noteIndex = 0; noteIndex < 109; ++noteIndex)
    {
        playNote(notes[noteIndex][0], notes[noteIndex][1]);
    }
}