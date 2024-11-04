/*
Original Starter Code Attribution
-----
File: Lab_6_JHB.c
Author: Josh Brake
Email: jbrake@hmc.edu
Date: 9/14/19
*/
/**
 * Lab 6, IOT Temp Sensor Lab
 * Stephen Xu, stxu@g.hmc.edu
 * Nov 2nd, 2024
 */
#include "DS1722.h"

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "main.h"

int _write(int file, char *ptr, int len)
{
  int i = 0;
  for (i = 0; i < len; i++)
  {
    ITM_SendChar((*ptr++));
  }
  return len;
}

/////////////////////////////////////////////////////////////////
// Provided Constants and Functions
/////////////////////////////////////////////////////////////////

// Defining the web page in two chunks: everything before the current time, and everything after the current time
char *webpageStart = "<!DOCTYPE html><html><head><title>E155 Temp Sensor</title>\
	<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\
	</head>\
	<body><h1>E155 Temp Sensor</h1>";
char *tempStr = "<p>Temp Bit Control: </p><form action=\"eightbit\"><input type=\"submit\" value=\"Eight Bit Precision\"></form><form action=\"ninebit\"><input type=\"submit\" value=\"Nine Bit Precision!\"></form><form action=\"tenbit\"><input type=\"submit\" value=\"Ten Bit Precision!\"></form><form action=\"elevenbit\"><input type=\"submit\" value=\"Eleven Bit Precision!\"></form><form action=\"twelvebit\"><input type=\"submit\" value=\"Twelve Bit Precision!\"></form>";
char *webpageEnd = "</body></html>";

// determines whether a given character sequence is in a char array request, returning 1 if present, -1 if not present
int inString(char request[], char des[])
{
  if (strstr(request, des) != NULL)
  {
    return 1;
  }
  return -1;
}

int updateTempRes(char request[])
{
  int resolution = -1;

  if (inString(request, "eightbit") == 1)
  {
    initSensor(EIGHT_BIT);
    resolution = 8;
  }
  else if (inString(request, "ninebit") == 1)
  {
    initSensor(NINE_BIT);
    resolution = 9;
  }
  else if (inString(request, "tenbit") == 1)
  {
    initSensor(TEN_BIT);
    resolution = 10;
  }
  else if (inString(request, "elevenbit") == 1)
  {
    initSensor(ELEVEN_BIT);
    resolution = 11;
  }
  else if (inString(request, "twelvebit") == 1)
  {
    initSensor(TWELVE_BIT);
    resolution = 12;
  }

  return resolution;
}
/////////////////////////////////////////////////////////////////
// Solution Functions
/////////////////////////////////////////////////////////////////

int main(void)
{
  configureFlash();
  configureClock();

  gpioEnable(GPIO_PORT_A);
  gpioEnable(GPIO_PORT_B);
  gpioEnable(GPIO_PORT_C);

  RCC->AHB2ENR |= RCC_AHB2ENR_GPIOBEN;
  RCC->AHB2ENR |= RCC_AHB2ENR_GPIOAEN;

  RCC->APB2ENR |= (RCC_APB2ENR_TIM15EN);
  initTIM(TIM15);

  USART_TypeDef *USART = initUSART(USART1_ID, 125000);

  // SPI initialization code
  // Set four pins to CE, SCK, SDO, SDI
  // Described as MISO, MOSI, SCK, NSS on RM0394 Pg. 1306
  // Pins to set and AF are describes in page 53 of datasheet

  // pinMode(...,GPIO_ALT);
  pinMode(SDI_PIN, GPIO_ALT); // PB5
  pinMode(SDO_PIN, GPIO_ALT); // PB4
  pinMode(SCK_PIN, GPIO_ALT); // PB3

  // Chip select
  pinMode(CS_PIN, GPIO_OUTPUT); // PA8

  pinMode(LED_PIN, GPIO_OUTPUT);

  // Alternate Functions
  GPIOB->AFR[0] |= _VAL2FLD(GPIO_AFRL_AFSEL5, 0b0101); // SDI
  GPIOB->AFR[0] |= _VAL2FLD(GPIO_AFRL_AFSEL4, 0b0101); // SDO
  GPIOB->AFR[0] |= _VAL2FLD(GPIO_AFRL_AFSEL3, 0b0101); // SCK

  // Le enable
  RCC->APB2ENR |= RCC_APB2ENR_SPI1EN;

  // Define constants
  // Baud Rate
  int BAUD_RATE = 0b111;
  // Clock Polarity
  int CLOCK_POLARITY = 0b0;
  // Clock Phase
  int CLOCK_PHASE = 0b1;

  initSPI(BAUD_RATE, CLOCK_POLARITY, CLOCK_PHASE);

  initSensor(EIGHT_BIT);

  printf("hi!\n");

  digitalWrite(CS_PIN, 0);

  delay_millis(TIM15, 1000);

  printf("%f\n", readTemp());

  while (1)
  {
    /* Wait for ESP8266 to send a request.
    Requests take the form of '/REQ:<tag>\n', with TAG begin <= 10 characters.
    Therefore the request[] array must be able to contain 18 characters.
    */

    // Receive web request from the ESP
    char request[BUFF_LEN] = "                  "; // initialize to known value
    int charIndex = 0;

    // Keep going until you get end of line character
    while (inString(request, "\n") == -1)
    {
      // Wait for a complete request to be transmitted before processing
      while (!(USART->ISR & USART_ISR_RXNE))
        ;
      request[charIndex++] = readChar(USART);
    }

    int resolution = updateTempRes(request);

    digitalWrite(CS_PIN, 0);

    delay_millis(TIM15, 1000);

    togglePin(LED_PIN);

    char tempStatusStr[63];
    sprintf(tempStatusStr, "Temp: %f degrees C, at %d bit resolution", readTemp(), resolution);

    // finally, transmit the webpage over UART
    sendString(USART, webpageStart); // webpage header code
    sendString(USART, tempStr);

    sendString(USART, "<h2>Temperature Status</h2>");

    sendString(USART, "<p>");
    sendString(USART, tempStatusStr);
    sendString(USART, "</p>");

    sendString(USART, webpageEnd);
  }
}
