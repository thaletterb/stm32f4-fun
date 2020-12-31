#include "FreeRTOS.h"

#include "SystemTasks.h"

#include "stm32f4xx.h"
#include "stm32f4xx_rcc.h"
#include "stm32f4xx_gpio.h"


/**
 *  
 * DEFINITIONS 
 * 
 */

#define NUM_SYSTEM_TASKS	2U

typedef struct
{
	TaskFunction_t pvTaskCode;
	const char * const pcName;
	unsigned short usStackDepth;
	void *pvParameters;
	UBaseType_t uxPriority;
	TaskHandle_t *pxCreatedTask;
} taskParams_S;

/**
 *  
 * PRIVATE DATA 
 * 
 */
static void vBlinkTask(void *param)
{
    for(;;)
    {
        /* PD12,13,14,15 Toggle */
        GPIO_ToggleBits(GPIOD, GPIO_Pin_12);
        GPIO_ToggleBits(GPIOD, GPIO_Pin_14);

        vTaskDelay(1000);
    }
}

static void vBlinkTask2(void *param)
{
    for(;;)
    {
        /* PD12,13,14,15 Toggle */
        GPIO_ToggleBits(GPIOD, GPIO_Pin_13);
        GPIO_ToggleBits(GPIOD, GPIO_Pin_15);

        vTaskDelay(500);
    }
}

static taskParams_S systemTasks[NUM_SYSTEM_TASKS] = 
{
    {vBlinkTask, "Blink", configMINIMAL_STACK_SIZE, ( void * ) NULL, tskIDLE_PRIORITY, NULL},
    {vBlinkTask2, "Blink2", configMINIMAL_STACK_SIZE, ( void * ) NULL, tskIDLE_PRIORITY, NULL},
};

/**
 *  
 * PUBLIC FUNCTIONS 
 * 
 */
void SystemTasks_startAll(void)
{
    for(int i=0; i<NUM_SYSTEM_TASKS; i++)
    {
        taskParams_S currentTask = systemTasks[i];
        xTaskCreate(currentTask.pvTaskCode, currentTask.pcName, currentTask.usStackDepth, currentTask.pvParameters, currentTask.uxPriority, currentTask.pxCreatedTask);    
    }
}
