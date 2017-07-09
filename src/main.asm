;------------------------------------------------------------
;
;	Demonstration PICRAT program.
;
;------------------------------------------------------------
;	REVISION HISTORY :
;	
;		13/10/97	First draft, preliminary modularisation
;					of code.
;
;------------------------------------------------------------

	ERRORLEVEL	0
	PROCESSOR	PIC16C74A
	LIST		b=4
	__CONFIG	_BODEN_OFF & _CP_OFF & _PWRTE_OFF & _WDT_OFF & _XT_OSC
	TITLE		"Demonstration PICRAT program"
	SUBTITLE	"Version 1.00"

	include		<p16c74a.inc>

;------------------------------------------------------------
;	Context Saving registers

CONTEXT		UDATA	0x20

int_w		RES	1
int_status	RES	1
int_pclath	RES	1
int_fsr		RES	1

CONTEXT2	UDATA	0xa0

int_w2		RES	1		;Dummy Register


;------------------------------------------------------------
;	Variables used in Main Loop
Main				UDATA

tmpChar			RES	1


;------------------------------------------------------------
;
;	NAME :			RESET_VECTOR
;
;	FUNCTION :		Executes reset interrupt service routine
;	
;------------------------------------------------------------

RESET_VECTOR		CODE	0000
RESET_VECTOR
					GLOBAL	RESET_VECTOR

	PAGESEL	reset_isr
	goto	reset_isr


;--------------------ROUTINE SPECIFICATION-------------------
;
;	NAME :			INTERRUPT_VECTOR
;
;	FUNCTION :		Contect saving, correct ISR selection
;	
;	NOTES :			Saves W, STATUS, PCLATH as per ex.14-1
;					in datasheet
;
;------------------------------------------------------------
;	REVISION HISTORY :
;
;------------------------------------------------------------

INTERRUPT_VECTOR	CODE	0004
INTERRUPT_VECTOR
					GLOBAL	INTERRUPT_VECTOR

					EXTERN	USART_Tx_isr
					EXTERN	USART_Rx_isr

;INTERRUPT_VECTOR
;
;	Save the W,STATUS,PCLATH and FSR registers,

	movwf	int_w
	swapf	STATUS,W
	clrf	STATUS
	movwf	int_status
	movf	PCLATH,W
	movwf	int_pclath
	movf	FSR,W
	movwf	int_fsr

;	Check to see what caused the interrupt,
;		Byte received ?

		BANKSEL	PIR1
		PAGESEL	USART_Rx_isr
		btfsc	PIR1,RCIF

;			Jump to USART Rx ISR

			call	USART_Rx_isr

;		Ready to transmit byte ?

		BANKSEL	PIR1
		PAGESEL	USART_Tx_isr
		btfsc	PIR1,TXIF
		
;			Jump to USART Tx ISR

			call	USART_Tx_isr
			
;		Unknown interrupt ?
;			Jump to exception handler

;			PAGESEL	Exception
;			call	Exception

;	Restore registers and return from interrupt.

	clrf	STATUS
	movf	int_fsr,W
	movwf	FSR
	movf	int_pclath,W
	movwf	PCLATH
	swapf	int_status,W
	movwf	STATUS
	swapf	int_w,F
	swapf	int_w,W

	retfie


;--------------------ROUTINE SPECIFICATION-------------------
;
;	NAME :			Exception
;
;	FUNCTION :		Called when an unhandled interrupt 
;					condition occours.
;	
;	NOTES :			
;
;------------------------------------------------------------
;	REVISION HISTORY :
;
;------------------------------------------------------------


;EXCEPTION
;	Endless loop

Exception	CODE
Exception

	goto	Exception



;--------------------ROUTINE SPECIFICATION-------------------
;
;	NAME :			reset_isr
;
;	FUNCTION :		Reset Interrupt service routine
;					Determines correct action to perform
;					on startup.
;	
;	NOTES :			
;
;------------------------------------------------------------
;	REVISION HISTORY :
;
;------------------------------------------------------------

reset_isr			CODE
reset_isr
					GLOBAL	reset_isr

					EXTERN	MemoryTest
					EXTERN	USART_init
					EXTERN	USART_puts
					EXTERN	USART_putc
					EXTERN	USART_hi_msg_tmp
					EXTERN	USART_lo_msg_tmp
					EXTERN	Startup_screen
;					EXTERN	LCD_Initialise
;					EXTERN	LCD_PutChar
					EXTERN	USART_getc

	PAGESEL	MemoryTest
	call	MemoryTest

	PAGESEL	USART_init
	call	USART_init

;	PAGESEL	LCD_Initialise
;	call	LCD_Initialise

	PAGESEL	USART_putc
	movlw	A'.'
	call	USART_putc
	movlw	A'.'
	call	USART_putc
	movlw	A'.'
	call	USART_putc
	movlw	A'\r'
	call	USART_putc
	movlw	A'\n'
	call	USART_putc

;	PAGESEL	LCD_PutChar
;	movlw	A'T'
;	call	LCD_PutChar
;	movlw	A'e'
;	call	LCD_PutChar
;	movlw	A's'
;	call	LCD_PutChar
;	movlw	A't'
;	call	LCD_PutChar

;	Enable perihiperal interrupts

	BANKSEL	INTCON
	bsf		INTCON,PEIE

;	Enable all interrupts
	bsf		INTCON,GIE

;	Print out startup message
	PAGESEL	USART_puts
	movlw	high	Startup_screen
	movwf	USART_hi_msg_tmp
	movlw	low		Startup_screen
	movwf	USART_lo_msg_tmp
	call	USART_puts

	bcf		OPTION_REG,7
	BANKSEL	PORTB
	clrf	PORTB
	BANKSEL	TRISB
	movlw	0x00
	movwf	TRISB

	BANKSEL	PORTD
	clrf	PORTD
	BANKSEL	TRISD
	movlw	0x7F
	movwf	TRISD

	BANKSEL	PORTE
	clrf	PORTE
	BANKSEL	TRISE
	movlw	0x07
	movwf	TRISE

	PAGESEL	MainLoop
	call	MainLoop

	
;--------------------ROUTINE SPECIFICATION-------------------
;
;	NAME :			MainLoop	
;
;	FUNCTION :		Main Control Interpreter
;	
;	NOTES :			A Finite State Machine
;
;------------------------------------------------------------
;	REVISION HISTORY :
;				9/1/98	First Draft
;------------------------------------------------------------

MainLoop			CODE
MainLoop
					GLOBAL	MainLoop
					EXTERN	USART_getc
					EXTERN	USART_putc
					EXTERN	AnalogRoot
					ExTERN	DigitalRoot
					EXTERN	CounterRoot
					EXTERN	PWMRoot
					EXTERN	MotorControlRoot
					EXTERN	TimerRoot

	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmpChar
	movwf	tmpChar
	PAGESEL	MainLoop
	movf	tmpChar,W
	xorlw	A'.'
	btfss	STATUS,Z
	goto	MainLoop
	
;------------------------------------------------------------

ServiceSelect
	PAGESEL	USART_putc
	movlw	'-'
	call	USART_putc
	movlw	'-'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc
	movwf	tmpChar

	PAGESEL	AnalogRoot
	movf	tmpChar,W
	xorlw	A'a'
	btfsc	STATUS,Z
	goto	AnalogRoot

	PAGESEL	DigitalRoot
	movf	tmpChar,W
	xorlw	A'd'
	btfsc	STATUS,Z
	goto	DigitalRoot

	PAGESEL	DigitalRoot
	movf	tmpChar,W
	xorlw	A'c'
	btfsc	STATUS,Z
	goto	CounterRoot

	PAGESEL	PWMRoot
	movf	tmpChar,W
	xorlw	A'p'
	btfsc	STATUS,Z
	goto	PWMRoot

	PAGESEL	MotorControlRoot
	movf	tmpChar,W
	xorlw	A'm'
	btfsc	STATUS,Z
	goto	MotorControlRoot

	PAGESEL	TimerRoot
	movf	tmpChar,W
	xorlw	A't'
	btfsc	STATUS,Z
	goto	TimerRoot

;------------------------------------------------------------
;	Error

	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	goto	MainLoop




	END
