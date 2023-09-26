
_main:

;lab3.c,5 :: 		void main() {
;lab3.c,10 :: 		short unsigned int dir = 1;
	MOVLW       1
	MOVWF       main_dir_L0+0 
;lab3.c,17 :: 		TRISB.RB7 = 1;		// RB7, RB6 configured as input
	BSF         TRISB+0, 7 
;lab3.c,18 :: 		TRISB.RB6 = 1;
	BSF         TRISB+0, 6 
;lab3.c,20 :: 		ANSELB.RB7 = 0;		// RB7, RB6 configured as "Digital"
	BCF         ANSELB+0, 7 
;lab3.c,21 :: 		ANSELB.RB6 = 0;
	BCF         ANSELB+0, 6 
;lab3.c,23 :: 		IOCB = 0b11000000;	//RB6-7 IOCB Active
	MOVLW       192
	MOVWF       IOCB+0 
;lab3.c,27 :: 		TRISC = 0;  		// PORTC configured as Output, ANSELC not required
	CLRF        TRISC+0 
;lab3.c,31 :: 		INTCON.RBIE = 1;
	BSF         INTCON+0, 3 
;lab3.c,32 :: 		INTCON.RBIF = 0; // Set IOCB
	BCF         INTCON+0, 0 
;lab3.c,41 :: 		T0CON = 0b11000111;
	MOVLW       199
	MOVWF       T0CON+0 
;lab3.c,53 :: 		INTCON.TMR0IE = 1;
	BSF         INTCON+0, 5 
;lab3.c,54 :: 		INTCON.TMR0IF = 0;
	BCF         INTCON+0, 2 
;lab3.c,59 :: 		LATC = 1;
	MOVLW       1
	MOVWF       LATC+0 
;lab3.c,64 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;lab3.c,66 :: 		while(1){
L_main0:
;lab3.c,69 :: 		if (led_ms >= kitt_delay){
	MOVLW       128
	XORWF       _led_ms+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       _kitt_delay+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main18
	MOVF        _kitt_delay+0, 0 
	SUBWF       _led_ms+0, 0 
L__main18:
	BTFSS       STATUS+0, 0 
	GOTO        L_main2
;lab3.c,72 :: 		if(dir)
	MOVF        main_dir_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main3
;lab3.c,73 :: 		LATC <<= 1;
	MOVF        LATC+0, 0 
	MOVWF       R0 
	RLCF        R0, 1 
	BCF         R0, 0 
	MOVF        R0, 0 
	MOVWF       LATC+0 
	GOTO        L_main4
L_main3:
;lab3.c,75 :: 		LATC >>= 1;
	MOVF        LATC+0, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVF        R0, 0 
	MOVWF       LATC+0 
L_main4:
;lab3.c,86 :: 		if(LATC >= 0b00000001)
	MOVLW       1
	SUBWF       LATC+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_main5
;lab3.c,87 :: 		dir = 1;
	MOVLW       1
	MOVWF       main_dir_L0+0 
	GOTO        L_main6
L_main5:
;lab3.c,88 :: 		else if(LATC <= 0b10000000)
	MOVF        LATC+0, 0 
	SUBLW       128
	BTFSS       STATUS+0, 0 
	GOTO        L_main7
;lab3.c,89 :: 		dir = 0;
	CLRF        main_dir_L0+0 
L_main7:
L_main6:
;lab3.c,92 :: 		led_ms = 0;
	CLRF        _led_ms+0 
	CLRF        _led_ms+1 
;lab3.c,93 :: 		}
L_main2:
;lab3.c,106 :: 		}
	GOTO        L_main0
;lab3.c,108 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_interrupt:

;lab3.c,112 :: 		void interrupt(){
;lab3.c,115 :: 		if(INTCON.TMR0IF){
	BTFSS       INTCON+0, 2 
	GOTO        L_interrupt8
;lab3.c,116 :: 		INTCON.TMR0IF = 0;
	BCF         INTCON+0, 2 
;lab3.c,118 :: 		led_ms += 33;
	MOVLW       33
	ADDWF       _led_ms+0, 1 
	MOVLW       0
	ADDWFC      _led_ms+1, 1 
;lab3.c,120 :: 		}
	GOTO        L_interrupt9
L_interrupt8:
;lab3.c,121 :: 		else if(INTCON.RBIF){
	BTFSS       INTCON+0, 0 
	GOTO        L_interrupt10
;lab3.c,123 :: 		if(PORTB.RB7)
	BTFSS       PORTB+0, 7 
	GOTO        L_interrupt11
;lab3.c,124 :: 		kitt_delay += 50;
	MOVLW       50
	ADDWF       _kitt_delay+0, 1 
	MOVLW       0
	ADDWFC      _kitt_delay+1, 1 
	GOTO        L_interrupt12
L_interrupt11:
;lab3.c,125 :: 		else if(PORTB.RB6)
	BTFSS       PORTB+0, 6 
	GOTO        L_interrupt13
;lab3.c,126 :: 		kitt_delay -= 50;
	MOVLW       50
	SUBWF       _kitt_delay+0, 1 
	MOVLW       0
	SUBWFB      _kitt_delay+1, 1 
L_interrupt13:
L_interrupt12:
;lab3.c,128 :: 		if(kitt_delay < 50)
	MOVLW       128
	XORWF       _kitt_delay+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt21
	MOVLW       50
	SUBWF       _kitt_delay+0, 0 
L__interrupt21:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt14
;lab3.c,129 :: 		kitt_delay = 50;
	MOVLW       50
	MOVWF       _kitt_delay+0 
	MOVLW       0
	MOVWF       _kitt_delay+1 
	GOTO        L_interrupt15
L_interrupt14:
;lab3.c,130 :: 		else if(kitt_delay > 3000)
	MOVLW       128
	XORLW       11
	MOVWF       R0 
	MOVLW       128
	XORWF       _kitt_delay+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt22
	MOVF        _kitt_delay+0, 0 
	SUBLW       184
L__interrupt22:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt16
;lab3.c,131 :: 		kitt_delay = 3000;
	MOVLW       184
	MOVWF       _kitt_delay+0 
	MOVLW       11
	MOVWF       _kitt_delay+1 
L_interrupt16:
L_interrupt15:
;lab3.c,133 :: 		INTCON.RBIF = 0;
	BCF         INTCON+0, 0 
;lab3.c,134 :: 		}
L_interrupt10:
L_interrupt9:
;lab3.c,141 :: 		}
L_end_interrupt:
L__interrupt20:
	RETFIE      1
; end of _interrupt
