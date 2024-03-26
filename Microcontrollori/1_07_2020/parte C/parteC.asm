
_abs:

;parteC.c,21 :: 		unsigned short int abs(int x){
;parteC.c,22 :: 		if (x>=0){
	MOVLW       128
	XORWF       FARG_abs_x+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__abs26
	MOVLW       0
	SUBWF       FARG_abs_x+0, 0 
L__abs26:
	BTFSS       STATUS+0, 0 
	GOTO        L_abs0
;parteC.c,23 :: 		return x;
	MOVF        FARG_abs_x+0, 0 
	MOVWF       R0 
	GOTO        L_end_abs
;parteC.c,24 :: 		}
L_abs0:
;parteC.c,26 :: 		return -x;
	MOVF        FARG_abs_x+0, 0 
	SUBLW       0
	MOVWF       R0 
;parteC.c,29 :: 		}
L_end_abs:
	RETURN      0
; end of _abs

_main:

;parteC.c,31 :: 		void main() {
;parteC.c,34 :: 		unsigned short int stato_accensione=0;
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
;parteC.c,53 :: 		TRISC.RC0=1;  //pulsante di accensione
	BSF         TRISC+0, 0 
;parteC.c,54 :: 		ANSELC.RC0=0;
	BCF         ANSELC+0, 0 
;parteC.c,58 :: 		TRISC.RC3=1;   // aumenta temperatura
	BSF         TRISC+0, 3 
;parteC.c,59 :: 		ANSELC.RC3=0;
	BCF         ANSELC+0, 3 
;parteC.c,60 :: 		TRISC.RC4=1;   // diminuisci temperatura
	BSF         TRISC+0, 4 
;parteC.c,61 :: 		ANSELC.RC4=0;
	BCF         ANSELC+0, 4 
;parteC.c,63 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;parteC.c,64 :: 		Lcd_Cmd(_LCD_CLEAR);// metti il cursore in posizione uno
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;parteC.c,65 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);// nacondi il cursore
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;parteC.c,66 :: 		Lcd_out(1,1,"SPENTO");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_parteC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_parteC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;parteC.c,70 :: 		TRISA.RA0=1;
	BSF         TRISA+0, 0 
;parteC.c,71 :: 		ANSELA.RA0=1;
	BSF         ANSELA+0, 0 
;parteC.c,73 :: 		ADCON0.CHS0= 0;
	BCF         ADCON0+0, 2 
;parteC.c,74 :: 		ADCON0.CHS1= 0;
	BCF         ADCON0+0, 3 
;parteC.c,75 :: 		ADCON0.CHS2= 0;
	BCF         ADCON0+0, 4 
;parteC.c,76 :: 		ADCON0.CHS3= 0;
	BCF         ADCON0+0, 5 
;parteC.c,77 :: 		ADCON0.CHS4= 0;
	BCF         ADCON0+0, 6 
;parteC.c,80 :: 		ADCON2.ADCS0=1;
	BSF         ADCON2+0, 0 
;parteC.c,81 :: 		ADCON2.ADCS1=0;
	BCF         ADCON2+0, 1 
;parteC.c,82 :: 		ADCON2.ADCS2=0;
	BCF         ADCON2+0, 2 
;parteC.c,84 :: 		ADCON2.ACQT0=0;
	BCF         ADCON2+0, 3 
;parteC.c,85 :: 		ADCON2.ACQT1=0;
	BCF         ADCON2+0, 4 
;parteC.c,86 :: 		ADCON2.ACQT2=1;
	BSF         ADCON2+0, 5 
;parteC.c,88 :: 		ADCON2.ADFM=0; // a sinistra perchè usiamo gli 8 but più significativi
	BCF         ADCON2+0, 7 
;parteC.c,90 :: 		ADCON2.ADON=1;
	BSF         ADCON2+0, 0 
;parteC.c,93 :: 		TRISE.RE2=1;   // controllo motore :CCP5
	BSF         TRISE+0, 2 
;parteC.c,94 :: 		ANSELE.RE2=1;  // è necessaria alta impedenza in ingresso per pilotare il motore quindi spengo buffer d'ingresso
	BSF         ANSELE+0, 2 
;parteC.c,96 :: 		CCPTMRS1=0; //timer 2
	CLRF        CCPTMRS1+0 
;parteC.c,97 :: 		T2CON = 0b00000111;
	MOVLW       7
	MOVWF       T2CON+0 
;parteC.c,99 :: 		PR2=255;
	MOVLW       255
	MOVWF       PR2+0 
;parteC.c,101 :: 		CCP5CON.CCP5M3=1;
	BSF         CCP5CON+0, 3 
;parteC.c,102 :: 		CCP5CON.CCP5M2=1;
	BSF         CCP5CON+0, 2 
;parteC.c,104 :: 		CCPR5L=0; //cominciamo con motore spento
	CLRF        CCPR5L+0 
;parteC.c,106 :: 		TRISE.RE2=0;
	BCF         TRISE+0, 2 
;parteC.c,109 :: 		ADCON0.ADON=1; // accendo adc
	BSF         ADCON0+0, 0 
;parteC.c,113 :: 		T0CON=0b11000011;
	MOVLW       195
	MOVWF       T0CON+0 
;parteC.c,114 :: 		INTCON.TMR0IE=1;
	BSF         INTCON+0, 5 
;parteC.c,115 :: 		INTCON.TMR0IF=0;
	BCF         INTCON+0, 2 
;parteC.c,116 :: 		INTCON.GIE=1;
	BSF         INTCON+0, 7 
;parteC.c,128 :: 		ADCON0.GO_NOT_DONE=1; //faccio partire la prima conversione del ADC
	BSF         ADCON0+0, 1 
;parteC.c,129 :: 		while(1){
L_main2:
;parteC.c,131 :: 		RC0_VAL=PORTC.RC0;
	MOVLW       0
	BTFSC       PORTC+0, 0 
	MOVLW       1
	MOVWF       main_RC0_VAL_L0+0 
;parteC.c,133 :: 		if (RC0_VAL!=RC0_OLD && RC0_VAL==1){ // notare che entro solo quando il valore cambio quindi come da richiesta LCD è aggiornato solo quanod è necessario
	MOVF        main_RC0_VAL_L0+0, 0 
	XORWF       main_RC0_OLD_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main6
	MOVF        main_RC0_VAL_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main6
L__main24:
;parteC.c,135 :: 		stato_accensione=!stato_accensione;
	MOVF        main_stato_accensione_L0+0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       main_stato_accensione_L0+0 
;parteC.c,138 :: 		if (stato_accensione==1){
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main7
;parteC.c,141 :: 		Lcd_cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;parteC.c,142 :: 		Lcd_out(1,1,"ACCESO");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_parteC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_parteC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;parteC.c,144 :: 		}
	GOTO        L_main8
L_main7:
;parteC.c,147 :: 		Lcd_cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;parteC.c,148 :: 		Lcd_out(1,1,"SPENTO");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr3_parteC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr3_parteC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;parteC.c,149 :: 		}
L_main8:
;parteC.c,150 :: 		}
L_main6:
;parteC.c,151 :: 		RC0_OLD=RC0_VAL;
	MOVF        main_RC0_VAL_L0+0, 0 
	MOVWF       main_RC0_OLD_L0+0 
;parteC.c,154 :: 		if (stato_accensione==1){
	MOVF        main_stato_accensione_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main9
;parteC.c,156 :: 		RC3_VAL=PORTC.RC3;
	MOVLW       0
	BTFSC       PORTC+0, 3 
	MOVLW       1
	MOVWF       main_RC3_VAL_L0+0 
;parteC.c,157 :: 		RC4_VAL=PORTC.RC4;
	MOVLW       0
	BTFSC       PORTC+0, 4 
	MOVLW       1
	MOVWF       main_RC4_VAL_L0+0 
;parteC.c,158 :: 		if(RC3_VAL!=RC3_OLD && RC3_VAL==1 && setpoint_temperatura<50 ){ //aumenta
	MOVF        main_RC3_VAL_L0+0, 0 
	XORWF       main_RC3_OLD_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main12
	MOVF        main_RC3_VAL_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main12
	MOVLW       50
	SUBWF       main_setpoint_temperatura_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main12
L__main23:
;parteC.c,159 :: 		setpoint_temperatura+=1;
	INCF        main_setpoint_temperatura_L0+0, 1 
;parteC.c,160 :: 		}
L_main12:
;parteC.c,162 :: 		if(RC4_VAL!=RC4_OLD && RC4_VAL==1 && setpoint_temperatura>10 ){ //diminuisce
	MOVF        main_RC4_VAL_L0+0, 0 
	XORWF       main_RC4_OLD_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main15
	MOVF        main_RC4_VAL_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main15
	MOVF        main_setpoint_temperatura_L0+0, 0 
	SUBLW       10
	BTFSC       STATUS+0, 0 
	GOTO        L_main15
L__main22:
;parteC.c,163 :: 		setpoint_temperatura-=1;
	DECF        main_setpoint_temperatura_L0+0, 1 
;parteC.c,164 :: 		}
L_main15:
;parteC.c,165 :: 		RC3_OLD=RC3_VAL;
	MOVF        main_RC3_VAL_L0+0, 0 
	MOVWF       main_RC3_OLD_L0+0 
;parteC.c,166 :: 		RC4_OLD=RC4_VAL;
	MOVF        main_RC4_VAL_L0+0, 0 
	MOVWF       main_RC4_OLD_L0+0 
;parteC.c,171 :: 		if(clk>1000){
	MOVLW       128
	XORLW       3
	MOVWF       R0 
	MOVLW       128
	XORWF       _clk+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main28
	MOVF        _clk+0, 0 
	SUBLW       232
L__main28:
	BTFSC       STATUS+0, 0 
	GOTO        L_main16
;parteC.c,174 :: 		clk=0;
	CLRF        _clk+0 
	CLRF        _clk+1 
;parteC.c,175 :: 		ADCON0.GO_NOT_DONE=1;
	BSF         ADCON0+0, 1 
;parteC.c,176 :: 		adc_res_V=ADRESH;
	MOVF        ADRESH+0, 0 
	MOVWF       main_adc_res_V_L0+0 
	MOVLW       0
	MOVWF       main_adc_res_V_L0+1 
;parteC.c,177 :: 		adc_res_V=adc_res_V*4*5/1000;
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
;parteC.c,178 :: 		T=adc_res_V*8+10;
	MOVLW       3
	MOVWF       R2 
	MOVF        R0, 0 
	MOVWF       FARG_abs_x+0 
	MOVF        R1, 0 
	MOVWF       FARG_abs_x+1 
	MOVF        R2, 0 
L__main29:
	BZ          L__main30
	RLCF        FARG_abs_x+0, 1 
	BCF         FARG_abs_x+0, 0 
	RLCF        FARG_abs_x+1, 1 
	ADDLW       255
	GOTO        L__main29
L__main30:
	MOVLW       10
	ADDWF       FARG_abs_x+0, 1 
;parteC.c,181 :: 		delta_T=abs(T-setpoint_temperatura);
	MOVF        main_setpoint_temperatura_L0+0, 0 
	SUBWF       FARG_abs_x+0, 1 
	CLRF        FARG_abs_x+1 
	MOVLW       0
	SUBWFB      FARG_abs_x+1, 1 
	CALL        _abs+0, 0
	MOVF        R0, 0 
	MOVWF       main_delta_T_L0+0 
;parteC.c,182 :: 		if (delta_T<1){
	MOVLW       1
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main17
;parteC.c,183 :: 		CCPR5L=0;
	CLRF        CCPR5L+0 
;parteC.c,184 :: 		CCP5CON.DC5B0=0;
	BCF         CCP5CON+0, 4 
;parteC.c,185 :: 		CCP5CON.DC5B1=0;
	BCF         CCP5CON+0, 5 
;parteC.c,186 :: 		}
	GOTO        L_main18
L_main17:
;parteC.c,187 :: 		else if(1<=delta_T<=4) {
	MOVLW       1
	SUBWF       main_delta_T_L0+0, 0 
	MOVLW       0
	BTFSC       STATUS+0, 0 
	MOVLW       1
	MOVWF       R1 
	MOVF        R1, 0 
	SUBLW       4
	BTFSS       STATUS+0, 0 
	GOTO        L_main19
;parteC.c,188 :: 		sigma=33*delta_T-33;
	MOVLW       33
	MULWF       main_delta_T_L0+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVLW       33
	SUBWF       R0, 0 
	MOVWF       R4 
	MOVF        R4, 0 
	MOVWF       main_sigma_L0+0 
;parteC.c,190 :: 		CCPR5L=(PR2+1)*sigma/100; //sarebbe 4(PR2+1)*sigma/4 perchè considero solo i bit più significativi ma ovvimanete il 4 si semplifica
	MOVF        PR2+0, 0 
	ADDLW       1
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R0, 0 
	MOVWF       CCPR5L+0 
;parteC.c,192 :: 		}
	GOTO        L_main20
L_main19:
;parteC.c,194 :: 		CCPR5L=255;
	MOVLW       255
	MOVWF       CCPR5L+0 
;parteC.c,195 :: 		CCP5CON.DC5B0=1;
	BSF         CCP5CON+0, 4 
;parteC.c,196 :: 		CCP5CON.DC5B1=1;
	BSF         CCP5CON+0, 5 
;parteC.c,197 :: 		}
L_main20:
L_main18:
;parteC.c,199 :: 		}
L_main16:
;parteC.c,201 :: 		IntToStr(sigma,setpoint_temperatura_char);
	MOVF        main_sigma_L0+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVLW       0
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_setpoint_temperatura_char_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_setpoint_temperatura_char_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;parteC.c,202 :: 		Lcd_out(2,4,setpoint_temperatura_char);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       4
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_setpoint_temperatura_char_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_setpoint_temperatura_char_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;parteC.c,203 :: 		IntToStr(CCPR5L,T_char);
	MOVF        CCPR5L+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVLW       0
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_T_char_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_T_char_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;parteC.c,204 :: 		Lcd_out(2,1,T_char);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_T_char_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_T_char_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;parteC.c,205 :: 		IntToStr(delta_T,delta_T_char);
	MOVF        main_delta_T_L0+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVLW       0
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_delta_T_char_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_delta_T_char_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;parteC.c,206 :: 		Lcd_out(2,7,delta_T_char);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       7
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_delta_T_char_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_delta_T_char_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;parteC.c,210 :: 		}
L_main9:
;parteC.c,212 :: 		}
	GOTO        L_main2
;parteC.c,213 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_interrupt:

;parteC.c,216 :: 		void interrupt(){
;parteC.c,217 :: 		INTCON.GIE=0;
	BCF         INTCON+0, 7 
;parteC.c,218 :: 		if (INTCON.TMR0IF){
	BTFSS       INTCON+0, 2 
	GOTO        L_interrupt21
;parteC.c,219 :: 		INTCON.TMR0IF=0;
	BCF         INTCON+0, 2 
;parteC.c,220 :: 		clk+=1;//ms
	INFSNZ      _clk+0, 1 
	INCF        _clk+1, 1 
;parteC.c,222 :: 		}
L_interrupt21:
;parteC.c,224 :: 		INTCON.GIE=1;
	BSF         INTCON+0, 7 
;parteC.c,225 :: 		}
L_end_interrupt:
L__interrupt32:
	RETFIE      1
; end of _interrupt
