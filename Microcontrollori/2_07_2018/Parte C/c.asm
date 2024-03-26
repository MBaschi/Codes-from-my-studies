
_main:

;c.c,20 :: 		void main() {
;c.c,23 :: 		unsigned short int timer_value=30;
	MOVLW       30
	MOVWF       main_timer_value_L0+0 
	MOVLW       30
	MOVWF       main_timer_init_value_L0+0 
	MOVLW       1
	MOVWF       main_go_L0+0 
;c.c,43 :: 		TRISD=0;
	CLRF        TRISD+0 
;c.c,44 :: 		ANSELD=255;
	MOVLW       255
	MOVWF       ANSELD+0 
;c.c,47 :: 		TRISE.RE2=0;
	BCF         TRISE+0, 2 
;c.c,48 :: 		ANSELE.RE2=1;
	BSF         ANSELE+0, 2 
;c.c,49 :: 		LATE.RE2=0;
	BCF         LATE+0, 2 
;c.c,51 :: 		TRISA=0b00001111;
	MOVLW       15
	MOVWF       TRISA+0 
;c.c,52 :: 		ANSELA=0b11110000;
	MOVLW       240
	MOVWF       ANSELA+0 
;c.c,54 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;c.c,55 :: 		Lcd_cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;c.c,56 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;c.c,58 :: 		ADCON0=00010001;
	MOVLW       1
	MOVWF       ADCON0+0 
;c.c,59 :: 		ADCON2=10100001; //left justified, TAD=8*(8/fosc)=8us>7,45us ho cercato di avvicinarmi il più possibile al tempo minimo di conversione viste la necessità di essere particolarmente reattivi
	MOVLW       33
	MOVWF       ADCON2+0 
;c.c,60 :: 		TRISA.RA5=1;
	BSF         TRISA+0, 5 
;c.c,63 :: 		T0CON=0b11000111;
	MOVLW       199
	MOVWF       T0CON+0 
;c.c,64 :: 		TMR0L=217;
	MOVLW       217
	MOVWF       TMR0L+0 
;c.c,67 :: 		INTCON=0b11100000; //T_overflow=(4/fosc)*(256-TMR0L)*PSA, siccome è richiesta una precisione del 5%
	MOVLW       224
	MOVWF       INTCON+0 
;c.c,70 :: 		PIE1.ADIE=1;
	BSF         PIE1+0, 6 
;c.c,71 :: 		PIR1.ADIF=0;
	BCF         PIR1+0, 6 
;c.c,73 :: 		ADCON0.GO_NOT_DONE=1;
	BSF         ADCON0+0, 1 
;c.c,75 :: 		while (PORTA.RA0==0){ // quando premo start non posso più cambiare il valore iniziale del cronometro
L_main0:
	BTFSC       PORTA+0, 0 
	GOTO        L_main1
;c.c,77 :: 		RA2_NEW=PORTA.RA2;
	MOVLW       0
	BTFSC       PORTA+0, 2 
	MOVLW       1
	MOVWF       main_RA2_NEW_L0+0 
;c.c,78 :: 		RA3_NEW=PORTA.RA3;
	MOVLW       0
	BTFSC       PORTA+0, 3 
	MOVLW       1
	MOVWF       main_RA3_NEW_L0+0 
;c.c,80 :: 		if (RA2_NEW && RA2_NEW!=RA2_OLD){
	MOVF        main_RA2_NEW_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
	MOVF        main_RA2_NEW_L0+0, 0 
	XORWF       main_RA2_OLD_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
L__main30:
;c.c,81 :: 		timer_init_value+=5;
	MOVLW       5
	ADDWF       main_timer_init_value_L0+0, 1 
;c.c,82 :: 		}
L_main4:
;c.c,84 :: 		if (RA3_NEW && RA3_NEW!=RA3_OLD){
	MOVF        main_RA3_NEW_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main7
	MOVF        main_RA3_NEW_L0+0, 0 
	XORWF       main_RA3_OLD_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main7
L__main29:
;c.c,85 :: 		timer_init_value-=5;
	MOVLW       5
	SUBWF       main_timer_init_value_L0+0, 1 
;c.c,86 :: 		}
L_main7:
;c.c,88 :: 		timer_value=timer_init_value;
	MOVF        main_timer_init_value_L0+0, 0 
	MOVWF       main_timer_value_L0+0 
;c.c,89 :: 		IntToStr(timer_value,timer_value_char);
	MOVF        main_timer_init_value_L0+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVLW       0
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_timer_value_char_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_timer_value_char_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;c.c,90 :: 		Lcd_Out(1,1,timer_value_char);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_timer_value_char_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_timer_value_char_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;c.c,92 :: 		RA2_OLD=RA2_NEW;
	MOVF        main_RA2_NEW_L0+0, 0 
	MOVWF       main_RA2_OLD_L0+0 
;c.c,93 :: 		RA3_OLD=RA3_NEW;
	MOVF        main_RA3_NEW_L0+0, 0 
	MOVWF       main_RA3_OLD_L0+0 
;c.c,94 :: 		}
	GOTO        L_main0
L_main1:
;c.c,95 :: 		LATD=timer_value;
	MOVF        main_timer_value_L0+0, 0 
	MOVWF       LATD+0 
;c.c,105 :: 		while(timer_value>=0){
L_main8:
	MOVLW       0
	SUBWF       main_timer_value_L0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_main9
;c.c,107 :: 		RA0_NEW=PORTA.RA0;
	MOVLW       0
	BTFSC       PORTA+0, 0 
	MOVLW       1
	MOVWF       main_RA0_NEW_L0+0 
;c.c,108 :: 		RA1_NEW=PORTA.RA1;
	MOVLW       0
	BTFSC       PORTA+0, 1 
	MOVLW       1
	MOVWF       main_RA1_NEW_L0+0 
;c.c,110 :: 		if (RA0_NEW && RA0_NEW!=RA0_OLD){
	MOVF        main_RA0_NEW_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main12
	MOVF        main_RA0_NEW_L0+0, 0 
	XORWF       main_RA0_OLD_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main12
L__main28:
;c.c,111 :: 		go=1;
	MOVLW       1
	MOVWF       main_go_L0+0 
;c.c,112 :: 		INTCON.TMR0IE=1; //il valore di clock può essere aggiornato
	BSF         INTCON+0, 5 
;c.c,114 :: 		}
L_main12:
;c.c,116 :: 		if (RA1_NEW && RA1_NEW!=RA1_OLD){
	MOVF        main_RA1_NEW_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main15
	MOVF        main_RA1_NEW_L0+0, 0 
	XORWF       main_RA1_OLD_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main15
L__main27:
;c.c,117 :: 		go=0;
	CLRF        main_go_L0+0 
;c.c,118 :: 		INTCON.TMR0IE=0; //il valore di clock non deve essere aggiornato
	BCF         INTCON+0, 5 
;c.c,119 :: 		}
L_main15:
;c.c,121 :: 		RA0_OLD=RA2_NEW;
	MOVF        main_RA2_NEW_L0+0, 0 
	MOVWF       main_RA0_OLD_L0+0 
;c.c,122 :: 		RA3_OLD=RA3_NEW;
	MOVF        main_RA3_NEW_L0+0, 0 
	MOVWF       main_RA3_OLD_L0+0 
;c.c,125 :: 		if (counter>100 && go){
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       _counter+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main32
	MOVF        _counter+0, 0 
	SUBLW       100
L__main32:
	BTFSC       STATUS+0, 0 
	GOTO        L_main18
	MOVF        main_go_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main18
L__main26:
;c.c,127 :: 		IntToStr(timer_value,timer_value_char);
	MOVF        main_timer_value_L0+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVLW       0
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_timer_value_char_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_timer_value_char_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;c.c,128 :: 		Lcd_Out(1,1,timer_value_char);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_timer_value_char_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_timer_value_char_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;c.c,129 :: 		timer_value-=1;
	DECF        main_timer_value_L0+0, 1 
;c.c,130 :: 		LATD=timer_value;
	MOVF        main_timer_value_L0+0, 0 
	MOVWF       LATD+0 
;c.c,131 :: 		counter=0;
	CLRF        _counter+0 
	CLRF        _counter+1 
;c.c,132 :: 		LATE.RE2=1;
	BSF         LATE+0, 2 
;c.c,134 :: 		}
L_main18:
;c.c,137 :: 		if(new_val_adc){
	MOVF        _new_val_adc+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main19
;c.c,138 :: 		val_adc=ADRESH*4+ADRESL/64;
	MOVF        ADRESH+0, 0 
	MOVWF       R2 
	MOVLW       0
	MOVWF       R3 
	RLCF        R2, 1 
	RLCF        R3, 1 
	BCF         R2, 0 
	RLCF        R2, 1 
	RLCF        R3, 1 
	BCF         R2, 0 
	MOVLW       6
	MOVWF       R1 
	MOVF        ADRESL+0, 0 
	MOVWF       R0 
	MOVF        R1, 0 
L__main33:
	BZ          L__main34
	RRCF        R0, 1 
	BCF         R0, 7 
	ADDLW       255
	GOTO        L__main33
L__main34:
	MOVLW       0
	MOVWF       R1 
	MOVF        R2, 0 
	ADDWF       R0, 1 
	MOVF        R3, 0 
	ADDWFC      R1, 1 
;c.c,143 :: 		if (val_adc*5>2976 && timer_value<timer_init_value-1){ // ho dovuto inserire la seconda condizione perchè le prime letture del adc mi davano un valore alto che non corrispondeva a quello reale ed entrava subito nel if
	MOVLW       5
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       128
	XORLW       11
	MOVWF       R2 
	MOVLW       128
	XORWF       R1, 0 
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main35
	MOVF        R0, 0 
	SUBLW       160
L__main35:
	BTFSC       STATUS+0, 0 
	GOTO        L_main22
	DECF        main_timer_init_value_L0+0, 0 
	MOVWF       R1 
	CLRF        R2 
	MOVLW       0
	SUBWFB      R2, 1 
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       R2, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main36
	MOVF        R1, 0 
	SUBWF       main_timer_value_L0+0, 0 
L__main36:
	BTFSC       STATUS+0, 0 
	GOTO        L_main22
L__main25:
;c.c,144 :: 		Lcd_Out(2,1,"ABORTED");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_c+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_c+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;c.c,145 :: 		go=0;
	CLRF        main_go_L0+0 
;c.c,146 :: 		}
L_main22:
;c.c,148 :: 		}
L_main19:
;c.c,150 :: 		}
	GOTO        L_main8
L_main9:
;c.c,154 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_interrupt:

;c.c,158 :: 		void interrupt(){
;c.c,159 :: 		if (INTCON.TMR0IF){
	BTFSS       INTCON+0, 2 
	GOTO        L_interrupt23
;c.c,161 :: 		INTCON.TMR0IE=0;
	BCF         INTCON+0, 5 
;c.c,162 :: 		counter+=5; //ms
	MOVLW       5
	ADDWF       _counter+0, 1 
	MOVLW       0
	ADDWFC      _counter+1, 1 
;c.c,164 :: 		INTCON.TMR0IE=1;
	BSF         INTCON+0, 5 
;c.c,165 :: 		INTCON.TMR0IF=0;
	BCF         INTCON+0, 2 
;c.c,166 :: 		}
L_interrupt23:
;c.c,168 :: 		if (PIR1.ADIF){
	BTFSS       PIR1+0, 6 
	GOTO        L_interrupt24
;c.c,169 :: 		PIR1.ADIE=0;
	BCF         PIR1+0, 6 
;c.c,170 :: 		new_val_adc=1;
	MOVLW       1
	MOVWF       _new_val_adc+0 
;c.c,171 :: 		ADCON0.GO_NOT_DONE=1;
	BSF         ADCON0+0, 1 
;c.c,172 :: 		PIR1.ADIF=1;
	BSF         PIR1+0, 6 
;c.c,173 :: 		PIR1.ADIE=0;
	BCF         PIR1+0, 6 
;c.c,174 :: 		}
L_interrupt24:
;c.c,175 :: 		}
L_end_interrupt:
L__interrupt38:
	RETFIE      1
; end of _interrupt
