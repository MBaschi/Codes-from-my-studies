
_main:

;parteA.c,18 :: 		void main() {
;parteA.c,21 :: 		unsigned short int stato_accensione=0;
	CLRF        main_stato_accensione_L0+0 
	CLRF        main_RC0_VAL_L0+0 
	CLRF        main_RC0_OLD_L0+0 
;parteA.c,25 :: 		TRISC.RC0=1;  //pulsante di accensione
	BSF         TRISC+0, 0 
;parteA.c,26 :: 		ANSELC.RC0=0;
	BCF         ANSELC+0, 0 
;parteA.c,27 :: 		TRISE.RE2=0;   // controllo motore
	BCF         TRISE+0, 2 
;parteA.c,28 :: 		ANSELE.RE2=1;  // è necessaria alta impedenza in ingresso per pilotare il motore quindi spengo buffer d'ingresso
	BSF         ANSELE+0, 2 
;parteA.c,30 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;parteA.c,31 :: 		Lcd_Cmd(_LCD_CLEAR);// metti il cursore in posizione uno
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;parteA.c,32 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);// nacondi il cursore
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;parteA.c,37 :: 		while(1){
L_main0:
;parteA.c,39 :: 		RC0_VAL=PORTC.RC0;
	MOVLW       0
	BTFSC       PORTC+0, 0 
	MOVLW       1
	MOVWF       main_RC0_VAL_L0+0 
;parteA.c,41 :: 		if (RC0_VAL!=RC0_OLD && RC0_VAL==1){ // notare che entro solo quando il valore cambio quindi come da richiesta LCD è aggiornato solo quanod è necessario
	MOVF        main_RC0_VAL_L0+0, 0 
	XORWF       main_RC0_OLD_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
	MOVF        main_RC0_VAL_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main4
L__main7:
;parteA.c,43 :: 		stato_accensione=!stato_accensione;
	MOVF        main_stato_accensione_L0+0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       main_stato_accensione_L0+0 
;parteA.c,46 :: 		if (stato_accensione==1){
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main5
;parteA.c,48 :: 		LATE.RE2=1;
	BSF         LATE+0, 2 
;parteA.c,49 :: 		Lcd_cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;parteA.c,50 :: 		Lcd_out(1,1,"ACCESO");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_parteA+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_parteA+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;parteA.c,52 :: 		}
	GOTO        L_main6
L_main5:
;parteA.c,54 :: 		LATE.RE2=0;
	BCF         LATE+0, 2 
;parteA.c,55 :: 		Lcd_cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;parteA.c,56 :: 		Lcd_out(1,1,"SPENTO");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_parteA+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_parteA+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;parteA.c,57 :: 		}
L_main6:
;parteA.c,58 :: 		}
L_main4:
;parteA.c,59 :: 		RC0_OLD=RC0_VAL;
	MOVF        main_RC0_VAL_L0+0, 0 
	MOVWF       main_RC0_OLD_L0+0 
;parteA.c,63 :: 		}
	GOTO        L_main0
;parteA.c,64 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
