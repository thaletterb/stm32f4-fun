# Compiler Common
CC=arm-none-eabi-gcc
OBJCOPY=arm-none-eabi-objcopy

CFLAGS = -g3 -O2 -Wall 
CFLAGS += -mlittle-endian -mthumb -mcpu=cortex-m4 -mthumb-interwork
CFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16

# Common Libs
LIB_DIR=lib

# Conditional Compilation (FreeRTOS/STD_PERIPHERAL_LIB)
FREE_RTOS_VER=FreeRTOSv9.0.0
FREE_RTOS_SOURCE_DIR=$(LIB_DIR)/$(FREE_RTOS_VER)/FreeRTOS/Source
FREE_RTOS_ARCH_DIR=$(FREE_RTOS_SOURCE_DIR)/portable/GCC/ARM_CM4F

FREERTOS_SRCS = $(FREE_RTOS_SOURCE_DIR)/tasks.c
FREERTOS_SRCS += $(FREE_RTOS_SOURCE_DIR)/queue.c
FREERTOS_SRCS += $(FREE_RTOS_SOURCE_DIR)/list.c
FREERTOS_SRCS += $(FREE_RTOS_SOURCE_DIR)/portable/MemMang/heap_4.c
FREERTOS_SRCS += $(FREE_RTOS_ARCH_DIR)/port.c

FREERTOS_INCS = $(FREE_RTOS_SOURCE_DIR)/include
FREERTOS_INCS += -I$(FREE_RTOS_SOURCE_DIR)/portable/GCC/ARM_CM4F

# Linker (Use this for now)
LINKER_SCRIPT=lib/STM32F4xx_DSP_StdPeriph_Lib_V1.8.0/Project/STM32F4xx_StdPeriph_Templates/TrueSTUDIO/STM32F40_41xxx/STM32F417IG_FLASH.ld

STM_PERIPH=STM32F4xx_DSP_StdPeriph_Lib_V1.8.0

# Compiler Flags
CFLAGS += -T$(LINKER_SCRIPT)
CFLAGS += --specs=nosys.specs
CFLAGS += -DUSE_STDPERIPH_DRIVER
CFLAGS += -DSTM32F40_41xxx #Update this to match your board.
# Includes
CFLAGS += -I.
CFLAGS += -I$(LIB_DIR)/$(STM_PERIPH)/Libraries/CMSIS/Include
CFLAGS += -I$(LIB_DIR)/$(STM_PERIPH)/Libraries/CMSIS/Device/ST/STM32F4xx/Include
CFLAGS += -I$(LIB_DIR)/$(STM_PERIPH)/Libraries/STM32F4xx_StdPeriph_Driver/inc
CFLAGS += -I$(LIB_DIR)/$(STM_PERIPH)/Project/STM32F4xx_StdPeriph_Templates
CFLAGS += -I$(FREERTOS_INCS)

# Sources
SRCS=*.c
SRCS += $(LIB_DIR)/$(STM_PERIPH)/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_gpio.c
SRCS += $(LIB_DIR)/$(STM_PERIPH)/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rcc.c
SRCS += $(LIB_DIR)/$(STM_PERIPH)/Project/STM32F4xx_StdPeriph_Templates/system_stm32f4xx.c
SRCS += $(LIB_DIR)/$(STM_PERIPH)/Libraries/CMSIS/Device/ST/STM32F4xx/Source/Templates/TrueSTUDIO/startup_stm32f40_41xxx.s
SRCS += $(FREE_RTOS_SOURCE_DIR)/tasks.c
SRCS += $(FREE_RTOS_SOURCE_DIR)/queue.c
SRCS += $(FREE_RTOS_SOURCE_DIR)/list.c
SRCS += $(FREE_RTOS_SOURCE_DIR)/portable/MemMang/heap_4.c
SRCS += $(FREE_RTOS_ARCH_DIR)/port.c
  
.PHONY: toggle

all: toggle

toggle: toggle.elf

toggle.elf: $(SRCS)
	    $(CC) $(CFLAGS) $^ -o $@ 
	    $(OBJCOPY) -O binary toggle.elf toggle.bin

flash: toggle
	st-flash write toggle.bin 0x8000000

clean:
	rm -f toggle.elf toggle.bin
