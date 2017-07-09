;--------------------LIBRARY SPECIFICATION-------------------
;
;	NAME :			CTree_T.asm
;
;	FUNCTIONS :		TimerCommand Tree
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
;	NAME :			TimerRoot
;
;	FUNCTION :		Root of Timer Command Tree
;	
;	NOTES :			
;
;------------------------------------------------------------
;	REVISION HISTORY :
;
;------------------------------------------------------------
TimerData			UDATA

tmpChar				RES	1

TimerRoot			CODE
TimerRoot
					GLOBAL	TimerRoot
					EXTERN	USART_getc
					EXTERN	USART_putc
					EXTERN	MainLoop

	PAGESEL	USART_getc
	call	USART_getc
	movwf	tmpChar

	xorlw	A'r'
	btfsc	STATUS,Z
	goto	TimerNode_T1
	xorlw	A'r'

	xorlw	A'w'
	btfsc	STATUS,Z
	goto	TimerNode_T2
	xorlw	A'w'

	xorlw	A's'
	btfsc	STATUS,Z
	goto	TimerNode_T3
	xorlw	A's'

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
TimerNode_T1
;	PAGESEL	USART_getc
;	call	USART_getc
;	movwf	tmpChar

;	xorlw	A' '
;	btfsc	STATUS,Z
;	goto	
;	xorlw	A' '

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
TimerNode_T2
;	PAGESEL	USART_getc
;	call	USART_getc
;	movwf	tmpChar

;	xorlw	A' '
;	btfsc	STATUS,Z
;	goto	
;	xorlw	A' '

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
TimerNode_T3
;	PAGESEL	USART_getc
;	call	USART_getc
;	movwf	tmpChar
;
;	xorlw	A' '
;	btfsc	STATUS,Z
;	goto	
;	xorlw	A' '

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
