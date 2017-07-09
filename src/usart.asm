;--------------------LIBRARY SPECIFICATION-------------------
;
;	NAME :			Serial Communications Library
;
;	FUNCTIONS :		USART_init
;					USART_TxISR
;					USART_RxISR
;					USART_putc
;					USART_getc
;					USART_puts
;					USART_gets
;	
;	REQUIRES :		
;
;	NOTES :			
;
;------------------------------------------------------------
;	REVISION HISTORY :
;		13/10/97		First Draft
;
;------------------------------------------------------------

	ERRORLEVEL	0
	PROCESSOR	PIC16C74A
	LIST		b=4
	TITLE		"PICRAT USART Messages"
	SUBTITLE	"Version 1.00"

	include		<p16c74a.inc>
	include		<vt100.inc>

;------------------------------------------------------------



	#define	ClkFreq		4000000		;Main clock frequency in Hertz
	#define baudrate	D'25'		;9600 Baud (from p102, datasheet)
	#define TXSTA_INIT	B'00100000' ;Transmit Status and Control Register setup
									;Asynch. 8-bit low-speed setup.
	#define	RCSTA_INIT	B'10010000' ;Recieve Status and Control Register setup
									;8-bit Asynch. mode
	#define	TxB_Max		D'32'		;Size of Tx Buffer - must be a power of 2 due to
									;pointer updating mechanism
	#define	RxB_Max		D'32'		;Size of Rx Buffer - must be a power of 2 due to
									;pointer updating mechanism


USART_POINTERS	UDATA
TxB_Head		RES	1
TxB_Tail		RES	1
TxB_FreeCount	RES	1

RxB_Head		RES	1
RxB_Tail		RES	1
RxB_FreeCount	RES	1

USART_TxB		UDATA
TxBuffer		RES	TxB_Max

USART_RxB		UDATA
RxBuffer		RES	RxB_Max


USART_TEMP		UDATA
tmp				RES	1
tmp2			RES	1
tmp3			RES	1
tmp4			RES	1
temp			RES	1
tmpchar			RES 1


;--------------------ROUTINE SPECIFICATION-------------------
;
;	NAME :			USART_init
;
;	FUNCTION :		Initialises USART port for serial comms
;	
;	INPUTS :		None
;
;	OUTPUTS :		None
;	
;	CALLS :			
;
;	CALLED BY :		
;	
;	NOTES :			
;
;------------------------------------------------------------
;	REVISION HISTORY :
;		14/10/97		First relocatable draft
;
;------------------------------------------------------------

USART_init	CODE
USART_init
			GLOBAL	USART_init

;	Place baudrate constant in Baud Rate Generator Register

	BANKSEL	SPBRG		
	movlw	baudrate
	movwf	SPBRG

;	Initialise Transmit Status and Control Register

	BANKSEL	TXSTA		
	movlw	TXSTA_INIT
	movwf	TXSTA

;	Initialise Recieve Status and Control Register

	BANKSEL	RCSTA		
	movlw	RCSTA_INIT
	movwf	RCSTA

;	Clear TxBuffer

	movlw	TxB_Max
	movwf	tmp
	movlw	TxBuffer
	movwf	FSR
USART_init_clrTxBloop
	clrf	INDF
	incf	FSR,F
	decfsz	tmp,F
	goto	USART_init_clrTxBloop

;	Clear RxBuffer

	movlw	RxB_Max
	movwf	tmp
	movlw	RxBuffer
	movwf	FSR
USART_init_clrRxBloop
	clrf	INDF
	incf	FSR,F
	decfsz	tmp,F
	goto	USART_init_clrRxBloop

;	Set TxB and RxB pointers to start of buffers

	movlw	0
	
	BANKSEL	TxB_Head
	movwf	TxB_Head

	BANKSEL	TxB_Tail
	movwf	TxB_Tail

	BANKSEL	RxB_Head
	movwf	RxB_Head

	BANKSEL	RxB_Tail
	movwf	RxB_Tail

;	Set TxBFreecount to TxBMax and RxBCharCount to RxBMax

	movlw	RxB_Max
	BANKSEL	RxB_FreeCount
	movwf	RxB_FreeCount

	movlw	TxB_Max
	BANKSEL	TxB_FreeCount
	movwf	TxB_FreeCount

;	Enable Rx interrupts (putc will enable Tx interrupts)

	BANKSEL	PIE1
	bsf		PIE1,RCIE
	
;	and return

	return




;--------------------ROUTINE SPECIFICATION-------------------
;
;	NAME :			USART_TxISR
;
;	FUNCTION :		Transmit Interrupt Service Routine
;					Sends a character when the system is
;					ready to do so.
;	
;	INPUTS :		
;
;	OUTPUTS :		
;	
;	CALLS :			
;
;	CALLED BY :		
;	
;	NOTES :			
;
;------------------------------------------------------------
;	REVISION HISTORY :
;
;------------------------------------------------------------

USART_Tx_isr	CODE
USART_Tx_isr
				GLOBAL	USART_Tx_isr
;USART_TX_ISR
;	If there is a character in the buffer to transmit;

	BANKSEL	TxB_FreeCount
	PAGESEL	USART_Tx_isr_nochar
	movf	TxB_FreeCount,W
	sublw	TxB_Max
	btfsc	STATUS,Z
	goto	USART_Tx_isr_nochar

;		Take the character from the tail of the TxBuffer,

	BANKSEL	TxB_Tail
	movf	TxB_Tail,W
	addlw	TxBuffer
	movwf	FSR
	movf	INDF,W

;		and put it in the TXREG register,

	BANKSEL	TXREG
	movwf	TXREG

;		increment the TxB_Tail pointer,

	BANKSEL	TxB_Tail
	incf	TxB_Tail,F

;		wrapping it if it exceeds TxB_Max,

	movlw	TxB_Max-1
	andwf	TxB_Tail,F
	
;		Increment the TxB_FreeCount;

USART_Tx_isr_incfreecount
	BANKSEL	TxB_FreeCount
	incf	TxB_FreeCount,F

	PAGESEL	USART_Tx_isr_end
	goto	USART_Tx_isr_end

;	else disable the transmission interrupt (putc will 
;	re-enable it when there's another character in the buffer);

USART_Tx_isr_nochar
	BANKSEL	PIE1
	bcf		PIE1,TXIE

;and return from the ISR.

USART_Tx_isr_end
	return


;--------------------ROUTINE SPECIFICATION-------------------
;
;	NAME :			USART_Rx_isr
;
;	FUNCTION :		Receive Interrupt Service Routine
;					Handles receipt of a character when one
;					arrives.
;	
;	INPUTS :		
;
;	OUTPUTS :		
;	
;	CALLS :			
;
;	CALLED BY :		
;	
;	NOTES :			
;
;------------------------------------------------------------
;	REVISION HISTORY :
;
;------------------------------------------------------------

USART_Rx_isr	CODE
USART_Rx_isr	
				GLOBAL	USART_Rx_isr

;USART_RX_ISR
;	If there is free space in the Rx Buffer;

	BANKSEL	RxB_FreeCount
	PAGESEL	USART_Rx_isr_nospace
	movf	RxB_FreeCount,W
	btfsc	STATUS,Z
	goto	USART_Rx_isr_nospace

;		Check RCSTA for overruns or framing errors
;		and reset the USART if there are any overruns,
;		and read-and-forget RCREG for framing errors.
;		(In bot cases, exit the isr)

	BANKSEL	RCSTA
	PAGESEL	USART_Rx_isr_FERRchk
	btfss	RCSTA,OERR
	goto	USART_Rx_isr_FERRchk
	BANKSEL	RCSTA
	bcf		RCSTA,SPEN
	bsf		RCSTA,SPEN
	goto	USART_Rx_isr_Read

USART_Rx_isr_FERRchk
	BANKSEL	RCSTA
	PAGESEL	USART_Rx_isr_Read
	btfss	RCSTA,FERR
	goto	USART_Rx_isr_Read
	BANKSEL	RCREG
	movf	RCREG,W
	clrw						;ensure that we can't use the erroneous data
	return

;		Take the character from the RCREG register,
;		and put it in the head of the RxBuffer,

USART_Rx_isr_Read
	BANKSEL	RxB_Head
	movf	RxB_Head,W
	addlw	RxBuffer
	movwf	FSR
	BANKSEL	RCREG
	movf	RCREG,W
	movwf	INDF

;		then increment the RxB_Head pointer,
	
	BANKSEL	RxB_Head
	incf	RxB_Head,F


;		wrapping it if it exceeds RxB_Max,

	movlw	RxB_Max-1
	andwf	RxB_Head,F

;		and decrement the RxB_FreeCount;

USART_Rx_isr_inccharcount
	BANKSEL	RxB_FreeCount
	decf	RxB_FreeCount,F

	PAGESEL	USART_Rx_isr_end
	goto	USART_Rx_isr_end
	
;	else disable the reception interrupt (getc 
;	will re-enable it when there's space in the 
;	buffer)

USART_Rx_isr_nospace
	BANKSEL	PIE1
	bcf		PIE1,RCIE

;and return from the ISR.

USART_Rx_isr_end
	return



;--------------------ROUTINE SPECIFICATION-------------------
;
;	NAME :			USART_putc
;
;	FUNCTION :		Adds a character to the Tx Buffer 
;	
;	INPUTS :		The ASCII character in W
;
;	OUTPUTS :		W is zero if it succeeded
;	
;	CALLS :			
;
;	CALLED BY :		
;	
;	NOTES :			Errorcodes:
;						0001	Buffer full
;
;------------------------------------------------------------
;	REVISION HISTORY :
;
;------------------------------------------------------------

USART_putc		CODE
USART_putc
				GLOBAL	USART_putc

;USART_PUTC
;	Store the character in a temporary register

	BANKSEL	tmp
	movwf	tmp

;	Wait until there is room in the buffer;

USART_putc_nospace
	BANKSEL	TxB_FreeCount
	PAGESEL	USART_putc_nospace
	movf	TxB_FreeCount,W
	btfsc	STATUS,Z
	goto	USART_putc_nospace

;		Put the character in the head of the buffer,

	BANKSEL	TxB_Head
	movf	TxB_Head,W
	addlw	TxBuffer
	movwf	FSR
	movf	tmp,W
	movwf	INDF

;		increment the TxB_Head pointer,

	BANKSEL	TxB_Head
	incf	TxB_Head,F

;		wrapping it if it exceeds TxB_Max

	movlw	TxB_Max-1
	BANKSEL	TxB_Head
	andwf	TxB_Head,F
	
;		decrement the TxB_FreeCount,

	BANKSEL	TxB_FreeCount
	decf	TxB_FreeCount,F

;		enable the Tx interrupts,

	BANKSEL	PIE1
	bsf		PIE1,TXIE

;		clear W and return from routine.

	retlw	0



;--------------------ROUTINE SPECIFICATION-------------------
;
;	NAME :			USART_getc
;
;	FUNCTION :		Takes a character from the Rx Buffer
;	
;	INPUTS :		None
;
;	OUTPUTS :		W contains the character from the buffer 
;	
;	CALLS :			
;
;	CALLED BY :		
;	
;	NOTES :			
;
;------------------------------------------------------------
;	REVISION HISTORY :
;
;------------------------------------------------------------

;USART_GETC
USART_getc		CODE
USART_getc
				GLOBAL	USART_getc

;	Wait until there is a character in the buffer;

USART_getc_nochar
	BANKSEL	RxB_FreeCount
	movf	RxB_FreeCount,W
	sublw	RxB_Max
	btfsc	STATUS,Z
	goto	USART_getc_nochar

;		Read the character off the tail of the buffer,

	BANKSEL	RxB_Tail
	movf	RxB_Tail,W
	addlw	RxBuffer
	movwf	FSR
	movf	INDF,W

;		and store it in a temporary variable,

	BANKSEL	tmp
	movwf	tmp

;		increment the RxB_Tail pointer,

	BANKSEL	RxB_Tail
	incf	RxB_Tail,F

;		wrapping it if it exceeds RxB_Max,

	movlw	RxB_Max-1
	andwf	RxB_Tail,F

;		increment the RxB_FreeCount,

	BANKSEL	RxB_FreeCount
	incf	RxB_FreeCount,F

;		enable the receive interrupt,

	BANKSEL	PIE1
	bsf		PIE1,RCIE

;		put the read character in the W register,

	BANKSEL	tmp
	movf	tmp,W

;		and return from the routine.

	return


;--------------------ROUTINE SPECIFICATION-------------------
;
;	NAME :			USART_puts
;
;	FUNCTION :		Takes a string in ROM and sends it 
;					down the serial line
;	
;	INPUTS :		The address of the string in USART_hi_msg_tmp
;					and USART_lo_msg_tmp.
;
;	OUTPUTS :		W is 0 if successful, otherwise W holds
;					an errorcode
;	
;	CALLS :			USART_putc
;					USART_message_table
;
;	CALLED BY :		
;	
;	NOTES :			
;
;------------------------------------------------------------
;	REVISION HISTORY :
;
;------------------------------------------------------------


;USART_PUTS
;	Move the address of the string table into a temporary pointer.
USART_puts		CODE
USART_puts
				GLOBAL	USART_puts

				EXTERN	USART_hi_msg_tmp
				EXTERN	USART_lo_msg_tmp
				EXTERN	USART_message_table

	BANKSEL	temp
	clrf	temp

;	Get the character at that address,

USART_puts_loop
	PAGESEL	USART_message_table
	movf	temp,W
	call	USART_message_table
	BANKSEL	tmp2
	movwf	tmp2
	PAGESEL	USART_puts_msgdone
	movf	tmp2,W


;	If the character is not a NUL,

	xorlw	0
	btfsc	STATUS,Z
	goto	USART_puts_msgdone
	movwf	tmpchar

;		putc that character,

	PAGESEL	USART_putc
	movf	tmpchar,W
	call	USART_putc
	
;		increment the pointer and reloop

	BANKSEL	temp
	incf	temp,F
	goto	USART_puts_loop

;	if the character is a NUL, that's the end of the string,
;	so clear temp and return 0

USART_puts_msgdone

	retlw	0

;--------------------ROUTINE SPECIFICATION-------------------
;
;	NAME :			USART_putHexByte
;
;	FUNCTION :		Prints out a Byte as hex
;	
;	INPUTS :		Byte in W
;
;	OUTPUTS :		
;	
;	CALLS :			
;
;	CALLED BY :		
;	
;	NOTES :			
;
;------------------------------------------------------------
;	REVISION HISTORY :
;
;------------------------------------------------------------

;USART_putHexNybble
USART_putHexByte	CODE
USART_putHexByte
				GLOBAL	USART_putHexByte

	BANKSEL	tmp3
	PAGESEL	USART_putHexNybble
	movwf	tmp3
	andlw	0xf0
	swapf	W,W
	call	USART_putHexNybble
	BANKSEL	tmp3
	PAGESEL	USART_putHexNybble
	movf	tmp3,W
	andlw	0x0f
	call	USART_putHexNybble

	retlw	0



;--------------------ROUTINE SPECIFICATION-------------------
;
;	NAME :			USART_putHexNybble
;
;	FUNCTION :		Prints out a nybble as hex
;	
;	INPUTS :		nybble in W - lower half, eg. 0x0f
;
;	OUTPUTS :		
;	
;	CALLS :			
;
;	CALLED BY :		
;	
;	NOTES :			
;
;------------------------------------------------------------
;	REVISION HISTORY :
;
;------------------------------------------------------------

;USART_putHexNybble
USART_putHexNybble	CODE
USART_putHexNybble
				GLOBAL	USART_putHexNybble

	andlw	0x0f
	addlw	0xf6
	btfsc	STATUS,C
	addlw	0x07

	addlw	0x3a

	BANKSEL	tmp4
	movwf	tmp4
	PAGESEL	USART_putc
	movf	tmp4,W
	call	USART_putc

	retlw	0


;--------------------ROUTINE SPECIFICATION-------------------
;
;	NAME :			USART_putDecimal
;
;	FUNCTION :		Outputs a decimal figure (from 0 to 255)
;	
;	INPUTS :		Number in W
;
;	OUTPUTS :		
;	
;	CALLS :			
;
;	CALLED BY :		
;	
;	NOTES :			
;
;------------------------------------------------------------
;	REVISION HISTORY :
;
;------------------------------------------------------------

;USART_putDecimal
USART_putDecimal	CODE
USART_putDecimal	
					GLOBAL	USART_putDecimal

	BANKSEL	tmp4
	movwf	tmp4

;Subtract hundreds from the number to get the first digit
	BANKSEL	tmp3
	clrf	tmp3
	movlw	0x64
USART_putDecimal_Hundreds
	BANKSEL	tmp4
	subwf	tmp4,F
	btfss	STATUS,C
	goto	USART_putDecimal_PrintHundreds
	BANKSEL	tmp3
	incf	tmp3,F
	goto	USART_putDecimal_Hundreds

;restore number to last positive value
USART_putDecimal_PrintHundreds
	BANKSEL	tmp4
	addwf	tmp4,F		

;convert to ASCII
	movlw	0x30

;and print.
	BANKSEL	tmp3
	addwf	tmp3,F
	PAGESEL	USART_putc
	movf	tmp3,W
	call	USART_putc
	PAGESEL	USART_putDecimal

;Subtract tens from the number to get the second digit
	BANKSEL	tmp3
	clrf	tmp3
	movlw	0x0A

USART_putDecimal_Tens
	BANKSEL	tmp4
	subwf	tmp4,F
	btfss	STATUS,C
	goto	USART_putDecimal_PrintTens
	BANKSEL	tmp2
	incf	tmp2,F
	goto	USART_putDecimal_Tens

USART_putDecimal_PrintTens
	BANKSEL	tmp4
	addwf	tmp4,F

;convert to ASCII
	movlw	0x30

;and print.
	BANKSEL	tmp3
	addwf	tmp3,F
	PAGESEL	USART_putc
	movf	tmp3,W
	call	USART_putc

;convert remainder to ASCII
	BANKSEL	tmp4
	movf	tmp4,W
	addlw	0x30

;and print
	call	USART_putc

	retlw	0


;--------------------ROUTINE SPECIFICATION-------------------
;
;	NAME :			USART_putBinary
;
;	FUNCTION :		Outputs a byte in Binary format
;	
;	INPUTS :		W holds the byte
;
;	OUTPUTS :		
;	
;	CALLS :			
;
;	CALLED BY :		
;	
;	NOTES :			
;
;------------------------------------------------------------
;	REVISION HISTORY :
;
;------------------------------------------------------------

;USART_putBinary
USART_putBinary			CODE
USART_putBinary
						GLOBAL	USART_putBinary

;Number of bits
	movlw	D'08'
	movwf	tmp3

;For each bit,
USART_putBinary_loop
	rlf		tmp4,F

;Depending on the bit value		
	btfsc	STATUS,C
	goto	USART_putBinary_one

;Output a zero
	PAGESEL	USART_putc
	movlw	A'0'
	call	USART_putc
	PAGESEL	USART_putBinary
	BANKSEL	tmp3
	decfsz	tmp3,F
	goto	USART_putBinary_loop
	retlw	0
	
;or a one
USART_putBinary_one
	PAGESEL	USART_putc
	movlw	A'1'
	call	USART_putc
	PAGESEL	USART_putBinary
	BANKSEL	tmp3
	decfsz	tmp3,F
	goto	USART_putBinary_loop
	retlw	0

	END
