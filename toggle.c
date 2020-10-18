#include "stm32f4xx.h"
#include "stm32f4xx_rcc.h"
#include "stm32f4xx_gpio.h"

int main(void) {
    /* GPIOD, GPIOD Periph clock enable */
    RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOA, ENABLE);
    RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOD, ENABLE);

    /* Configure PD12, PD13, PD14 and PD15 in output pushpull mode */
    GPIO_InitTypeDef GPIO_InitStructure;
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_12 | GPIO_Pin_13 | GPIO_Pin_14 | GPIO_Pin_15;
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_OUT;
    GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_100MHz;
    GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_NOPULL;
    GPIO_Init(GPIOD, &GPIO_InitStructure);

    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0;
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN;
    GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
    GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_DOWN;
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(GPIOA, &GPIO_InitStructure);
 
    /* PD12,13,14,15 start on */
    GPIO_SetBits(GPIOD, GPIO_Pin_12);
    GPIO_SetBits(GPIOD, GPIO_Pin_13);
    GPIO_SetBits(GPIOD, GPIO_Pin_14);
    GPIO_SetBits(GPIOD, GPIO_Pin_15);
    volatile uint8_t button_pressed = 0;

    while (1) {
        if (GPIO_ReadInputDataBit(GPIOA, GPIO_Pin_0)) {
            if (!button_pressed) {
                button_pressed = 1;
                GPIO_ToggleBits(GPIOD, GPIO_Pin_12);
                GPIO_ToggleBits(GPIOD, GPIO_Pin_13);
                GPIO_ToggleBits(GPIOD, GPIO_Pin_14);
                GPIO_ToggleBits(GPIOD, GPIO_Pin_15);
            }
        } else {
            button_pressed = 0;
        }
    }
}
