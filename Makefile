SRC 	:= ./
INC 	:= ./

CROSS_COMPILE 	?= arm-none-eabi-
#CROSS_COMPILE 	?=

CC 		= $(CROSS_COMPILE)gcc
LD 		= $(CROSS_COMPILE)ld
OBJCOPY	= $(CROSS_COMPILE)objcopy


#NOSTART = -nostartfiles
#CPU 	= cortex-m3
CPU 	= cortex-m0
#CFLAG	= -mcpu=$(CPU) -mthumb -Wall -fdump-rtl-expand
CFLAG	= -mcpu=$(CPU) -mthumb -Wall
LDFLAG  = -mcpu=$(CPU) -T ./stm32_flash.ld

SOURCE		= $(SRC)/%.c
INCLUDE 	= $(wildcard $(INC)/%.h)
OBJ			= startup_stm32f0xx.o system_stm32f0xx.o \
			  stm32f0xx_misc.o stm32f0xx_gpio.o stm32f0xx_rcc.o stm32f0xx_it.o main.o

OBJELF		= main
OBJBIN		= $(OBJELF).bin

all: $(OBJBIN)

$(OBJBIN): $(OBJELF)
	$(OBJCOPY) -O binary -S -R .comment	$< $@

$(OBJELF): $(OBJ)
	$(CC) $(LDFLAG) -I$(INC) $(OBJ) -o $(OBJELF)

startup_stm32f0xx.o: $(SRC)/startup_stm32f0xx.s
	$(CC) $(CFLAG) -I$(INC) -c $< -o $@ 

system_stm32f0xx.o: $(SRC)/system_stm32f0xx.c $(INC)/system_stm32f0xx.h
	$(CC) $(CFLAG) -I$(INC) -c $< -o $@ 

stm32f0xx_it.o: $(SRC)/stm32f0xx_it.c $(INC)/stm32f0xx_it.h
	$(CC) $(CFLAG) -I$(INC) -c $< -o $@ 

stm32f0xx_misc.o: $(SRC)/stm32f0xx_misc.c $(INC)/stm32f0xx_misc.h
	$(CC) $(CFLAG) -I$(INC) -c $< -o $@ 

stm32f0xx_gpio.o: $(SRC)/stm32f0xx_gpio.c $(INC)/stm32f0xx_gpio.h
	$(CC) $(CFLAG) -I$(INC) -c $< -o $@ 

stm32f0xx_rcc.o: $(SRC)/stm32f0xx_rcc.c $(INC)/stm32f0xx_rcc.h
	$(CC) $(CFLAG) -I$(INC) -c $< -o $@ 

main.o: $(SRC)/main.c
	$(CC) $(CFLAG) -I$(INC) -c $< -o $@ 

.PHONY: clean

clean:
	rm -rf *.o $(OBJELF) $(OBJBIN) *.expand



