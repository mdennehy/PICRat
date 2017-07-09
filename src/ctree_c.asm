;--------------------LIBRARY SPECIFICATION-------------------
;
;	NAME :			CTree_C.asm
;
;	FUNCTIONS :		Counter Command Tree
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
;	NAME :			CounterRoot
;
;	FUNCTION :		Root of Counter Command Tree
;	
;	NOTES :			
;
;------------------------------------------------------------
;	REVISION HISTORY :
;
;------------------------------------------------------------
CounterData			UDATA

tmp						RES	1
Counter_DisplayFormat	RES	1
Counter_DataFormat		RES	1
Counter_Data			RES	1

;------------------------------------------------------------
CounterRoot			CODE
CounterRoot
					GLOBAL	CounterRoot
					EXTERN	USART_getc
					EXTERN	USART_putc
					EXTERN	MainLoop

	PAGESEL	USART_getc
	call	USART_getc

	xorlw	A'r'
	btfsc	STATUS,Z
	goto	CounterNode_C1
	xorlw	A'r'

	xorlw	A'w'
	btfsc	STATUS,Z
	goto	CounterNode_C4
	xorlw	A'w'

	xorlw	A's'
	btfsc	STATUS,Z
	goto	CounterNode_C10

	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
CounterNode_C1
	PAGESEL	USART_putc
	movlw	'C'
	call	USART_putc
	movlw	'1'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	Counter_DataFormat
	movwf	Counter_DataFormat

	xorlw	A'd'
	btfsc	STATUS,Z
	goto	CounterNode_C2
	xorlw	A'd'

	xorlw	A'h'
	btfsc	STATUS,Z
	goto	CounterNode_C2

	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
CounterNode_C2
	PAGESEL	USART_putc
	movlw	'C'
	call	USART_putc
	movlw	'2'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc

	xorlw	A'\r'
	btfsc	STATUS,Z
	goto	CounterNode_C3

	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
CounterNode_C3
	PAGESEL	USART_putc
	movlw	'C'
	call	USART_putc
	movlw	'3'
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
CounterNode_C4
	PAGESEL	USART_putc
	movlw	'C'
	call	USART_putc
	movlw	'4'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	Counter_DataFormat
	movwf	Counter_DataFormat

	xorlw	A'd'
	btfsc	STATUS,Z
	goto	CounterNode_C5
	xorlw	A'd'

	xorlw	A'h'
	btfsc	STATUS,Z
	goto	CounterNode_C5

	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop	

;------------------------------------------------------------
CounterNode_C5
	PAGESEL	USART_putc
	movlw	'C'
	call	USART_putc
	movlw	'5'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc

	xorlw	A':'
	btfss	STATUS,Z
	goto	CounterNode_C5_err

	BANKSEL	Counter_DataFormat
	movf	Counter_DataFormat,W

	xorlw	A'd'
	btfsc	STATUS,Z
	goto	CounterNode_C7
	xorlw	A'd'

;xorlw	A'h'
;btfsc	STATUS,Z
;goto	CounterNode_C8


CounterNode_C5_err
	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
CounterNode_C6
	PAGESEL	USART_putc
	movlw	'C'
	call	USART_putc
	movlw	'6'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc

	addlw	-30				;If a number from 0..2
	movwf	tmp
	andlw	H'FC'
	btfss	STATUS,Z
	goto	CounterNode_C6_err

	movf	tmp,F
	btfsc	STATUS,Z
	goto 	C6_loop_2
C6_loop_1
	movlw	H'64'
	BANKSEL	Counter_Data
	addwf	Counter_Data,F
	decfsz	tmp,F
	goto	C6_loop_1
	
C6_loop_2
	PAGESEL	USART_getc
	call	USART_getc

	addlw	-30				;If a number from 0..9
	movwf	tmp
	andlw	H'F0'
	btfss	STATUS,Z
	goto	CounterNode_C6_err

	movf	tmp,F
	btfsc	STATUS,Z
	goto	C6_loop_4
	movlw	D'10'
C6_loop_3
	BANKSEL	Counter_Data
	addwf	Counter_Data,F
	decfsz	tmp,F
	goto	C6_loop_3

C6_loop_4
	PAGESEL	USART_getc
	call	USART_getc

	addlw	-30				;If a number from 0..9
	movwf	tmp
	andlw	H'F0'
	btfss	STATUS,Z
	goto	CounterNode_C6_err

	movf	tmp,W
	BANKSEL	Counter_Data
	addwf	Counter_Data,F


	PAGESEL	USART_getc
	call	USART_getc

	xorlw	A'\r'
	btfsc	STATUS,Z
	goto	CounterNode_C9
	
CounterNode_C6_err
	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
CounterNode_C7
	PAGESEL	USART_putc
	movlw	'C'
	call	USART_putc
	movlw	'7'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc

	addlw	H'C6'
	addlw	H'0A'
	btfsc	STATUS,C
	goto	C7_1

	addlw	H'C9'
	addlw	H'06'
	btfsc	STATUS,C
	goto	C7_1

	goto	CounterNode_C7_err

C7_1
	BANKSEL	Counter_Data
	movwf	Counter_Data
	swapf	Counter_Data,F

	PAGESEL	USART_getc
	call	USART_getc

	addlw	H'C6'
	addlw	H'0A'
	btfsc	STATUS,C
	goto	C7_2

	addlw	H'C9'
	addlw	H'06'
	btfsc	STATUS,C
	goto	C7_2

	goto	CounterNode_C7_err

C7_2
	BANKSEL	Counter_Data
	addwf	Counter_Data,F


	PAGESEL	USART_getc
	call	USART_getc

	xorlw	A'\r'
	btfsc	STATUS,Z
	goto	CounterNode_C9

CounterNode_C7_err
	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
CounterNode_C9
	PAGESEL	USART_putc
	movlw	'C'
	call	USART_putc
	movlw	'9'
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
CounterNode_C10
	PAGESEL	USART_putc
	movlw	'C'
	call	USART_putc
	movlw	'1'
	call	USART_putc
	movlw	'0'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc

	xorlw	A'\r'
	btfsc	STATUS,Z
	goto	CounterNode_C11

	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
CounterNode_C11
	PAGESEL	USART_putc
	movlw	'C'
	call	USART_putc
	movlw	'1'
	call	USART_putc
	movlw	'1'
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
