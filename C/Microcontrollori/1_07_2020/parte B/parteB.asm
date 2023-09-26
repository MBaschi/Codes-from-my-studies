
_main:

;parteB.c,21 :: 		void main() {
;parteB.c,24 :: 		unsigned short int stato_accensione=0;
	CLRF        main_stato_accensione_L0+0 
	CLRF        main_RC0_VAL_L0+0 
	CLRF        main_RC0_OLD_L0+0 
	MOVLW       25
	MOVWF       main_setpoint_temperatura_L0+0 
	CLRF        main_RC3_VAL_L0+0 
	CLRF        main_RC3_OLD_L0+0 
	CLRF        main_RC4_VAL_L0+0 
	CLRF        main_RC4_OLD_L0+0 
	CLRF        main_adc_res_V_L0+0 
	CLRF        main_adc_res_V_L0+1 
;parteB.c,40 :: 		TRISC.RC0=1;  //pulsante di accensione
	BSF         TRISC+0, 0 
;parteB.c,41 :: 		ANSELC.RC0=0;
	BCF         ANSELC+0, 0 
;parteB.c,43 :: 		TRISE.RE2=0;   // controllo motore
	BCF         TRISE+0, 2 
;parteB.c,44 :: 		ANSELE.RE2=1;  // è necessaria alta impedenza in ingresso per pilotare il motore quindi spengo buffer d'ingresso
	BSF         ANSELE+0, 2 
;parteB.c,46 :: 		TRISC.RC3=1;   // aumenta temperatura
	BSF         TRISC+0, 3 
;parteB.c,47 :: 		ANSELC.RC3=0;
	BCF         ANSELC+0, 3 
;parteB.c,48 :: 		TRISC.RC4=1;   // diminuisci temperatura
	BSF         TRISC+0, 4 
;parteB.c,49 :: 		ANSELC.RC4=0;
	BCF         ANSELC+0, 4 
;parteB.c,51 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;parteB.c,52 :: 		Lcd_Cmd(_LCD_CLEAR);// metti il cursore in posizione uno
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;parteB.c,53 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);// nacondi il cursore
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;parteB.c,54 :: 		Lcd_out(1,1,"SPENTO");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_parteB+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_parteB+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;parteB.c,58 :: 		TRISA.RA0=1;
	BSF         TRISA+0, 0 
;parteB.c,59 :: 		ANSELA.RA0=1;
	BSF         ANSELA+0, 0 
;parteB.c,61 :: 		ADCON0.CHS0= 0;
	BCF         ADCON0+0, 2 
;parteB.c,62 :: 		ADCON0.CHS1= 0;
	BCF         ADCON0+0, 3 
;parteB.c,63 :: 		ADCON0.CHS2= 0;
	BCF         ADCON0+0, 4 
;parteB.c,64 :: 		ADCON0.CHS3= 0;
	BCF         ADCON0+0, 5 
;parteB.c,65 :: 		ADCON0.CHS4= 0;
	BCF         ADCON0+0, 6 
;parteB.c,68 :: 		ADCON2.ADCS0=1;
	BSF         ADCON2+0, 0 
;parteB.c,69 :: 		ADCON2.ADCS1=0;
	BCF         ADCON2+0, 1 
;parteB.c,70 :: 		ADCON2.ADCS2=0;
	BCF         ADCON2+0, 2 
;parteB.c,72 :: 		ADCON2.ACQT0=0;
	BCF         ADCON2+0, 3 
;parteB.c,73 :: 		ADCON2.ACQT1=0;
	BCF         ADCON2+0, 4 
;parteB.c,74 :: 		ADCON2.ACQT2=1;
	BSF         ADCON2+0, 5 
;parteB.c,76 :: 		ADCON2.ADFM=0; // a sinistra perchè usiamo gli 8 but più significativi
	BCF         ADCON2+0, 7 
;parteB.c,78 :: 		ADCON2.ADON=1;
	BSF         ADCON2+0, 0 
;parteB.c,81 :: 		ADCON0.ADON=1; // accendo adc
	BSF         ADCON0+0, 0 
;parteB.c,85 :: 		T0CON=0b11000011;
	MOVLW       195
	MOVWF       T0CON+0 
;parteB.c,86 :: 		INTCON.TMR0IE=1;
	BSF         INTCON+0, 5 
;parteB.c,87 :: 		INTCON.TMR0IF=0;
	BCF         INTCON+0, 2 
;parteB.c,88 :: 		INTCON.GIE=1;
	BSF         INTCON+0, 7 
;parteB.c,100 :: 		ADCON0.GO_NOT_DONE=1; //faccio partire la prima conversione del ADC
	BSF         ADCON0+0, 1 
;parteB.c,101 :: 		while(1){
L_main0:
;parteB.c,103 :: 		RC0_VAL=PORTC.RC0;
	MOVLW       0
	BTFSC       PORTC+0, 0 
	MOVLW       1
	MOVWF       main_RC0_VAL_L0+0 
;parteB.c,105 :: 		if (RC0_VAL!=RC0_OLD && RC0_VAL==1){ // notare che entro solo quando il valore cambio quindi come da richiesta LCD è aggiornato solo quanod è necessario
	MOVF        main_RC0_VAL_L0+0, 0 
	XORWF       main_RC0_OLD_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
	MOVF        main_RC0_VAL_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main4
L__main23:
;parteB.c,107 :: 		stato_accensione=!stato_accensione;
	MOVF        main_stato_accensione_L0+0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       main_stato_accensione_L0+0 
;parteB.c,110 :: 		if (stato_accensione==1){
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main5
;parteB.c,113 :: 		Lcd_cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;parteB.c,114 :: 		Lcd_out(1,1,"ACCESO");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_parteB+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_parteB+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;parteB.c,116 :: 		}
	GOTO        L_main6
L_main5:
;parteB.c,119 :: 		Lcd_cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;parteB.c,120 :: 		Lcd_out(1,1,"SPENTO");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr3_parteB+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr3_parteB+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;parteB.c,121 :: 		}
L_main6:
;parteB.c,122 :: 		}
L_main4:
;parteB.c,123 :: 		RC0_OLD=RC0_VAL;
	MOVF        main_RC0_VAL_L0+0, 0 
	MOVWF       main_RC0_OLD_L0+0 
;parteB.c,126 :: 		if (stato_accensione==1){
	MOVF        main_stato_accensione_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main7
;parteB.c,128 :: 		RC3_VAL=PORTC.RC3;
	MOVLW       0
	BTFSC       PORTC+0, 3 
	MOVLW       1
	MOVWF       main_RC3_VAL_L0+0 
;parteB.c,129 :: 		RC4_VAL=PORTC.RC4;
	MOVLW       0
	BTFSC       PORTC+0, 4 
	MOVLW       1
	MOVWF       main_RC4_VAL_L0+0 
;parteB.c,130 :: 		if(RC3_VAL!=RC3_OLD && RC3_VAL==1 && setpoint_temperatura<50 ){ //aumenta
	MOVF        main_RC3_VAL_L0+0, 0 
	XORWF       main_RC3_OLD_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main10
	MOVF        main_RC3_VAL_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main10
	MOVLW       50
	SUBWF       main_setpoint_temperatura_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main10
L__main22:
;parteB.c,131 :: 		setpoint_temperatura+=1;
	INCF        main_setpoint_temperatura_L0+0, 1 
;parteB.c,132 :: 		}
L_main10:
;parteB.c,134 :: 		if(RC4_VAL!=RC4_OLD && RC4_VAL==1 && setpoint_temperatura>10 ){ //diminuisce
	MOVF        main_RC4_VAL_L0+0, 0 
	XORWF       main_RC4_OLD_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main13
	MOVF        main_RC4_VAL_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main13
	MOVF        main_setpoint_temperatura_L0+0, 0 
	SUBLW       10
	BTFSC       STATUS+0, 0 
	GOTO        L_main13
L__main21:
;parteB.c,135 :: 		setpoint_temperatura-=1;
	DECF        main_setpoint_temperatura_L0+0, 1 
;parteB.c,136 :: 		}
L_main13:
;parteB.c,137 :: 		RC3_OLD=RC3_VAL;
	MOVF        main_RC3_VAL_L0+0, 0 
	MOVWF       main_RC3_OLD_L0+0 
;parteB.c,138 :: 		RC4_OLD=RC4_VAL;
	MOVF        main_RC4_VAL_L0+0, 0 
	MOVWF       main_RC4_OLD_L0+0 
;parteB.c,143 :: 		if(clk>1000){
	MOVLW       128
	XORLW       3
	MOVWF       R0 
	MOVLW       128
	XORWF       _clk+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main25
	MOVF        _clk+0, 0 
	SUBLW       232
L__main25:
	BTFSC       STATUS+0, 0 
	GOTO        L_main14
;parteB.c,146 :: 		clk=0;
	CLRF        _clk+0 
	CLRF        _clk+1 
;parteB.c,147 :: 		ADCON0.GO_NOT_DONE=1;
	BSF         ADCON0+0, 1 
;parteB.c,148 :: 		adc_res_V=ADRESH;
	MOVF        ADRESH+0, 0 
	MOVWF       main_adc_res_V_L0+0 
	MOVLW       0
	MOVWF       main_adc_res_V_L0+1 
;parteB.c,149 :: 		adc_res_V=adc_res_V*4*5/1000;
	MOVF        main_adc_res_V_L0+0, 0 
	MOVWF       R0 
	MOVF        main_adc_res_V_L0+1, 0 
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       5
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R0, 0 
	MOVWF       main_adc_res_V_L0+0 
	MOVF        R1, 0 
	MOVWF       main_adc_res_V_L0+1 
;parteB.c,150 :: 		T=adc_res_V*8+10;
	MOVLW       3
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       R2 
	MOVF        R3, 0 
L__main26:
	BZ          L__main27
	RLCF        R2, 1 
	BCF         R2, 0 
	ADDLW       255
	GOTO        L__main26
L__main27:
	MOVLW       10
	ADDWF       R2, 0 
	MOVWF       R3 
	MOVF        R3, 0 
	MOVWF       main_T_L0+0 
;parteB.c,153 :: 		if (T>setpoint_temperatura+1 || T<setpoint_temperatura-1){
	MOVF        main_setpoint_temperatura_L0+0, 0 
	ADDLW       1
	MOVWF       R1 
	CLRF        R2 
	MOVLW       0
	ADDWFC      R2, 1 
	MOVLW       128
	XORWF       R2, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main28
	MOVF        R3, 0 
	SUBWF       R1, 0 
L__main28:
	BTFSS       STATUS+0, 0 
	GOTO        L__main20
	DECF        main_setpoint_temperatura_L0+0, 0 
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
	GOTO        L__main29
	MOVF        R1, 0 
	SUBWF       main_T_L0+0, 0 
L__main29:
	BTFSS       STATUS+0, 0 
	GOTO        L__main20
	GOTO        L_main17
L__main20:
;parteB.c,154 :: 		LATE.RE2=1;
	BSF         LATE+0, 2 
;parteB.c,155 :: 		}
	GOTO        L_main18
L_main17:
;parteB.c,157 :: 		LATE.RE2=0;
	BCF         LATE+0, 2 
;parteB.c,158 :: 		}
L_main18:
;parteB.c,160 :: 		}
L_main14:
;parteB.c,162 :: 		IntToStr(setpoint_temperatura,setpoint_temperatura_char);
	MOVF        main_setpoint_temperatura_L0+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVLW       0
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_setpoint_temperatura_char_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_setpoint_temperatura_char_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;parteB.c,163 :: 		Lcd_out(2,3,setpoint_temperatura_char);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       3
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_setpoint_temperatura_char_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_setpoint_temperatura_char_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;parteB.c,164 :: 		IntToStr(T,T_char);
	MOVF        main_T_L0+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVLW       0
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_T_char_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_T_char_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;parteB.c,165 :: 		Lcd_out(2,1,T_char);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_T_char_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_T_char_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;parteB.c,166 :: 		}
L_main7:
;parteB.c,168 :: 		}
	GOTO        L_main0
;parteB.c,169 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_interrupt:

;parteB.c,172 :: 		void interrupt(){
;parteB.c,173 :: 		INTCON.GIE=0;
	BCF         INTCON+0, 7 
;parteB.c,174 :: 		if (INTCON.TMR0IF){
	BTFSS       INTCON+0, 2 
	GOTO        L_interrupt19
;parteB.c,175 :: 		INTCON.TMR0IF=0;
	BCF         INTCON+0, 2 
;parteB.c,176 :: 		clk+=1;//ms
	INFSNZ      _clk+0, 1 
	INCF        _clk+1, 1 
;parteB.c,178 :: 		}
L_interrupt19:
;parteB.c,180 :: 		INTCON.GIE=1;
	BSF         INTCON+0, 7 
;parteB.c,181 :: 		}
L_end_interrupt:
L__interrupt31:
	RETFIE      1
; end of _interrupt
