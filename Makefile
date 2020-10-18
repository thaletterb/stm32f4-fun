SRCS=*.c

LIB_DIR=lib
STM_PERIPH=STM32F4xx_DSP_StdPeriph_Lib_V1.8.0

CC=arm-none-eabi-gcc
OBJCOPY=arm-none-eabi-objcopy

CFLAGS = -g3 -O2 -Wall 
CFLAGS += -T$(LIB_DIR)/$(STM_PERIPH)/Project/STM32F4xx_StdPeriph_Templates/TrueSTUDIO/STM32F40_41xxx/STM32F417IG_FLASH.ld
CFLAGS += -mlittle-endian -mthumb -mcpu=cortex-m4 -mthumb-interwork
CFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16
CFLAGS += --specs=nosys.specs
CFLAGS += -DUSE_STDPERIPH_DRIVER
CFLAGS += -DSTM32F40_41xxx #Update this to match your board.
CFLAGS += -I.
CFLAGS += -I$(LIB_DIR)/$(STM_PERIPH)/Libraries/CMSIS/Include
CFLAGS += -I$(LIB_DIR)/$(STM_PERIPH)/Libraries/CMSIS/Device/ST/STM32F4xx/Include
CFLAGS += -I$(LIB_DIR)/$(STM_PERIPH)/Libraries/STM32F4xx_StdPeriph_Driver/inc
CFLAGS += -I$(LIB_DIR)/$(STM_PERIPH)/Project/STM32F4xx_StdPeriph_Templates

SRCS += $(LIB_DIR)/$(STM_PERIPH)/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_gpio.c
SRCS += $(LIB_DIR)/$(STM_PERIPH)/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rcc.c
SRCS += $(LIB_DIR)/$(STM_PERIPH)/Project/STM32F4xx_StdPeriph_Templates/system_stm32f4xx.c
SRCS += $(LIB_DIR)/$(STM_PERIPH)/Libraries/CMSIS/Device/ST/STM32F4xx/Source/Templates/TrueSTUDIO/startup_stm32f40_41xxx.s

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
