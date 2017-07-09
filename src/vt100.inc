;--------------------VT100 Codes---------------------------
		NOLIST

	#define	VT_setcol132		"[?3h"
	#define	VT_setcol80			"[?3l"
	#define	VT_setjumpscroll	"[?4l"
	#define	VT_setsmoothscroll	"[?4h"
	#define	VT_setreversevideo	"[?5h"
	#define	VT_setnormalvideo	"[?5l"

	#define	VT_normal		"[0m"
	#define	VT_bold			"[1m"
	#define	VT_lowint		"[2m"
	#define	VT_underline	"[3m"
	#define	VT_blink		"[4m"
	#define	VT_reverse		"[5m"
	#define	VT_invisible	"[6m"

	#define	VT_dhtop		"#3"
	#define	VT_dhbot		"#4"
	#define	VT_shsw			"#5"
	#define	VT_shdw			"#6"

	#define	VT_cleareol		"[0K"
	#define	VT_clearbol		"[1K"
	#define	VT_clearline	"[2K"
	
	#define	VT_cleareos		"[0J"
	#define	VT_clearbos		"[1J"
	#define	VT_clearscreen	"[2J"

	#define	VT_devstat		"5n"
	#define	VT_termok		"0n"
	#define	VT_termnok		"3n"

	#define	VT_ident		"[c"

	#define	VT_align		"#8"
	#define	VT_testpu		"[2;1y"
	#define	VT_testlb		"[2;2y"
	#define	VT_testpurep	"[2;9y"
	#define	VT_testlbrep	"[2;10y"

;Keyboard LEDs

	#define	VT_ledsoff		"[0q"
	#define	VT_led1			"[1q"
	#define	VT_led2			"[2q"
	#define	VT_led3			"[3q"
	#define	VT_led4			"[4q"

	#define	VT_savecursor		"7"
	#define	VT_restorecursor	"8"

	#define	VT_cursorhome	"[H"


		LIST
