// STM32L432KC_RCC.h
// Header for RCC functions

#ifndef STM32L4_TIM_H
#define STM32L4_TIM_H

#include <stdint.h>

///////////////////////////////////////////////////////////////////////////////
// Definitions
///////////////////////////////////////////////////////////////////////////////

#define __IO volatile

// Base addresses
#define TIM2_BASE (0x40000000UL) // Base address of TIM2 (For PWM)
#define TIM6_BASE (0x40001000UL) // Base address of TIM6 (For Note Duration)

// PLL
#define PLLSRC_HSI 0
#define PLLSRC_HSE 1

// Clock configuration
#define SW_HSI 0
#define SW_HSE 1
#define SW_PLL 2

/**
 * @brief TIMx; RM0394 pg. 884
 */

typedef struct
{
  __IO uint32_t TIMx_CR1;   // 0x00
  __IO uint32_t TIMx_CR2;   // 0x04
  __IO uint32_t TIMx_SMCR;  // 0x08
  __IO uint32_t TIMx_DIER;  // 0x0c
  __IO uint32_t TIMx_SR;    // 0x10
  __IO uint32_t TIMx_EGR;   // 0x14
  __IO uint32_t TIMx_CCMR1; // 0x18
  __IO uint32_t TIMx_CCMR2; // 0x1c
  __IO uint32_t TIMx_CCER;  // 0x20
  __IO uint32_t TIMx_CNT;   // 0x24
  __IO uint32_t TIMx_PSC;   // 0x28
  __IO uint32_t TIMx_ARR;   // 0x2c
  __IO uint32_t RESERVED0;  // 0x30
  __IO uint32_t TIMx_CCR1;  // 0x34
  __IO uint32_t TIMx_CCR2;  // 0x38
  __IO uint32_t TIMx_CCR3;  // 0x3C
  __IO uint32_t TIMx_CCR4;  // 0x40
  __IO uint32_t RESERVED1;  // 0x44
  __IO uint32_t TIMx_DCR;   // 0x48
  __IO uint32_t TIMx_DMAR;  // 0x4c
  __IO uint32_t TIM2_OR1;   // 0x50
  __IO uint32_t TIM2_OR2;   // 0x60
} TIM_TypeDef;

#define TIM2 ((TIM_TypeDef *)TIM2_BASE)
#define TIM6 ((TIM_TypeDef *)TIM6_BASE)

///////////////////////////////////////////////////////////////////////////////
// Function prototypes
///////////////////////////////////////////////////////////////////////////////

void configureTIM(void);

#endif