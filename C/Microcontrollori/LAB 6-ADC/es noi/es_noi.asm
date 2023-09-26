
_main:

;es_noi.c,22 :: 		void main() {
;es_noi.c,26 :: 		unsigned short int channel=1; // channel=1 leggi pin A0 channel=0 leggi pin D0
	MOVLW       1
	MOVWF       main_channel_L0+0 
;es_noi.c,32 :: 		TRISA.RA0=1; //port RA0 input
	BSF         TRISA+0, 0 
;es_noi.c,33 :: 		ANSELA.RA0=1;
	BSF         ANSELA+0, 0 
;es_noi.c,34 :: 		TRISD.RD0=1;//port RD0 input
	BSF         TRISD+0, 0 
;es_noi.c,35 :: 		ANSELD.RD0=1;
	BSF         ANSELD+0, 0 
;es_noi.c,37 :: 		TRISC=0;
	CLRF        TRISC+0 
;es_noi.c,41 :: 		ADCON2.ADCS0=1;
	BSF         ADCON2+0, 0 
;es_noi.c,42 :: 		ADCON2.ADCS0=0;
	BCF         ADCON2+0, 0 
;es_noi.c,43 :: 		ADCON2.ADCS0=0;
	BCF         ADCON2+0, 0 
;es_noi.c,45 :: 		ADCON2.ACQT0=0;
	BCF         ADCON2+0, 3 
;es_noi.c,46 :: 		ADCON2.ACQT1=0;
	BCF         ADCON2+0, 4 
;es_noi.c,47 :: 		ADCON2.ACQT2=1;
	BSF         ADCON2+0, 5 
;es_noi.c,49 :: 		ADCON0.CHS0=0;
	BCF         ADCON0+0, 2 
;es_noi.c,50 :: 		ADCON0.CHS1=0;
	BCF         ADCON0+0, 3 
;es_noi.c,51 :: 		ADCON0.CHS2=0;
	BCF         ADCON0+0, 4 
;es_noi.c,52 :: 		ADCON0.CHS3=0;
	BCF         ADCON0+0, 5 
;es_noi.c,53 :: 		ADCON0.CHS4=0;
	BCF         ADCON0+0, 6 
;es_noi.c,55 :: 		ADCON2.ADFM=0;
	BCF         ADCON2+0, 7 
;es_noi.c,58 :: 		ADCON0.ADON=1;
	BSF         ADCON0+0, 0 
;es_noi.c,60 :: 		Lcd_Init(); // inizzializza LCD
	CALL        _Lcd_Init+0, 0
;es_noi.c,61 :: 		Lcd_Cmd(_LCD_CLEAR);// metti il cursore in posizione uno
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;es_noi.c,62 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);// nacondi il cursore
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;es_noi.c,63 :: 		Lcd_Out(1,4,"ciaooooooooooooooooooo");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       4
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_es_noi+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_es_noi+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;es_noi.c,65 :: 		PIE1.ADIE=1;
	BSF         PIE1+0, 6 
;es_noi.c,66 :: 		PIR1.ADIF=0;
	BCF         PIR1+0, 6 
;es_noi.c,67 :: 		INTCON.PEIE=1;
	BSF         INTCON+0, 6 
;es_noi.c,68 :: 		INTCON.GIE=1;
	BSF         INTCON+0, 7 
;es_noi.c,74 :: 		ADCON0.GO_NOT_DONE=1;
	BSF         ADCON0+0, 1 
;es_noi.c,75 :: 		Lcd_Out(2,4,"ciaoooooooooooooooooo");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       4
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_es_noi+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_es_noi+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;es_noi.c,77 :: 		while (1){
L_main0:
;es_noi.c,80 :: 		if (new_value==1){ // è arrivato un nuovo dato
	MOVF        _new_value+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main2
;es_noi.c,83 :: 		if (channel==1){ // devo leggere RA0
	MOVF        main_channel_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main3
;es_noi.c,85 :: 		adc_10bit=5*(ADRESH*4+ADRESL); // sommo ADRESL con ADRESH*4 con ADRESH non faccio il doppio shift perchè ADRESH  è a 8 bit e salvandola su se stessa perderei i 2 bit più significativi
	MOVF        ADRESH+0, 0 
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
;es_noi.c,86 :: 		IntToStr(pot1_mv,adc_10bit);
	MOVLW       main_pot1_mv_L0+0
	MOVWF       FARG_IntToStr_input+0 
	MOVLW       hi_addr(main_pot1_mv_L0+0)
	MOVWF       FARG_IntToStr_input+1 
	MOVF        R0, 0 
	MOVWF       FARG_IntToStr_output+0 
	MOVF        R1, 0 
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;es_noi.c,89 :: 		ADCON0.CHS0=0;
	BCF         ADCON0+0, 2 
;es_noi.c,90 :: 		ADCON0.CHS1=0;
	BCF         ADCON0+0, 3 
;es_noi.c,91 :: 		ADCON0.CHS2=1;
	BSF         ADCON0+0, 4 
;es_noi.c,92 :: 		ADCON0.CHS3=0;
	BCF         ADCON0+0, 5 
;es_noi.c,93 :: 		ADCON0.CHS4=1;
	BSF         ADCON0+0, 6 
;es_noi.c,94 :: 		}
L_main3:
;es_noi.c,96 :: 		if (channel==0){ // devo leggere RD0
	MOVF        main_channel_L0+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main4
;es_noi.c,97 :: 		adc_8bit=5*4*ADRESH; // salvo solo i primi, moltiplico per 4 perche mancano due LSB e per 5 per avere il valore in mv
	MOVLW       20
	MULWF       ADRESH+0 
	MOVF        PRODL+0, 0 
	MOVWF       FARG_IntToStr_output+0 
;es_noi.c,98 :: 		IntToStr(pot2_mv,adc_8bit);
	MOVLW       main_pot2_mv_L0+0
	MOVWF       FARG_IntToStr_input+0 
	MOVLW       hi_addr(main_pot2_mv_L0+0)
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       0
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;es_noi.c,100 :: 		ADCON0.CHS0=0;
	BCF         ADCON0+0, 2 
;es_noi.c,101 :: 		ADCON0.CHS1=0;
	BCF         ADCON0+0, 3 
;es_noi.c,102 :: 		ADCON0.CHS2=0;
	BCF         ADCON0+0, 4 
;es_noi.c,103 :: 		ADCON0.CHS3=0;
	BCF         ADCON0+0, 5 
;es_noi.c,104 :: 		ADCON0.CHS4=0;
	BCF         ADCON0+0, 6 
;es_noi.c,105 :: 		LATC=ADRESH;
	MOVF        ADRESH+0, 0 
	MOVWF       LATC+0 
;es_noi.c,106 :: 		}
L_main4:
;es_noi.c,110 :: 		new_value=0;     // riazzera new value
	CLRF        _new_value+0 
;es_noi.c,112 :: 		ADCON0.GO_NOT_DONE=1; // riprarti con conversione
	BSF         ADCON0+0, 1 
;es_noi.c,113 :: 		}
L_main2:
;es_noi.c,116 :: 		}
	GOTO        L_main0
;es_noi.c,118 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_interrupt:

;es_noi.c,120 :: 		void interrupt(){
;es_noi.c,122 :: 		if (PIR1.ADIF==1){
	BTFSS       PIR1+0, 6 
	GOTO        L_interrupt5
;es_noi.c,123 :: 		PIR1.ADIE=0;
	BCF         PIR1+0, 6 
;es_noi.c,124 :: 		PIR1.ADIF=0;
	BCF         PIR1+0, 6 
;es_noi.c,125 :: 		new_value=1; // di al programma chè è arrivato un nuovo valore
	MOVLW       1
	MOVWF       _new_value+0 
;es_noi.c,127 :: 		PIR1.ADIE=1;
	BSF         PIR1+0, 6 
;es_noi.c,128 :: 		}
L_interrupt5:
;es_noi.c,131 :: 		}
L_end_interrupt:
L__interrupt8:
	RETFIE      1
; end of _interrupt
