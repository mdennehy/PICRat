;--------------------USART Message Table---------------------
;
;	NOTES :			All messages should be stored in the 
;					following format :
;
;	<Message Label>	CODE
;	<Message Label>	
;					GLOBAL	<Message Label>
;	DT	"<Message Text>"
;	DT	0
;
;	Also, if the message crosses a page boundary, there may
;	be problems ...
;
;------------------------------------------------------------
;	REVISION HISTORY :
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

USART_MSG_DATA		UDATA	
USART_hi_msg_tmp	RES	1	
USART_lo_msg_tmp	RES	1	
					GLOBAL	USART_hi_msg_tmp
					GLOBAL	USART_lo_msg_tmp

USART_MSG_TMP		UDATA
tmpcnt				RES 1

USART_message_table	CODE	
USART_message_table
					GLOBAL	USART_message_table

	BANKSEL	tmpcnt
	movwf	tmpcnt					;save offset
	BANKSEL	USART_hi_msg_tmp
	movf	USART_hi_msg_tmp,W	;High part of address
	movwf	PCLATH
	BANKSEL	USART_lo_msg_tmp	;low part of address
	movf	USART_lo_msg_tmp,W
	BANKSEL	tmpcnt
	addwf	tmpcnt,W				;plus offset
	btfsc	STATUS,C			;allowing for carry
	incf	PCLATH,F
	movwf	PCL


;------------------------------------------------------------
;
;Startup Splash Screen
;

;Startup_screen		CODE
Startup_screen		
					GLOBAL	Startup_screen

	DT	VT_setcol80,VT_setjumpscroll,VT_setnormalvideo
	DT	VT_clearscreen,VT_align
	DT	VT_clearscreen,VT_cursorhome
	DT	VT_dhtop,VT_bold
	DT	"PIC-Rat Micromouse Platform\n\r"
	DT	VT_dhbot
	DT	"PIC-Rat Micromouse Platform\n\r"
	DT	VT_normal,VT_shdw
	DT	"\n\rMark Dennehy\tTCD Vision Lab\t1997\n\r"
	DT	VT_normal,VT_shsw
	DT	0


	END

