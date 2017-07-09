;--------------------LIBRARY SPECIFICATION-------------------
;
;	NAME :			CTree_D.asm
;
;	FUNCTIONS :		Digital Command Tree
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
;	NAME :			DigitalRoot
;
;	FUNCTION :		Root of Digital Command Tree
;	
;	NOTES :			
;
;------------------------------------------------------------
;	REVISION HISTORY :
;
;------------------------------------------------------------
DigitalData				UDATA

Digital_DisplayFormat	RES	1
Digital_DataFormat		RES	1
Digital_Data			RES	1
Digital_LineNo			RES	1
Digital_PortNo			RES	1
tmp						RES	1
tmp2					RES	1
tmp3					RES	1

						GLOBAL	Digital_DisplayFormat
						GLOBAL	Digital_DataFormat	
						GLOBAL	Digital_Data	
						GLOBAL	Digital_LineNo
						GLOBAL	Digital_PortNo

;------------------------------------------------------------
DigitalRoot				CODE
DigitalRoot
						GLOBAL	DigitalRoot
						EXTERN	USART_getc
						EXTERN	USART_putc
						EXTERN	USART_putHexByte
						EXTERN	USART_putHexNybble
						EXTERN	MainLoop


	movlw	0x00
	BANKSEL	Digital_DisplayFormat
	movwf	Digital_DisplayFormat
	BANKSEL	Digital_DataFormat
	movwf	Digital_DataFormat
	BANKSEL	Digital_Data
	movwf	Digital_Data
	BANKSEL	Digital_PortNo
	movwf	Digital_PortNo
	movlw	0xFF
	BANKSEL	Digital_LineNo
	movwf	Digital_LineNo

	PAGESEL	USART_putc
	movlw	A'D'
	call	USART_putc
	movlw	A'R'
	call	USART_putc
	movlw	A'\r'
	call	USART_putc
	movlw	A'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalNode_D1
	movf	tmp,w

	xorlw	A'r'
	btfsc	STATUS,Z
	goto	DigitalNode_D1
	xorlw	A'r'

	xorlw	A'w'
	btfsc	STATUS,Z
	goto	DigitalNode_D8
	xorlw	A'w'

	xorlw	A's'
	btfsc	STATUS,Z
	goto	DigitalNode_D16
	xorlw	A's'

	xorlw	A'c'
	btfsc	STATUS,Z
	goto	DigitalNode_D22
	xorlw	A'c'

	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
DigitalNode_D1
	PAGESEL	USART_putc
	movlw	'D'
	call	USART_putc
	movlw	'1'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W
	BANKSEL	Digital_DisplayFormat
	movwf	Digital_DisplayFormat

	xorlw	A'd'
	btfsc	STATUS,Z
	goto	DigitalNode_D2
	xorlw	A'd'

	xorlw	A'h'
	btfsc	STATUS,Z
	goto	DigitalNode_D2
	xorlw	A'h'

	xorlw	A'b'
	btfsc	STATUS,Z
	goto	DigitalNode_D2

	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
DigitalNode_D2
	PAGESEL	USART_putc
	movlw	'D'
	call	USART_putc
	movlw	'2'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	xorlw	A'p'
	btfsc	STATUS,Z
	goto	DigitalNode_D3

	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
DigitalNode_D3
	PAGESEL	USART_putc
	movlw	'D'
	call	USART_putc
	movlw	'3'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	addlw	-30				;If a number from 0..1
	BANKSEL	Digital_PortNo
	movwf	Digital_PortNo
	andlw	H'FE'
	btfsc	STATUS,Z
	goto	DigitalNode_D4

	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
DigitalNode_D4

	PAGESEL	USART_putc
	movlw	'D'
	call	USART_putc
	movlw	'4'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	xorlw	A'l'
	btfsc	STATUS,Z
	goto	DigitalNode_D6
	xorlw	A'l'

	xorlw	A'\r'
	btfsc	STATUS,Z
	goto	DigitalNode_D5

	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
DigitalNode_D5

	PAGESEL	USART_putc
	movlw	'D'
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
	PAGESEL	DigitalRoot

	BANKSEL	Digital_PortNo
	movf	Digital_PortNo,F
	btfss	STATUS,Z
	goto	D5_1

	;read port 0 (B)
	BANKSEL	PORTB
	movf	PORTB,W
	BANKSEL	tmp
	movwf	tmp
	goto D5_2
	
D5_1
	;read port 1 (D and E)
	BANKSEL	PORTE
	movf	PORTE,W
	BANKSEL	tmp
	movwf	tmp
	BANKSEL	PORTD
	movf	PORTD,W
	andlw	H'80'
	swapf	W,W
	BANKSEL	tmp
	iorwf	tmp,F

D5_2
	movlw	H'01'
	BANKSEL	Digital_LineNo
	addwf	Digital_LineNo,F
	btfsc	STATUS,Z
	goto	D5_4
	clrw
	bsf		STATUS,C

D5_3
	rlf		W,W
	decfsz	Digital_LineNo,F
	goto	D5_3

D5_4
	BANKSEL	tmp
	iorwf	tmp,F
	clrw

	BANKSEL	Digital_DisplayFormat
	movf	Digital_DisplayFormat,W
	xorlw	'h'
	btfsc	STATUS,Z
	goto	D5_5
	xorlw	'h'

	xorlw	'd'
	btfsc	STATUS,Z
	goto	D5_6
	xorlw	'd'

	xorlw	'b'
	btfsc	STATUS,Z
	goto	D5_7
	
	goto	D5_8

D5_5		;Hex Display
	PAGESEL	USART_putc
	movlw	'0'
	call	USART_putc
	movlw	'x'
	call	USART_putc
	BANKSEL	tmp
	movf	tmp,w
	call	USART_putHexByte
	
	PAGESEL	D5_8
	goto	D5_8

D5_6		;Decimal Display
	BANKSEL	tmp2
	clrf	tmp2
	movlw	0x64
D5_6a
	BANKSEL	tmp
	subwf	tmp,F
	btfss	STATUS,C
	goto	D5_6b
	BANKSEL	tmp2
	incf	tmp2,F
	goto	D5_6a
D5_6b
	BANKSEL	tmp
	addwf	tmp,F
	movlw	0x30
	BANKSEL	tmp2
	addwf	tmp2,F
	PAGESEL	USART_putc
	movf	tmp2,W
	call	USART_putc
	PAGESEL	DigitalRoot

	BANKSEL	tmp2
	clrf	tmp2
	movlw	0x0A
D5_6c
	BANKSEL	tmp
	subwf	tmp,F
	btfss	STATUS,C
	goto	D5_6d
	BANKSEL	tmp2
	incf	tmp2,F
	goto	D5_6c
D5_6d
	BANKSEL	tmp
	addwf	tmp,F
	movlw	0x30
	BANKSEL	tmp2
	addwf	tmp2,F
	PAGESEL	USART_putc
	movf	tmp2,W
	call	USART_putc

	BANKSEL	tmp
	movf	tmp,W
	addlw	0x30
	call	USART_putc
	PAGESEL	D5_8
	goto 	D5_8


D5_7		;Binary Display
	movlw	D'08'
	movwf	tmp2

D5_7a
	rlf		tmp,F
	btfsc	STATUS,C
	goto	D5_7b

	PAGESEL	USART_putc
	movlw	A'0'
	call	USART_putc
	PAGESEL	DigitalRoot
	BANKSEL	tmp2
	decfsz	tmp2,F
	goto	D5_7a
	goto	D5_8
	
D5_7b
	PAGESEL	USART_putc
	movlw	A'1'
	call	USART_putc
	PAGESEL	DigitalRoot
	BANKSEL	tmp2
	decfsz	tmp2,F
	goto	D5_7a

D5_8		;End of command
	PAGESEL	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
DigitalNode_D6
	PAGESEL	USART_putc
	movlw	'D'
	call	USART_putc
	movlw	'6'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	addlw	-30				;If a number from 0..7
	BANKSEL	Digital_LineNo
	movwf	Digital_LineNo
	andlw	H'F8'
	btfsc	STATUS,Z
	goto	DigitalNode_D7

	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
DigitalNode_D7
	PAGESEL	USART_putc
	movlw	'D'
	call	USART_putc
	movlw	'7'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	xorlw	A'\r'
	btfsc	STATUS,Z
	goto	DigitalNode_D5

	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop	

;------------------------------------------------------------
DigitalNode_D8
	PAGESEL	USART_putc
	movlw	'D'
	call	USART_putc
	movlw	'8'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W
	BANKSEL	Digital_DataFormat
	movwf	Digital_DataFormat

	xorlw	A'd'
	btfsc	STATUS,Z
	goto	DigitalNode_D9
	xorlw	A'd'

	xorlw	A'h'
	btfsc	STATUS,Z
	goto	DigitalNode_D9
	xorlw	A'h'

	xorlw	A'b'
	btfsc	STATUS,Z
	goto	DigitalNode_D9

	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop	

;------------------------------------------------------------
DigitalNode_D9
	PAGESEL	USART_putc
	movlw	'D'
	call	USART_putc
	movlw	'9'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	xorlw	A'p'
	btfsc	STATUS,Z
	goto	DigitalNode_D10

	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
DigitalNode_D10
	PAGESEL	USART_putc
	movlw	'D'
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
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	addlw	-30				;If a number from 0..1
	BANKSEL	Digital_PortNo
	movwf	Digital_PortNo
	andlw	H'FE'
	btfsc	STATUS,Z
	goto	DigitalNode_D11

	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
DigitalNode_D11
	PAGESEL	USART_putc
	movlw	'D'
	call	USART_putc
	movlw	'1'
	call	USART_putc
	movlw	'1'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	xorlw	A':'
	btfss	STATUS,Z
	goto	DigitalNode_D11_err

	BANKSEL	Digital_DataFormat
	movf	Digital_DataFormat,W

	xorlw	A'd'
	btfsc	STATUS,Z
	goto	DigitalNode_D12
	xorlw	A'd'

	xorlw	A'h'
	btfsc	STATUS,Z
	goto	DigitalNode_D13
	xorlw	A'h'

	xorlw	A'b'
	btfsc	STATUS,Z
	goto	DigitalNode_D14


DigitalNode_D11_err
	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
DigitalNode_D12
	PAGESEL	USART_putc
	movlw	'D'
	call	USART_putc
	movlw	'1'
	call	USART_putc
	movlw	'2'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	addlw	-30				;If a number from 0..2
	movwf	tmp
	andlw	H'FC'
	btfss	STATUS,Z
	goto	DigitalNode_D12_err

	movf	tmp,F
	btfsc	STATUS,Z
	goto 	D12_loop_2
D12_loop_1
	movlw	H'64'
	BANKSEL	Digital_Data
	addwf	Digital_Data,F
	decfsz	tmp,F
	goto	D12_loop_1
	
D12_loop_2
	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	addlw	-30				;If a number from 0..9
	movwf	tmp
	andlw	H'F0'
	btfss	STATUS,Z
	goto	DigitalNode_D12_err

	movf	tmp,F
	btfsc	STATUS,Z
	goto	D12_loop_4
	movlw	D'10'
D12_loop_3
	BANKSEL	Digital_Data
	addwf	Digital_Data,F
	decfsz	tmp,F
	goto	D12_loop_3

D12_loop_4
	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	addlw	-30				;If a number from 0..9
	movwf	tmp
	andlw	H'F0'
	btfss	STATUS,Z
	goto	DigitalNode_D12_err

	movf	tmp,W
	BANKSEL	Digital_Data
	addwf	Digital_Data,F


	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	xorlw	A'\r'
	btfsc	STATUS,Z
	goto	DigitalNode_D15
	
DigitalNode_D12_err
	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
DigitalNode_D13
	PAGESEL	USART_putc
	movlw	'D'
	call	USART_putc
	movlw	'1'
	call	USART_putc
	movlw	'3'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	addlw	H'C6'
	addlw	H'0A'
	btfsc	STATUS,C
	goto	D13_1

	addlw	H'C9'
	addlw	H'06'
	btfsc	STATUS,C
	goto	D13_0b

	goto	DigitalNode_D13_err

D13_0b
	addlw	0x0A
D13_1
	BANKSEL	Digital_Data
	movwf	Digital_Data
	swapf	Digital_Data,F

	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	addlw	H'C6'
	addlw	H'0A'
	btfsc	STATUS,C
	goto	D13_2

	addlw	H'C9'
	addlw	H'06'
	btfsc	STATUS,C
	goto	D13_1b

	goto	DigitalNode_D13_err

D13_1b
	addlw	0x0A
D13_2
	BANKSEL	Digital_Data
	addwf	Digital_Data,F


	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	xorlw	A'\r'
	btfsc	STATUS,Z
	goto	DigitalNode_D15

DigitalNode_D13_err
	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
DigitalNode_D14
	PAGESEL	USART_putc
	movlw	'D'
	call	USART_putc
	movlw	'1'
	call	USART_putc
	movlw	'4'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	movlw	0x08
	BANKSEL	tmp2
	movwf	tmp2

D14_loop_1
	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	addlw	-0x30				;If a number from 0..1
	BANKSEL	Digital_Data
	bcf		STATUS,C
	rlf		Digital_Data,F
	addwf	Digital_Data,F
	andlw	H'FE'
	btfss	STATUS,Z
	goto	DigitalNode_D14_err

	BANKSEL	tmp2
	decfsz	tmp2,F
	goto	D14_loop_1

	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	xorlw	A'\r'
	btfsc	STATUS,Z
	goto	DigitalNode_D15

DigitalNode_D14_err
	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
DigitalNode_D15
	PAGESEL	USART_putc
	movlw	'D'
	call	USART_putc
	movlw	'1'
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

	PAGESEL	DigitalRoot
	movlw	0x01
	addwf	Digital_LineNo,W
	btfss	STATUS,C
	goto	D15_2

	movf	Digital_Data,W
	andlw	0x01
D15_1
	decfsz	Digital_LineNo,F
	goto	D15_1b
	goto	D15_2
D15_1b
	rlf		W,W
	goto	D15_1

D15_2
	movf	Digital_PortNo,F
	btfss	STATUS,Z
	goto	D15_3

	BANKSEL	Digital_Data
	movf	Digital_Data,W
	BANKSEL	PORTB
	movwf	PORTB
	goto	D15_4

D15_3
	movf	Digital_Data,W
	andlw	0x07
	movwf	PORTE
	movf	Digital_Data,W
	andlw	0x08
	btfsc	STATUS,Z
	goto	D15_3b
	bsf		PORTD,7
	goto	D15_4
D15_3b
	bcf		PORTD,7

D15_4
	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
DigitalNode_D16
	PAGESEL	USART_putc
	movlw	'D'
	call	USART_putc
	movlw	'1'
	call	USART_putc
	movlw	'6'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	xorlw	A'p'
	btfsc	STATUS,Z
	goto	DigitalNode_D17

	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
DigitalNode_D17
	PAGESEL	USART_putc
	movlw	'D'
	call	USART_putc
	movlw	'1'
	call	USART_putc
	movlw	'7'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	addlw	-30				;If a number from 0..1
	BANKSEL	Digital_PortNo
	movwf	Digital_PortNo
	andlw	H'FE'
	btfsc	STATUS,Z
	goto	DigitalNode_D18

	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
DigitalNode_D18

	PAGESEL	USART_putc
	movlw	'D'
	call	USART_putc
	movlw	'1'
	call	USART_putc
	movlw	'8'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	xorlw	A'l'
	btfsc	STATUS,Z
	goto	DigitalNode_D20
	xorlw	A'l'

	xorlw	A'\r'
	btfsc	STATUS,Z
	goto	DigitalNode_D19

	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
DigitalNode_D19
	PAGESEL	USART_putc
	movlw	'D'
	call	USART_putc
	movlw	'1'
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

	PAGESEL	DigitalRoot
	movf	Digital_PortNo,F
	btfss	STATUS,Z
	goto	D19_

	
	
	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
DigitalNode_D20
	PAGESEL	USART_putc
	movlw	'D'
	call	USART_putc
	movlw	'2'
	call	USART_putc
	movlw	'0'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	addlw	-30				;If a number from 0..7
	BANKSEL	Digital_LineNo
	movwf	Digital_LineNo
	andlw	H'F8'
	btfsc	STATUS,Z
	goto	DigitalNode_D21

	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
DigitalNode_D21

	PAGESEL	USART_putc
	movlw	'D'
	call	USART_putc
	movlw	'2'
	call	USART_putc
	movlw	'1'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	xorlw	A'\r'
	btfsc	STATUS,Z
	goto	DigitalNode_D19

	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
DigitalNode_D22
	PAGESEL	USART_putc
	movlw	'D'
	call	USART_putc
	movlw	'2'
	call	USART_putc
	movlw	'2'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W
	BANKSEL	Digital_DataFormat
	movwf	Digital_DataFormat

	xorlw	A'd'
	btfsc	STATUS,Z
	goto	DigitalNode_D23
	xorlw	A'd'

	xorlw	A'h'
	btfsc	STATUS,Z
	goto	DigitalNode_D23
	xorlw	A'h'

	xorlw	A'b'
	btfsc	STATUS,Z
	goto	DigitalNode_D23

	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop	

;------------------------------------------------------------
DigitalNode_D23
	PAGESEL	USART_putc
	movlw	'D'
	call	USART_putc
	movlw	'2'
	call	USART_putc
	movlw	'3'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	xorlw	A'p'
	btfsc	STATUS,Z
	goto	DigitalNode_D24

	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
DigitalNode_D24
	PAGESEL	USART_putc
	movlw	'D'
	call	USART_putc
	movlw	'2'
	call	USART_putc
	movlw	'4'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	addlw	-30				;If a number from 0..1
	BANKSEL	Digital_PortNo
	movwf	Digital_PortNo
	andlw	H'FE'
	btfsc	STATUS,Z
	goto	DigitalNode_D25

	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
DigitalNode_D25 
	PAGESEL	USART_putc
	movlw	'D'
	call	USART_putc
	movlw	'2'
	call	USART_putc
	movlw	'5'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	xorlw	A':'
	btfss	STATUS,Z
	goto	DigitalNode_D25_err

	BANKSEL	Digital_DataFormat
	movf	Digital_DataFormat,W

	xorlw	A'd'
	btfsc	STATUS,Z
	goto	DigitalNode_D26
	xorlw	A'd'

	xorlw	A'h'
	btfsc	STATUS,Z
	goto	DigitalNode_D27
	xorlw	A'h'

	xorlw	A'b'
	btfsc	STATUS,Z
	goto	DigitalNode_D28


DigitalNode_D25_err
	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
DigitalNode_D26
	PAGESEL	USART_putc
	movlw	'D'
	call	USART_putc
	movlw	'2'
	call	USART_putc
	movlw	'6'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	addlw	-30				;If a number from 0..2
	movwf	tmp
	andlw	H'FC'
	btfss	STATUS,Z
	goto	DigitalNode_D26_err

	movf	tmp,F
	btfsc	STATUS,Z
	goto 	D26_loop_2
D26_loop_1
	movlw	H'64'
	BANKSEL	Digital_Data
	addwf	Digital_Data,F
	decfsz	tmp,F
	goto	D26_loop_1
	
D26_loop_2
	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	addlw	-30				;If a number from 0..9
	movwf	tmp
	andlw	H'F0'
	btfss	STATUS,Z
	goto	DigitalNode_D26_err

	movf	tmp,F
	btfsc	STATUS,Z
	goto	D26_loop_4
	movlw	D'10'
D26_loop_3
	BANKSEL	Digital_Data
	addwf	Digital_Data,F
	decfsz	tmp,F
	goto	D26_loop_3

D26_loop_4
	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	addlw	-30				;If a number from 0..9
	movwf	tmp
	andlw	H'F0'
	btfss	STATUS,Z
	goto	DigitalNode_D26_err

	movf	tmp,W
	BANKSEL	Digital_Data
	addwf	Digital_Data,F


	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	xorlw	A'\r'
	btfsc	STATUS,Z
	goto	DigitalNode_D29
	
DigitalNode_D26_err
	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
DigitalNode_D27
	PAGESEL	USART_putc
	movlw	'D'
	call	USART_putc
	movlw	'2'
	call	USART_putc
	movlw	'7'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	addlw	H'C6'
	addlw	H'0A'
	btfsc	STATUS,C
	goto	D27_1

	addlw	H'C9'
	addlw	H'06'
	btfsc	STATUS,C
	goto	D27_1

	goto	DigitalNode_D27_err

D27_1
	BANKSEL	Digital_Data
	movwf	Digital_Data
	swapf	Digital_Data,F

	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	addlw	H'C6'
	addlw	H'0A'
	btfsc	STATUS,C
	goto	D27_2

	addlw	H'C9'
	addlw	H'06'
	btfsc	STATUS,C
	goto	D27_2

	goto	DigitalNode_D27_err

D27_2
	BANKSEL	Digital_Data
	addwf	Digital_Data,F


	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	xorlw	A'\r'
	btfsc	STATUS,Z
	goto	DigitalNode_D29

DigitalNode_D27_err
	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
DigitalNode_D28
	PAGESEL	USART_putc
	movlw	'D'
	call	USART_putc
	movlw	'2'
	call	USART_putc
	movlw	'8'
	call	USART_putc
	movlw	'\r'
	call	USART_putc
	movlw	'\n'
	call	USART_putc

	movlw	08
	BANKSEL	tmp2
	movwf	tmp2

D28_loop_1
	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	addlw	-30				;If a number from 0..1
	BANKSEL	tmp
	rlf		tmp,F
	addwf	tmp,F
	andlw	H'FE'
	btfss	STATUS,Z
	goto	DigitalNode_D28_err
	BANKSEL	tmp2
	decfsz	tmp2,F
	goto	D28_loop_1

	PAGESEL	USART_getc
	call	USART_getc
	BANKSEL	tmp
	movwf	tmp
	PAGESEL	DigitalRoot
	movf	tmp,W

	xorlw	A'\r'
	btfsc	STATUS,Z
	goto	DigitalNode_D29

DigitalNode_D28_err
	PAGESEL	USART_putc
	movlw	'*'
	call	USART_putc

	PAGESEL	MainLoop
	goto	MainLoop

;------------------------------------------------------------
DigitalNode_D29 
	PAGESEL	USART_putc
	movlw	'D'
	call	USART_putc
	movlw	'2'
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
	END
