
_main:

;b.c,21 :: 		void main() {
;b.c,24 :: 		unsigned short int conteggio=0;
	CLRF        main_conteggio_L0+0 
	CLRF        main_RD5X_L0+0 
	CLRF        main_RD6X_L0+0 
	CLRF        main_RD7X_L0+0 
	CLRF        main_RD5_old_L0+0 
	CLRF        main_RD6_old_L0+0 
	CLRF        main_RD7_old_L0+0 
	CLRF        main_adc_result_L0+0 
	CLRF        main_adc_result_L0+1 
	CLRF        main_porta_adc_L0+0 
;b.c,43 :: 		TRISD.RD5=1; //incremento
	BSF         TRISD+0, 5 
;b.c,44 :: 		TRISD.RD6=1; //decremento
	BSF         TRISD+0, 6 
;b.c,45 :: 		TRISD.RD7=1; //azzeramento
	BSF         TRISD+0, 7 
;b.c,46 :: 		ANSELD=0;
	CLRF        ANSELD+0 
;b.c,48 :: 		TRISA.RA0=1;
	BSF         TRISA+0, 0 
;b.c,49 :: 		ANSELA.RA0=1;
	BSF         ANSELA+0, 0 
;b.c,50 :: 		TRISD.RD0=1;
	BSF         TRISD+0, 0 
;b.c,51 :: 		ANSELD.RD0=1;
	BSF         ANSELD+0, 0 
;b.c,53 :: 		TRISE.RE2=1;
	BSF         TRISE+0, 2 
;b.c,56 :: 		Lcd_Init(); // inizzializza LCD
	CALL        _Lcd_Init+0, 0
;b.c,57 :: 		Lcd_Cmd(_LCD_CLEAR);// metti il cursore in posizione uno
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;b.c,58 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);// nacondi il cursore
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;b.c,59 :: 		Lcd_Out(1,1,conteggio_char);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_conteggio_char_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_conteggio_char_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;b.c,60 :: 		Lcd_Out(2,1,adc_res_char);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_adc_res_char_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_adc_res_char_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;b.c,64 :: 		ADCON0.CHS0=0;
	BCF         ADCON0+0, 2 
;b.c,65 :: 		ADCON0.CHS1=0;
	BCF         ADCON0+0, 3 
;b.c,66 :: 		ADCON0.CHS2=0;
	BCF         ADCON0+0, 4 
;b.c,67 :: 		ADCON0.CHS3=0;
	BCF         ADCON0+0, 5 
;b.c,68 :: 		ADCON0.CHS4= 0;
	BCF         ADCON0+0, 6 
;b.c,70 :: 		ADCON2.ADCS0=0;
	BCF         ADCON2+0, 0 
;b.c,71 :: 		ADCON2.ADCS0=1;
	BSF         ADCON2+0, 0 
;b.c,72 :: 		ADCON2.ADCS0=0;
	BCF         ADCON2+0, 0 
;b.c,74 :: 		ADCON2.ACQT0=0;
	BCF         ADCON2+0, 3 
;b.c,75 :: 		ADCON2.ACQT0=1;
	BSF         ADCON2+0, 3 
;b.c,76 :: 		ADCON2.ACQT0=0;
	BCF         ADCON2+0, 3 
;b.c,78 :: 		ADCON2.ADFM=1;
	BSF         ADCON2+0, 7 
;b.c,80 :: 		ADCON0.ADON=1;
	BSF         ADCON0+0, 0 
;b.c,82 :: 		ADCON1.PVCFG0=0;
	BCF         ADCON1+0, 2 
;b.c,83 :: 		ADCON1.PVCFG1=0;
	BCF         ADCON1+0, 3 
;b.c,85 :: 		ADCON1.NVCFG0=0;
	BCF         ADCON1+0, 0 
;b.c,86 :: 		ADCON1.NVCFG1=0;
	BCF         ADCON1+0, 1 
;b.c,90 :: 		CCPTMRS1.C5TSEL0=0;
	BCF         CCPTMRS1+0, 2 
;b.c,91 :: 		CCPTMRS1.C5TSEL1=1;
	BSF         CCPTMRS1+0, 3 
;b.c,93 :: 		PR6=255;
	MOVLW       255
	MOVWF       PR6+0 
;b.c,95 :: 		CCP5CON.CCP5M3=1;
	BSF         CCP5CON+0, 3 
;b.c,96 :: 		CCP5CON.CCP5M2=1;
	BSF         CCP5CON+0, 2 
;b.c,98 :: 		T6CON = 0b00000111;
	MOVLW       7
	MOVWF       T6CON+0 
;b.c,100 :: 		TRISE.RE2=0;
	BCF         TRISE+0, 2 
;b.c,102 :: 		PIE1.ADIE=1; //ADC interrupt enable
	BSF         PIE1+0, 6 
;b.c,103 :: 		PIR1.ADIF=0; //ADC interrupt flag
	BCF         PIR1+0, 6 
;b.c,104 :: 		INTCON.PEIE=1;// enable interrupt periferiche
	BSF         INTCON+0, 6 
;b.c,105 :: 		INTCON.GIE=1; // global interrupt enable
	BSF         INTCON+0, 7 
;b.c,111 :: 		ADCON0.GO_NOT_DONE=1; //faccio partire adc
	BSF         ADCON0+0, 1 
;b.c,113 :: 		while (1){
L_main0:
;b.c,115 :: 		RD5X=PORTD.RD5;
	MOVLW       0
	BTFSC       PORTD+0, 5 
	MOVLW       1
	MOVWF       main_RD5X_L0+0 
;b.c,116 :: 		RD6X=PORTD.RD6;
	MOVLW       0
	BTFSC       PORTD+0, 6 
	MOVLW       1
	MOVWF       main_RD6X_L0+0 
;b.c,117 :: 		RD7X=PORTD.RD7;
	MOVLW       0
	BTFSC       PORTD+0, 7 
	MOVLW       1
	MOVWF       main_RD7X_L0+0 
;b.c,119 :: 		if(RD5X && RD5X!=RD5_old && conteggio<255 ){ // aumenta conteggio, NOTA non ho scritto if(PORTD.RD5 && PORTD.RD5!=RD5_old ) perchè avrei letto la porta 2 volte
	MOVF        main_RD5X_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
	MOVF        main_RD5X_L0+0, 0 
	XORWF       main_RD5_old_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
	MOVLW       255
	SUBWF       main_conteggio_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main4
L__main19:
;b.c,120 :: 		conteggio+=1;
	INCF        main_conteggio_L0+0, 1 
;b.c,121 :: 		}
L_main4:
;b.c,123 :: 		if(RD6X && RD6X!=RD6_old && conteggio>0 ){ // diminuisci conteggio
	MOVF        main_RD6X_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main7
	MOVF        main_RD6X_L0+0, 0 
	XORWF       main_RD6_old_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main7
	MOVF        main_conteggio_L0+0, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_main7
L__main18:
;b.c,124 :: 		conteggio-=1;
	DECF        main_conteggio_L0+0, 1 
;b.c,125 :: 		}
L_main7:
;b.c,127 :: 		if(RD7X && RD7X!=RD7_old ){ // azzera conteggio
	MOVF        main_RD7X_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main10
	MOVF        main_RD7X_L0+0, 0 
	XORWF       main_RD7_old_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main10
L__main17:
;b.c,128 :: 		conteggio=0;
	CLRF        main_conteggio_L0+0 
;b.c,129 :: 		}
L_main10:
;b.c,131 :: 		RD5_old=RD5X;
	MOVF        main_RD5X_L0+0, 0 
	MOVWF       main_RD5_old_L0+0 
;b.c,132 :: 		RD6_old=RD6X;
	MOVF        main_RD6X_L0+0, 0 
	MOVWF       main_RD6_old_L0+0 
;b.c,133 :: 		RD7_old=RD7X;
	MOVF        main_RD7X_L0+0, 0 
	MOVWF       main_RD7_old_L0+0 
;b.c,135 :: 		if (new_value==1 && porta_adc==0){ // sto ricevendo il dato da AD0
	MOVF        _new_value+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main13
	MOVF        main_porta_adc_L0+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main13
L__main16:
;b.c,137 :: 		temp =ADRESH;
	MOVF        ADRESH+0, 0 
	MOVWF       main_temp_L0+0 
;b.c,139 :: 		adc_result=ADRESL;
	MOVF        ADRESL+0, 0 
	MOVWF       main_adc_result_L0+0 
	MOVLW       0
	MOVWF       main_adc_result_L0+1 
;b.c,140 :: 		adc_result=(ADRESL+temp*4)*5;
	MOVF        main_temp_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	RLCF        R1, 1 
	BCF         R0, 0 
	RLCF        R0, 1 
	RLCF        R1, 1 
	BCF         R0, 0 
	MOVF        ADRESL+0, 0 
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       5
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       main_adc_result_L0+0 
	MOVF        R1, 0 
	MOVWF       main_adc_result_L0+1 
;b.c,141 :: 		new_value=0;
	CLRF        _new_value+0 
;b.c,143 :: 		ADCON0.CHS0=0;
	BCF         ADCON0+0, 2 
;b.c,144 :: 		ADCON0.CHS1=0;
	BCF         ADCON0+0, 3 
;b.c,145 :: 		ADCON0.CHS2=1;
	BSF         ADCON0+0, 4 
;b.c,146 :: 		ADCON0.CHS3=0;
	BCF         ADCON0+0, 5 
;b.c,147 :: 		ADCON0.CHS4= 1;
	BSF         ADCON0+0, 6 
;b.c,148 :: 		porta_adc=1;
	MOVLW       1
	MOVWF       main_porta_adc_L0+0 
;b.c,149 :: 		new_value=0;
	CLRF        _new_value+0 
;b.c,150 :: 		}
	GOTO        L_main14
L_main13:
;b.c,153 :: 		CCPR5L=ADRESH;
	MOVF        ADRESH+0, 0 
	MOVWF       CCPR5L+0 
;b.c,155 :: 		ADCON0.CHS0=0;
	BCF         ADCON0+0, 2 
;b.c,156 :: 		ADCON0.CHS1=0;
	BCF         ADCON0+0, 3 
;b.c,157 :: 		ADCON0.CHS2=0;
	BCF         ADCON0+0, 4 
;b.c,158 :: 		ADCON0.CHS3=0;
	BCF         ADCON0+0, 5 
;b.c,159 :: 		ADCON0.CHS4= 0;
	BCF         ADCON0+0, 6 
;b.c,160 :: 		porta_adc=0;
	CLRF        main_porta_adc_L0+0 
;b.c,161 :: 		new_value=0;
	CLRF        _new_value+0 
;b.c,162 :: 		IntToStr(ADRESL,adc_res_char1); //adc
	MOVF        ADRESL+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVLW       0
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_adc_res_char1_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_adc_res_char1_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;b.c,163 :: 		Lcd_Out(2,6,adc_res_char1);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       6
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_adc_res_char1_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_adc_res_char1_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;b.c,164 :: 		}
L_main14:
;b.c,166 :: 		IntToStr(conteggio,conteggio_char); //conteggio
	MOVF        main_conteggio_L0+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVLW       0
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_conteggio_char_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_conteggio_char_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;b.c,167 :: 		Lcd_Out(1,1,conteggio_char);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_conteggio_char_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_conteggio_char_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;b.c,169 :: 		IntToStr(adc_result,adc_res_char); //adc
	MOVF        main_adc_result_L0+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        main_adc_result_L0+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_adc_res_char_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_adc_res_char_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;b.c,170 :: 		Lcd_Out(2,1,adc_res_char);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_adc_res_char_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_adc_res_char_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;b.c,171 :: 		}
	GOTO        L_main0
;b.c,172 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_interrupt:

;b.c,174 :: 		void interrupt(){
;b.c,175 :: 		if (PIR1.ADIF){
	BTFSS       PIR1+0, 6 
	GOTO        L_interrupt15
;b.c,176 :: 		new_value=1;
	MOVLW       1
	MOVWF       _new_value+0 
;b.c,177 :: 		PIR1.ADIF=0;
	BCF         PIR1+0, 6 
;b.c,178 :: 		ADCON0.GO_NOT_DONE=1;
	BSF         ADCON0+0, 1 
;b.c,179 :: 		}
L_interrupt15:
;b.c,181 :: 		}
L_end_interrupt:
L__interrupt22:
	RETFIE      1
; end of _interrupt
