
_main:

;b.c,19 :: 		void main() {
;b.c,22 :: 		unsigned short int timer_value=30;
	MOVLW       30
	MOVWF       main_timer_value_L0+0 
	MOVLW       30
	MOVWF       main_timer_init_value_L0+0 
	MOVLW       1
	MOVWF       main_go_L0+0 
;b.c,41 :: 		TRISD=0;
	CLRF        TRISD+0 
;b.c,42 :: 		ANSELD=255;
	MOVLW       255
	MOVWF       ANSELD+0 
;b.c,45 :: 		TRISE.RE2=0;
	BCF         TRISE+0, 2 
;b.c,46 :: 		ANSELE.RE2=1;
	BSF         ANSELE+0, 2 
;b.c,47 :: 		LATE.RE2=0;
	BCF         LATE+0, 2 
;b.c,49 :: 		TRISA=0b00001111;
	MOVLW       15
	MOVWF       TRISA+0 
;b.c,50 :: 		ANSELA=0b11110000;
	MOVLW       240
	MOVWF       ANSELA+0 
;b.c,52 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;b.c,53 :: 		Lcd_cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;b.c,54 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;b.c,59 :: 		T0CON=0b11000111;
	MOVLW       199
	MOVWF       T0CON+0 
;b.c,60 :: 		TMR0L=217;
	MOVLW       217
	MOVWF       TMR0L+0 
;b.c,62 :: 		INTCON=0b11100000; //T_overflow=(4/fosc)*(256-TMR0L)*PSA, siccome è richiesta una precisione del 5%
	MOVLW       224
	MOVWF       INTCON+0 
;b.c,68 :: 		while (PORTA.RA0==0){ // quando premo start non posso più cambiare il valore iniziale del cronometro
L_main0:
	BTFSC       PORTA+0, 0 
	GOTO        L_main1
;b.c,70 :: 		RA2_NEW=PORTA.RA2;
	MOVLW       0
	BTFSC       PORTA+0, 2 
	MOVLW       1
	MOVWF       main_RA2_NEW_L0+0 
;b.c,71 :: 		RA3_NEW=PORTA.RA3;
	MOVLW       0
	BTFSC       PORTA+0, 3 
	MOVLW       1
	MOVWF       main_RA3_NEW_L0+0 
;b.c,73 :: 		if (RA2_NEW && RA2_NEW!=RA2_OLD){
	MOVF        main_RA2_NEW_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
	MOVF        main_RA2_NEW_L0+0, 0 
	XORWF       main_RA2_OLD_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
L__main24:
;b.c,74 :: 		timer_init_value+=5;
	MOVLW       5
	ADDWF       main_timer_init_value_L0+0, 1 
;b.c,75 :: 		}
L_main4:
;b.c,77 :: 		if (RA3_NEW && RA3_NEW!=RA3_OLD){
	MOVF        main_RA3_NEW_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main7
	MOVF        main_RA3_NEW_L0+0, 0 
	XORWF       main_RA3_OLD_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main7
L__main23:
;b.c,78 :: 		timer_init_value-=5;
	MOVLW       5
	SUBWF       main_timer_init_value_L0+0, 1 
;b.c,79 :: 		}
L_main7:
;b.c,81 :: 		timer_value=timer_init_value;
	MOVF        main_timer_init_value_L0+0, 0 
	MOVWF       main_timer_value_L0+0 
;b.c,82 :: 		IntToStr(timer_value,timer_value_char);
	MOVF        main_timer_init_value_L0+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVLW       0
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_timer_value_char_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_timer_value_char_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;b.c,83 :: 		Lcd_Out(1,1,timer_value_char);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_timer_value_char_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_timer_value_char_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;b.c,85 :: 		RA2_OLD=RA2_NEW;
	MOVF        main_RA2_NEW_L0+0, 0 
	MOVWF       main_RA2_OLD_L0+0 
;b.c,86 :: 		RA3_OLD=RA3_NEW;
	MOVF        main_RA3_NEW_L0+0, 0 
	MOVWF       main_RA3_OLD_L0+0 
;b.c,87 :: 		}
	GOTO        L_main0
L_main1:
;b.c,88 :: 		LATD=timer_value;
	MOVF        main_timer_value_L0+0, 0 
	MOVWF       LATD+0 
;b.c,98 :: 		while(timer_value>=0){
L_main8:
	MOVLW       0
	SUBWF       main_timer_value_L0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_main9
;b.c,100 :: 		RA0_NEW=PORTA.RA0;
	MOVLW       0
	BTFSC       PORTA+0, 0 
	MOVLW       1
	MOVWF       main_RA0_NEW_L0+0 
;b.c,101 :: 		RA1_NEW=PORTA.RA1;
	MOVLW       0
	BTFSC       PORTA+0, 1 
	MOVLW       1
	MOVWF       main_RA1_NEW_L0+0 
;b.c,103 :: 		if (RA0_NEW && RA0_NEW!=RA0_OLD){
	MOVF        main_RA0_NEW_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main12
	MOVF        main_RA0_NEW_L0+0, 0 
	XORWF       main_RA0_OLD_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main12
L__main22:
;b.c,104 :: 		go=1;
	MOVLW       1
	MOVWF       main_go_L0+0 
;b.c,105 :: 		INTCON.TMR0IE=1; //il valore di clock può essere aggiornato
	BSF         INTCON+0, 5 
;b.c,106 :: 		}
L_main12:
;b.c,108 :: 		if (RA1_NEW && RA1_NEW!=RA1_OLD){
	MOVF        main_RA1_NEW_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main15
	MOVF        main_RA1_NEW_L0+0, 0 
	XORWF       main_RA1_OLD_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main15
L__main21:
;b.c,109 :: 		go=0;
	CLRF        main_go_L0+0 
;b.c,110 :: 		INTCON.TMR0IE=0; //il valore di clock non deve essere aggiornato
	BCF         INTCON+0, 5 
;b.c,111 :: 		}
L_main15:
;b.c,113 :: 		RA0_OLD=RA2_NEW;
	MOVF        main_RA2_NEW_L0+0, 0 
	MOVWF       main_RA0_OLD_L0+0 
;b.c,114 :: 		RA3_OLD=RA3_NEW;
	MOVF        main_RA3_NEW_L0+0, 0 
	MOVWF       main_RA3_OLD_L0+0 
;b.c,117 :: 		if (counter>100 && go){
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       _counter+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main26
	MOVF        _counter+0, 0 
	SUBLW       100
L__main26:
	BTFSC       STATUS+0, 0 
	GOTO        L_main18
	MOVF        main_go_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main18
L__main20:
;b.c,119 :: 		IntToStr(timer_value,timer_value_char);
	MOVF        main_timer_value_L0+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVLW       0
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_timer_value_char_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_timer_value_char_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;b.c,120 :: 		Lcd_Out(1,1,timer_value_char);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_timer_value_char_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_timer_value_char_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;b.c,121 :: 		timer_value-=1;
	DECF        main_timer_value_L0+0, 1 
;b.c,122 :: 		LATD=timer_value;
	MOVF        main_timer_value_L0+0, 0 
	MOVWF       LATD+0 
;b.c,123 :: 		counter=0;
	CLRF        _counter+0 
	CLRF        _counter+1 
;b.c,124 :: 		LATE.RE2=1;
	BSF         LATE+0, 2 
;b.c,126 :: 		}
L_main18:
;b.c,128 :: 		}
	GOTO        L_main8
L_main9:
;b.c,132 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_interrupt:

;b.c,136 :: 		void interrupt(){
;b.c,137 :: 		if (INTCON.TMR0IF){
	BTFSS       INTCON+0, 2 
	GOTO        L_interrupt19
;b.c,139 :: 		INTCON.TMR0IE=0;
	BCF         INTCON+0, 5 
;b.c,140 :: 		counter+=5; //ms
	MOVLW       5
	ADDWF       _counter+0, 1 
	MOVLW       0
	ADDWFC      _counter+1, 1 
;b.c,142 :: 		INTCON.TMR0IE=1;
	BSF         INTCON+0, 5 
;b.c,143 :: 		INTCON.TMR0IF=0;
	BCF         INTCON+0, 2 
;b.c,144 :: 		}
L_interrupt19:
;b.c,145 :: 		}
L_end_interrupt:
L__interrupt28:
	RETFIE      1
; end of _interrupt
