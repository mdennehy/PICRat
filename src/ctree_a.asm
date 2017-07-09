;--------------------LIBRARY SPECIFICATION-------------------
;
;	NAME :			CTree_A.asm
;
;	FUNCTIONS :		Analog Command Tree
;	
;	NOTES :			
;
;------------------------------------------------------------
;	REVISION HISTORY :
;			9/1/98	First Draft
;
;------------------------------------------------------------

	ERRORLEVEL	0
	PROCESSOR	PIC16C74A
	LIST		b=4
	TITLE		"Demonstration PICRAT program"
	SUBTITLE	"Version 1.00"

	include		<p16c74a.inc>

;--------------------ROUTINE SPECIFICATION-------------------
;
;	NAME :			AnalogRoot
;
;	FUNCTION :		Root of Analog Command Tree
;	
;	NOTES :			
;
;------------------------------------------------------------
;	REVISION HISTORY :
;
;------------------------------------------------------------
AnalogData				UDATA

Analog_LineNo			RES	1
Analog_DisplayFormat	RES	1

						GLOBAL	Analog_LineNo
						GLOBAL	Analog_DisplayFormat

;------------------------------------------------------------
AnalogRoot			CODE
AnalogRoot
					GLOBAL		AnalogRoot
					EXTERN		USART_getc
					EXTERN		USART_putc
					EXTERN		MainLoop

	PAGESEL	USART_getc
	call	USART_getc

	xorlw	A'r'
	btfsc	STATUS,Z
	goto	AnalogNode_A1

	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop
	
;------------------------------------------------------------
AnalogNode_A1
	PAGESEL	USART_putc
	movlw	'A'
	call	USART_putc
	movlw	'1'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc
	PAGESEL	Analog_DisplayFormat
	movwf	Analog_DisplayFormat

	xorlw	A'%'
	btfsc	STATUS,Z
	goto	AnalogNode_A2
	xorlw	A'%'

	xorlw	A'd'
	btfsc	STATUS,Z
	goto	AnalogNode_A2

	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
AnalogNode_A2
	PAGESEL	USART_putc
	movlw	'A'
	call	USART_putc
	movlw	'2'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc

	xorlw	A'l'
	btfsc	STATUS,Z
	goto	AnalogNode_A3
	xorlw	A'l'

	xorlw	A'\r'
	btfsc	STATUS,Z
	goto	AnalogNode_A5

	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
AnalogNode_A3
	PAGESEL	USART_putc
	movlw	'A'
	call	USART_putc
	movlw	'3'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc
	PAGESEL	Analog_LineNo
	movwf	Analog_LineNo

	addlw	-30				;If a number from 0..7
	andlw	H'F8'
	btfsc	STATUS,Z
	goto	AnalogNode_A4

	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
AnalogNode_A4
	PAGESEL	USART_putc
	movlw	'A'
	call	USART_putc
	movlw	'4'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc

	xorlw	A'\r'
	btfsc	STATUS,Z
	goto	AnalogNode_A5

	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
AnalogNode_A5
	PAGESEL	USART_putc
	movlw	'A'
	call	USART_putc
	movlw	'5'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------

	END
