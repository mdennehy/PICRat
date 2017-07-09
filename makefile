#######################################################################
#	PICRat Makefile
#	Mark Dennehy, BA, BAI
#	12/97
#	
#######################################################################

PICRAT = ..

VPATH = src;lib

AS = /Progra~1/MPLAB/mpasm
LINK = /Progra~1/MPLAB/mplink
LIB = /Progra~1/MPLAB/mplib

FILES = USART		\
		Messages	\
		SelfTest	\
		CTree_A		\
		CTree_D		\
		CTree_C		\
		CTree_P		\
		CTree_MC	\
		CTree_T		\
		Main		\
		


.SUFFIXES :
.SUFFIXES : .O

#######################################################################

%.O : %.asm
	$(AS) /olib\\$(@F)  /q $(addprefix src\\,$(<F))

all: clean hex

hex: library
	cd bin;$(LINK) /m picrat.map /o picrat.hex /n 0 picrat.lkr ..\\lib\\picrat.lib ..\\lib\\main.o 

library: objects
	cd lib ; $(LIB) /c picrat.lib $(addsuffix .O,$(FILES))

objects: $(addsuffix .O,$(FILES))
	

clean :
	rm -f lib/*.O lib/*.lib src/*.ERR src/*.LST bin/*.map bin/*.hex bin/*.COD bin/*.ERR bin/*.LST 
