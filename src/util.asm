;--------------------LIBRARY SPECIFICATION-------------------
;
;	NAME :			Misc.inc
;
;	FUNCTIONS :		Delay500
;					XDelay500
;	
;	REQUIRES :		p16c74a.inc
;
;	NOTES :			
;
;------------------------------------------------------------
;	REVISION HISTORY :
;		9/9/97	First Draft
;		22/12/97 Made relocatable
;
;------------------------------------------------------------

	ERRORLEVEL	0
	PROCESSOR	PIC16C74A
	LIST		b=4
	TITLE		"LCD Delay routines"
	SUBTITLE	"Version 1.00"

	include		<p16c74a.inc>

;------------------------------------------------------------

UtilData	UDATA

DELAY		RES	1
X_DELAY		RES	1

;--------------------ROUTINE SPECIFICATION-------------------
;
;	NAME :			Delay500
;
;	FUNCTION :		Pauses for 500 microseconds
;	
;	INPUTS :		None
;
;	OUTPUTS :		None
;	
;	CALLS :			None
;
;	CALLED BY :		Anything
;	
;	NOTES :			Affects W, uses a RAM location
;
;------------------------------------------------------------
;	REVISION HISTORY :
;		9/9/97	First draft
;
;------------------------------------------------------------


Delay500		CODE
Delay500
				GLOBAL	Delay500

	movlw	D'165'			;165 = 500 uS at 4MHz
	BANKSEL	DELAY
	movwf	DELAY
Delay500Loop
	decfsz	DELAY,1
	goto	Delay500Loop
	return

;--------------------ROUTINE SPECIFICATION-------------------
;
;	NAME :			XDelay500
;
;	FUNCTION :		Pauses for N times 500us
;	
;	INPUTS :		W contains N
;
;	OUTPUTS :		None
;	
;	CALLS :			Delay500
;
;	CALLED BY :		Anything
;	
;	NOTES :			Messes with W, uses a RAM location
;
;------------------------------------------------------------
;	REVISION HISTORY :
;
;------------------------------------------------------------

X_Delay500
				GLOBAL	X_Delay500

	BANKSEL	X_DELAY
	movwf	X_DELAY
X_Delay500Loop
	call	Delay500
	decfsz	X_DELAY,1
	goto	X_Delay500Loop
	return

	END
