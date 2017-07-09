;--------------------LIBRARY SPECIFICATION-------------------
;
;	NAME :			CTree_MC.asm
;
;	FUNCTIONS :		Motor Control Command Tree
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
;	NAME :			MotorControlRoot
;
;	FUNCTION :		Root of Motor Control Command Tree
;	
;	NOTES :			
;
;------------------------------------------------------------
;	REVISION HISTORY :
;
;------------------------------------------------------------
MotorControlData	UDATA

tmpChar				RES	1

MotorControlRoot	CODE
MotorControlRoot
					GLOBAL	MotorControlRoot
					EXTERN	USART_getc
					EXTERN	USART_putc
					EXTERN	MainLoop

	PAGESEL	USART_getc
	call	USART_getc
	movwf	tmpChar

	xorlw	A'w'
	btfsc	STATUS,Z
	goto	MotorControlNode_MC1
	xorlw	A'w'

	xorlw	A'r'
	btfsc	STATUS,Z
	goto	MotorControlNode_MC2
	xorlw	A'r'

	xorlw	A's'
	btfsc	STATUS,Z
	goto	MotorControlNode_MC3
	xorlw	A's'

	PAGESEL	MainLoop
	goto	MainLoop


;------------------------------------------------------------
MotorControlNode_MC1
;	PAGESEL	USART_getc
;	call	USART_getc
;	movwf	tmpChar

;	xorlw	A' '
;	btfsc	STATUS,Z
;	goto	
;	xorlw	A' '
	PAGESEL	USART_putc
	movlw	'M'
	call	USART_putc
	movlw	'C'
	call	USART_putc
	movlw	'1'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
MotorControlNode_MC2
;	PAGESEL	USART_getc
;	call	USART_getc
;	movwf	tmpChar

;	xorlw	A' '
;	btfsc	STATUS,Z
;	goto	
;	xorlw	A' '

	PAGESEL	USART_putc
	movlw	'M'
	call	USART_putc
	movlw	'C'
	call	USART_putc
	movlw	'2'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
MotorControlNode_MC3
;	PAGESEL	USART_getc
;	call	USART_getc
;	movwf	tmpChar

;	xorlw	A' '
;	btfsc	STATUS,Z
;	goto	
;	xorlw	A' '

	PAGESEL	USART_putc
	movlw	'M'
	call	USART_putc
	movlw	'C'
	call	USART_putc
	movlw	'3'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop
	
;------------------------------------------------------------
;	Error

	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

	END
