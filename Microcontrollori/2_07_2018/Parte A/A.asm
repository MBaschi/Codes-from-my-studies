
_main:

;A.c,19 :: 		void main() {
;A.c,22 :: 		unsigned short int timer_value=30;
	MOVLW       30
	MOVWF       main_timer_value_L0+0 
;A.c,26 :: 		TRISD=0;
	CLRF        TRISD+0 
;A.c,27 :: 		ANSELD=255;
	MOVLW       255
	MOVWF       ANSELD+0 
;A.c,29 :: 		TRISE.RE2=0;
	BCF         TRISE+0, 2 
;A.c,30 :: 		ANSELE.RE2=1;
	BSF         ANSELE+0, 2 
;A.c,32 :: 		LATE.RE2=0;
	BCF         LATE+0, 2 
;A.c,33 :: 		LATD=timer_value;
	MOVF        main_timer_value_L0+0, 0 
	MOVWF       LATD+0 
;A.c,36 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;A.c,37 :: 		Lcd_cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;A.c,38 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;A.c,43 :: 		T0CON=0b11000111;
	MOVLW       199
	MOVWF       T0CON+0 
;A.c,44 :: 		TMR0L=217;
	MOVLW       217
	MOVWF       TMR0L+0 
;A.c,46 :: 		INTCON=0b11100000; //T_overflow=(4/fosc)*(256-TMR0L)*PSA, siccome è richiesta una precisione del 5%
	MOVLW       224
	MOVWF       INTCON+0 
;A.c,61 :: 		while(timer_value>=0){
L_main0:
	MOVLW       0
	SUBWF       main_timer_value_L0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_main1
;A.c,63 :: 		if (counter>100){
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       _counter+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main5
	MOVF        _counter+0, 0 
	SUBLW       100
L__main5:
	BTFSC       STATUS+0, 0 
	GOTO        L_main2
;A.c,65 :: 		IntToStr(timer_value,timer_value_char);
	MOVF        main_timer_value_L0+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVLW       0
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_timer_value_char_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_timer_value_char_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;A.c,66 :: 		Lcd_Out(1,1,timer_value_char);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_timer_value_char_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_timer_value_char_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;A.c,67 :: 		timer_value-=1;
	DECF        main_timer_value_L0+0, 1 
;A.c,68 :: 		LATD=timer_value;
	MOVF        main_timer_value_L0+0, 0 
	MOVWF       LATD+0 
;A.c,69 :: 		counter=0;
	CLRF        _counter+0 
	CLRF        _counter+1 
;A.c,70 :: 		LATE.RE2=1;
	BSF         LATE+0, 2 
;A.c,72 :: 		}
L_main2:
;A.c,74 :: 		}
	GOTO        L_main0
L_main1:
;A.c,78 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_interrupt:

;A.c,82 :: 		void interrupt(){
;A.c,83 :: 		if (INTCON.TMR0IF){
	BTFSS       INTCON+0, 2 
	GOTO        L_interrupt3
;A.c,85 :: 		INTCON.TMR0IE=0;
	BCF         INTCON+0, 5 
;A.c,86 :: 		counter+=5; //ms
	MOVLW       5
	ADDWF       _counter+0, 1 
	MOVLW       0
	ADDWFC      _counter+1, 1 
;A.c,88 :: 		INTCON.TMR0IE=1;
	BSF         INTCON+0, 5 
;A.c,89 :: 		INTCON.TMR0IF=0;
	BCF         INTCON+0, 2 
;A.c,90 :: 		}
L_interrupt3:
;A.c,91 :: 		}
L_end_interrupt:
L__interrupt7:
	RETFIE      1
; end of _interrupt
