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

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "main.h"

/////////////////////////////////////////////////////////////////
// Provided Constants and Functions
/////////////////////////////////////////////////////////////////

// Defining the web page in two chunks: everything before the current time, and everything after the current time
char *webpageStart = "<!DOCTYPE html><html><head><title>E155 Web Server Demo Webpage</title>\
	<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\
	</head>\
	<body><h1>E155 Web Server Demo Webpage</h1>";
char *ledStr = "<p>LED Control:</p><form action=\"ledon\"><input type=\"submit\" value=\"Turn the LED on!\"></form>\
	<form action=\"ledoff\"><input type=\"submit\" value=\"Turn the LED off!\"></form>";
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

int updateLEDStatus(char request[])
{
  int led_status = 0;
  // The request has been received. now process to determine whether to turn the LED on or off
  if (inString(request, "ledoff") == 1)
  {
    digitalWrite(LED_PIN, PIO_LOW);
    led_status = 0;
  }
  else if (inString(request, "ledon") == 1)
  {
    digitalWrite(LED_PIN, PIO_HIGH);
    led_status = 1;
  }

  return led_status;
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

  pinMode(PB3, GPIO_OUTPUT);

  RCC->APB2ENR |= (RCC_APB2ENR_TIM15EN);
  initTIM(TIM15);

  USART_TypeDef *USART = initUSART(USART1_ID, 125000);

  // TODO: Add SPI initialization code
  // Set four pins to CE, SCK, SDO, SDI
  // Described as MISO, MOSI, SCK, NSS on RM0394 Pg. 1306
  // Pins to set and AF are describes in page 53 of datasheet

  // pinMode(...,GPIO_ALT);
  pinMode(SDI_PIN, GPIO_ALT); // PA12
  pinMode(SDO_PIN, GPIO_ALT); // PA6
  pinMode(SCK_PIN, GPIO_ALT); // PA5

  // Chip select
  pinMode(CS_PIN, GPIO_OUTPUT); // PA8

  // Alternate Functions
  GPIOA->AFR[1] |= (0b0101 << GPIO_AFRH_AFSEL12_Pos); // SDI
  GPIOA->AFR[0] |= (0b0101 << GPIO_AFRL_AFSEL6_Pos);  // SDO
  GPIOA->AFR[0] |= (0b0101 << GPIO_AFRL_AFSEL5_Pos);  // SCK

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

    // TODO: Add SPI code here for reading temperature

    // Update string with current LED state

    int led_status = updateLEDStatus(request);

    char ledStatusStr[20];
    if (led_status == 1)
      sprintf(ledStatusStr, "LED is on!");
    else if (led_status == 0)
      sprintf(ledStatusStr, "LED is off!");

    // finally, transmit the webpage over UART
    sendString(USART, webpageStart); // webpage header code
    sendString(USART, ledStr);       // button for controlling LED

    sendString(USART, "<h2>LED Status</h2>");

    sendString(USART, "<p>");
    sendString(USART, ledStatusStr);
    sendString(USART, "</p>");

    sendString(USART, webpageEnd);
  }
}
