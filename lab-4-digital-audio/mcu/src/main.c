// Stephen Xu
// stxu@g.hmc.edu
// October 7th, 2024

#include "STM32L432KC_RCC.h"
#include "STM32L432KC_GPIO.h"
#include "STM32L432KC_FLASH.h"
#include "STM32L432KC_TIM.h"

// Define macros for constants
#define SPEAKER_PIN 3
void playNote(int frequency, int time);
void playFurElise(void);
void playCustomSong(void);

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
const int notesCustom[][2] = {
    {330, 500},
    {392, 500},
    {440, 500},
    {494, 1000},
    {0, 250},
    {440, 500},
    {392, 500},
    {330, 800},
    {0, 250},
    {330, 500},
    {392, 500},
    {440, 500},
    {523, 800},
    {0, 250},
    {494, 500},
    {440, 500},
    {392, 800},
    {0, 250},
    {330, 250},
    {392, 250},
    {440, 250},
    {494, 250},
    {523, 250},
    {587, 250},
    {659, 250},
    {698, 250},
    {740, 125},
    {659, 125},
    {587, 125},
    {523, 125},
    {494, 125},
    {440, 125},
    {392, 125},
    {330, 125},
    {349, 125},
    {392, 125},
    {440, 125},
    {494, 125},
    {523, 125},
    {587, 125},
    {659, 125},
    {698, 125},
    {740, 125},
    {784, 125},
    {830, 125},
    {880, 125},
    {932, 125},
    {988, 125},
    {1047, 250},
    {0, 0}
};

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

    // Set SPEAKER_PIN as AF (to connect to PWM)
    pinMode(SPEAKER_PIN, GPIO_ALT);
    // AF1 mode for AFSEL3 (Pin 3)
    GPIO->AFRL |= (0b0001 << 12);

    playFurElise();

    for(int i = 0; i < 4; ++i) {
        TIMx_Delay_ms(TIM6, 800);
    }

    playCustomSong();

    return 0;
}

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

void playCustomSong()
{
    for (int noteIndex = 0; noteIndex < 50; ++noteIndex)
    {
        playNote(notesCustom[noteIndex][0], notesCustom[noteIndex][1]);
    }
}