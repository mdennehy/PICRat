;--------------------LIBRARY SPECIFICATION-------------------
;
;	NAME :			Self Test Library
;
;	FUNCTIONS :		MemoryTest
;	
;	REQUIRES :		
;
;	NOTES :			
;
;------------------------------------------------------------
;	REVISION HISTORY :
;
;------------------------------------------------------------

	ERRORLEVEL	0
	PROCESSOR	PIC16C74A
	LIST		b=4
	TITLE		"PICRAT Self-Test and Initialisation Library"
	SUBTITLE	"Version 1.00"

	include		<p16c74a.inc>

;------------------------------------------------------------


;--------------------ROUTINE SPECIFICATION-------------------
;
;	NAME :			MemoryTest
;
;	FUNCTION :		Initialise and test all memory locations
;	
;	INPUTS :		None
;
;	OUTPUTS :		W=0 if successful
;	
;	CALLS :			MemoryFill
;
;	CALLED BY :		
;	
;	NOTES :			
;
;------------------------------------------------------------
;	REVISION HISTORY :
;		V1.00	18/12/97	First draft - worked first time! 
;
;------------------------------------------------------------
MemoryTest	CODE
MemoryTest
			GLOBAL	MemoryTest



	bcf		STATUS,IRP
	bcf		STATUS,RP0
	bcf		STATUS,RP1

;	First, write a 55 to all locations in gen.purpose RAM.
;	Bank 0

	movlw	H'7F'
	movwf	FSR

MTLoop1
	movlw	H'55'
	movwf	INDF
	decf	FSR,F
	movf	FSR,W
	xorlw	H'1F'
	btfss	STATUS,Z
	goto	MTLoop1
	
;	Bank 1

	movlw	H'FF'
	movwf	FSR

MTLoop1b
	movlw	H'55'
	movwf	INDF
	decf	FSR,F
	movf	FSR,W
	xorlw	H'9F'
	btfss	STATUS,Z
	goto	MTLoop1b

;	Then, read back and test each location 
;	Bank 0

	movlw	H'7F'
	movwf	FSR

MTLoop2
	movf	INDF,W
	xorlw	H'55'
	btfss	STATUS,Z
	goto	MemFault
	decf	FSR,F
	movf	FSR,W
	xorlw	H'1F'
	btfss	STATUS,Z
	goto	MTLoop2

	movlw	H'FF'
	movwf	FSR

MTLoop2b
	movf	INDF,W
	xorlw	H'55'
	btfss	STATUS,Z
	goto	MemFault
	decf	FSR,F
	movf	FSR,W
	xorlw	H'9F'
	btfss	STATUS,Z
	goto	MTLoop2b

;	Next, write an AA to all locations in gen.purpose RAM.
;	Bank 0

	movlw	H'7F'
	movwf	FSR

MTLoop3
	movlw	H'AA'
	movwf	INDF
	decf	FSR,F
	movf	FSR,W
	xorlw	H'1F'
	btfss	STATUS,Z
	goto	MTLoop3

;	Bank 1

	movlw	H'FF'
	movwf	FSR

MTLoop3b
	movlw	H'AA'
	movwf	INDF
	decf	FSR,F
	movf	FSR,W
	xorlw	H'9F'
	btfss	STATUS,Z
	goto	MTLoop3b

;	Then, read back and test each location 
;	Bank 0

	movlw	H'7F'
	movwf	FSR

MTLoop4
	movf	INDF,W
	xorlw	H'AA'
	btfss	STATUS,Z
	goto	MemFault
	decf	FSR,F
	movf	FSR,W
	xorlw	H'1F'
	btfss	STATUS,Z
	goto	MTLoop4

;	Bank 1

	movlw	H'FF'
	movwf	FSR

MTLoop4b
	movf	INDF,W
	xorlw	H'AA'
	btfss	STATUS,Z
	goto	MemFault
	decf	FSR,F
	movf	FSR,W
	xorlw	H'9F'
	btfss	STATUS,Z
	goto	MTLoop4b

;	Next, clear all memory locations
;	Bank 0

	movlw	H'7F'
	movwf	FSR

MTLoop5
	clrf	INDF
	decf	FSR,F
	movf	FSR,W
	xorlw	H'1F'
	btfss	STATUS,Z
	goto	MTLoop5

;	Bank 1

	movlw	H'FF'
	movwf	FSR

MTLoop5b
	clrf	INDF
	decf	FSR,F
	movf	FSR,W
	xorlw	H'9F'
	btfss	STATUS,Z
	goto	MTLoop5b

;	And now set special registers to initial values.

MTRegInit	
	clrf	PORTA
	clrf	PORTB
	clrf	PORTC
	clrf	PORTD
	clrf	PORTE
	clrf	FSR
	retlw	0

MemFault
	goto MemFault

	END
