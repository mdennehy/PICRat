;--------------------LIBRARY SPECIFICATION-------------------
;
;	NAME :			LCD Library		
;
;	FUNCTIONS :		LCD_Initialise
;					LCD_BusyCheck
;	
;	REQUIRES :		Misc.inc
;					p16c74a.inc
;
;	NOTES :			
;
;------------------------------------------------------------
;	REVISION HISTORY :
;		9/9/97	First draft - LCD_Initialise, LCD_BusyCheck
;		22/12/97 Made relocatable
;
;------------------------------------------------------------

	ERRORLEVEL	0
	PROCESSOR	PIC16C74A
	LIST		b=4
	TITLE		"LCD Routines"
	SUBTITLE	"Version 1.00"

	include		<p16c74a.inc>

;------------------------------------------------------------

LCD_E	EQU	6		; LCD Enable line
LCD_RW	EQU	5		; LCD Read/Write line
LCD_RS	EQU	4		; LCD Data/Command line

LCD		EQU	PORTD	; LCD Port

LCD_Data		UDATA

LCD_TMP			RES		1


;--------------------ROUTINE SPECIFICATION-------------------
;
;	NAME :			LCD_Initialise
;
;	FUNCTION :		Initialises LCD Module
;	
;	INPUTS :		None
;
;	OUTPUTS :		None
;	
;	CALLS :			LCD_BusyCheck, LCD_PutCmd
;
;	CALLED BY :		Anyone starting the LCD Library
;	
;	NOTES :			Intended to be called on Startup
;
;------------------------------------------------------------
;	REVISION HISTORY :
;		9/9/97	First Draft
;
;------------------------------------------------------------
;	Follows the standard startup procedure defined for thisi
;	module in the FAQ

LCD_Initialise		CODE
LCD_Initialise
					GLOBAL	LCD_Initialise
					EXTERN	X_Delay500
					EXTERN	Delay500

	PAGESEL	LCD_SetToWrite
	call	LCD_SetToWrite
	BANKSEL	PORTD
	clrf	PORTD
	BANKSEL	TRISE
	bcf		TRISE,PSPMODE

	PAGESEL	X_Delay500
	movlw	D'30'
	call	X_Delay500		;Pause 15ms to allow LCD to come online
	
	movlw	B'00000011'		;Wakeup
	BANKSEL	LCD
	movwf	LCD
	bsf		LCD,LCD_E
	nop
	bcf		LCD,LCD_E
	
	PAGESEL	X_Delay500
	movlw	D'9'
	call	X_Delay500		;pause 4.5ms
	
	bsf		LCD,LCD_E
	nop
	bcf		LCD,LCD_E
	
	PAGESEL	Delay500
	call	Delay500		;pause 500us

	bsf		LCD,LCD_E
	nop
	bcf		LCD,LCD_E

	PAGESEL	X_Delay500
	movlw	D'9'
	call	X_Delay500		;pause 4.5 ms

	movlw	B'00000010'
	movwf	LCD
	bsf		LCD,LCD_E
	nop
	bcf		LCD,LCD_E


	PAGESEL	Delay500
	call	Delay500		;pause 500us : LCD BUSY flag should now be valid

	PAGESEL	LCD_PutCmd
	movlw	B'00101100'		;4-bit operation, 1/16 duty cycle, 5x11 Font
	call	LCD_PutCmd

	PAGESEL	LCD_PutCmd
	movlw	B'00001000'		;Display off, Cursor off, Blink off
	call	LCD_PutCmd

	PAGESEL	LCD_PutCmd
	movlw	B'00000001'		;Home Cursor
	call	LCD_PutCmd

	PAGESEL	LCD_PutCmd
	movlw	B'00000110'		;Cursor moves right, no shift
	call	LCD_PutCmd

	PAGESEL	LCD_PutCmd
	movlw	B'00001110'		;Display on, Cursor on
	call	LCD_PutCmd

	BANKSEL	LCD
	clrf	LCD				;Initialisation complete, LCD ready for use

	return

;--------------------ROUTINE SPECIFICATION-------------------
;
;	NAME :			LCD_BusyCheck
;
;	FUNCTION :		Tests LCD Module's busy flag to see if 
;					it is ready to accept new data
;	
;	INPUTS :		None
;
;	OUTPUTS :		None
;	
;	CALLS :			Nothing
;
;	CALLED BY :		Most LCD routines, LCD_PutCmd
;	
;	NOTES :			Does not return until LCD Module is ready
;					to accept new input - therefore, removing
;					the LCD while hot is not recommended as it 
;					could potentially hang the system.
;					Returns with LCD port set to write to 
;					module.
;
;------------------------------------------------------------
;	REVISION HISTORY :
;			9/9/97	First draft
;
;------------------------------------------------------------
LCD_BusyCheck			CODE
LCD_BusyCheck
						GLOBAL	LCD_BusyCheck

	BANKSEL	LCD
	clrf	LCD
	PAGESEL	LCD_SetToRead
	call	LCD_SetToRead

	BANKSEL	LCD
	bcf		LCD,LCD_RS
	bsf		LCD,LCD_RW

LCD_BusyCheckLoop
	bsf		LCD,LCD_E
	nop
	movf	LCD,W			;Get high nybble
	bcf		LCD,LCD_E
	bsf		LCD,LCD_E		;Discard Low Nybble
	nop
	bcf		LCD,LCD_E

	andlw	B'00001000'		;Test Busy Flag
	btfss	STATUS,Z
	goto	LCD_BusyCheckLoop	; Busy flag set. Wait until cleared.

	clrf	LCD
	PAGESEL	LCD_SetToWrite
	call	LCD_SetToWrite

	return


;--------------------ROUTINE SPECIFICATION-------------------
;
;	NAME :			LCD_PutCmd
;
;	FUNCTION :		Sends command to LCD module
;	
;	INPUTS :		Contents of W are sent to the module 
;					in 2 4-bit chunks
;
;	OUTPUTS :		None
;	
;	CALLS :			LCD_BusyCheck
;
;	CALLED BY :		Just about eveything in the LCD Library
;	
;	NOTES :			Returns from this function with the LCD 
;					pins set to write to the module
;
;------------------------------------------------------------
;	REVISION HISTORY :
;		9/9/97	First draft
;
;------------------------------------------------------------
LCD_PutCmd				CODE
LCD_PutCmd
						GLOBAL	LCD_PutCmd

	BANKSEL	LCD_TMP
	movwf	LCD_TMP
	PAGESEL	LCD_BusyCheck	
	call	LCD_BusyCheck
	PAGESEL	LCD_SetToWrite
	call	LCD_SetToWrite

	BANKSEL	LCD_TMP
	swapf	LCD_TMP,W		;Put upper nybble in W
	andlw	H'0F'
	BANKSEL	LCD
	movwf	LCD				;Send upper nybble to LCD
	bsf		LCD,LCD_E
	nop
	bcf		LCD,LCD_E

	BANKSEL	LCD_TMP
	movf	LCD_TMP,W		;Put lower nybble in W
	andlw	H'0F'
	BANKSEL	LCD
	movwf	LCD				;Send lower nybble to LCD
	bsf		LCD,LCD_E
	nop
	bcf		LCD,LCD_E
	return

;--------------------ROUTINE SPECIFICATION-------------------
;
;	NAME :			LCD_PutChar
;
;	FUNCTION :		Sends a character to the LCD module
;	
;	INPUTS :		W contains the character to be written
;
;	OUTPUTS :		None
;	
;	CALLS :			LCD_SetToWrite, LCD_BusyCheck
;
;	CALLED BY :		Everything
;	
;	NOTES :			As for LCD_PutCmd, you return from this
;					routine with the LCD port in write mode
;
;------------------------------------------------------------
;	REVISION HISTORY :
;		9/9/97	First Draft
;
;------------------------------------------------------------
LCD_PutChar			CODE
LCD_PutChar
					GLOBAL	LCD_PutChar

	BANKSEL	LCD_TMP
	movwf	LCD_TMP
	PAGESEL	LCD_BusyCheck
	call	LCD_BusyCheck
	PAGESEL	LCD_SetToWrite
	call	LCD_SetToWrite

	BANKSEL	LCD_TMP
	swapf	LCD_TMP,W		;put upper nybble in W
	andlw	H'0F'
	BANKSEL	LCD
	movlw	LCD				;Send upper Nybble
	bsf		LCD,LCD_RS
	bsf		LCD,LCD_E
	nop
	bcf		LCD,LCD_E

	BANKSEL	LCD_TMP
	movf	LCD_TMP,W		;Put lower nybble in W
	andlw	H'0F'
	BANKSEL	LCD
	movlw	LCD				;Send lower nybble
	bsf		LCD,LCD_RS
	bsf		LCD,LCD_E
	nop
	bcf		LCD,LCD_E

	return

;--------------------ROUTINE SPECIFICATION-------------------
;
;	NAME :			LCD_SetToRead
;
;	FUNCTION :		Sets LCD port pins to read from module
;	
;	INPUTS :		None
;
;	OUTPUTS :		None
;	
;	CALLS :			None
;
;	CALLED BY :		Everything
;	
;	NOTES :			Just messes with TRISD to reduce code 
;					duplication
;
;------------------------------------------------------------
;	REVISION HISTORY :
;		9/9/97	First draft
;
;------------------------------------------------------------
LCD_SetToRead			CODE
LCD_SetToRead
						GLOBAL	LCD_SetToRead

	BANKSEL	TRISD
	movlw	H'0F'			;Set LCD data pins to i/p
	movwf	TRISD
	return

;--------------------ROUTINE SPECIFICATION-------------------
;
;	NAME :			LCD_SetToWrite
;
;	FUNCTION :		Sets LCD port pins to write to module
;	
;	INPUTS :		None
;
;	OUTPUTS :		None
;	
;	CALLS :			None
;
;	CALLED BY :		Everything
;	
;	NOTES :			Messes with TRISD as for LCD_SetToRead
;
;------------------------------------------------------------
;	REVISION HISTORY :
;		9/9/97	First Draft
;
;------------------------------------------------------------
LCD_SetToWrite			CODE
LCD_SetToWrite
						GLOBAL	LCD_SetToWrite

	BANKSEL	TRISD
	movlw	H'00'			;Restore LCD data pins to o/p
	movwf	TRISD
	return

	END
