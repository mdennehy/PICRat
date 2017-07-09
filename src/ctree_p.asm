;--------------------LIBRARY SPECIFICATION-------------------
;
;	NAME :			CTree_P.asm
;
;	FUNCTIONS :		PWM Command Tree
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
;	NAME :			PWMRoot
;
;	FUNCTION :		Root of PWM Command Tree
;	
;	NOTES :			
;
;------------------------------------------------------------
;	REVISION HISTORY :
;
;------------------------------------------------------------
PWMData				UDATA

tmpChar				RES	1

PWMRoot				CODE
PWMRoot
					GLOBAL	PWMRoot
					EXTERN	USART_getc
					EXTERN	USART_putc
					EXTERN	MainLoop

	PAGESEL	USART_getc
	call	USART_getc
	movwf	tmpChar

	xorlw	A'w'
	btfsc	STATUS,Z
	goto	PWMNode_P1
	xorlw	A'w'

	xorlw	A's'
	btfsc	STATUS,Z
	goto	PWMNode_P2
	xorlw	A's'

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
PWMNode_P1

	PAGESEL	USART_putc
	movlw	'P'
	call	USART_putc
	movlw	'1'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc
	movwf	tmpChar

	xorlw	A' '
	btfsc	STATUS,Z
	goto	
	xorlw	A' '

	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
PWMNode_P2

	PAGESEL	USART_putc
	movlw	'P'
	call	USART_putc
	movlw	'2'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc
	movwf	tmpChar

	xorlw	A' '
	btfsc	STATUS,Z
	goto	
	xorlw	A' '

	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
;	Error

	PAGESEL	MainLoop
	goto	MainLoop

	END
