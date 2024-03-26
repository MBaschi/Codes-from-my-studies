
_main:

;A.c,17 :: 		void main() {
;A.c,20 :: 		unsigned short int RA0_NEW=0;
	CLRF        main_RA0_NEW_L0+0 
	CLRF        main_RA0_OLD_L0+0 
	CLRF        main_RA1_NEW_L0+0 
	CLRF        main_RA1_OLD_L0+0 
	CLRF        main_RA2_NEW_L0+0 
	CLRF        main_RA2_OLD_L0+0 
;A.c,29 :: 		TRISA=0b00000111;
	MOVLW       7
	MOVWF       TRISA+0 
;A.c,30 :: 		ANSELA=0b11111000;
	MOVLW       248
	MOVWF       ANSELA+0 
;A.c,32 :: 		TRISE=0;
	CLRF        TRISE+0 
;A.c,33 :: 		LATE=0; //tutto spento inizialmente
	CLRF        LATE+0 
;A.c,36 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;A.c,37 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;A.c,38 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;A.c,39 :: 		Lcd_out(1,1,"VEICOLO SPENTO");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_A+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_A+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;A.c,42 :: 		while(1){
L_main0:
;A.c,44 :: 		RA0_NEW=PORTA.RA0;
	MOVLW       0
	BTFSC       PORTA+0, 0 
	MOVLW       1
	MOVWF       main_RA0_NEW_L0+0 
;A.c,46 :: 		if (RA0_NEW && RA0_NEW!=RA0_OLD){
	MOVF        main_RA0_NEW_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
	MOVF        main_RA0_NEW_L0+0, 0 
	XORWF       main_RA0_OLD_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
L__main16:
;A.c,47 :: 		stato_accensione=!stato_accensione;
	MOVF        main_stato_accensione_L0+0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       main_stato_accensione_L0+0 
;A.c,48 :: 		if (stato_accensione==1){
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main5
;A.c,49 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;A.c,50 :: 		Lcd_out(1,1,"VEICOLO ACCESO");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_A+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_A+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;A.c,51 :: 		LATE.RE0=1;
	BSF         LATE+0, 0 
;A.c,52 :: 		}
	GOTO        L_main6
L_main5:
;A.c,54 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;A.c,55 :: 		Lcd_out(1,1,"VEICOLO SPENTO");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr3_A+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr3_A+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;A.c,56 :: 		LATE.RE0=0;
	BCF         LATE+0, 0 
;A.c,57 :: 		}
L_main6:
;A.c,58 :: 		}
L_main4:
;A.c,59 :: 		RA0_OLD=RA0_NEW;
	MOVF        main_RA0_NEW_L0+0, 0 
	MOVWF       main_RA0_OLD_L0+0 
;A.c,62 :: 		if (stato_accensione==1){
	MOVF        main_stato_accensione_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main7
;A.c,63 :: 		RA1_NEW=PORTA.RA1;
	MOVLW       0
	BTFSC       PORTA+0, 1 
	MOVLW       1
	MOVWF       main_RA1_NEW_L0+0 
;A.c,64 :: 		RA2_NEW=PORTA.RA2;
	MOVLW       0
	BTFSC       PORTA+0, 2 
	MOVLW       1
	MOVWF       main_RA2_NEW_L0+0 
;A.c,66 :: 		if (RA1_NEW && RA1_NEW!=RA1_OLD){
	MOVF        main_RA1_NEW_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main10
	MOVF        main_RA1_NEW_L0+0, 0 
	XORWF       main_RA1_OLD_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main10
L__main15:
;A.c,67 :: 		LATE.RE2=1;
	BSF         LATE+0, 2 
;A.c,68 :: 		}
L_main10:
;A.c,69 :: 		if (RA2_NEW && RA2_NEW!=RA2_OLD){
	MOVF        main_RA2_NEW_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main13
	MOVF        main_RA2_NEW_L0+0, 0 
	XORWF       main_RA2_OLD_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main13
L__main14:
;A.c,70 :: 		LATE.RE2=0;
	BCF         LATE+0, 2 
;A.c,71 :: 		}
L_main13:
;A.c,72 :: 		RA1_OLD=RA1_NEW;
	MOVF        main_RA1_NEW_L0+0, 0 
	MOVWF       main_RA1_OLD_L0+0 
;A.c,73 :: 		RA2_OLD=RA2_NEW;
	MOVF        main_RA2_NEW_L0+0, 0 
	MOVWF       main_RA2_OLD_L0+0 
;A.c,74 :: 		}
L_main7:
;A.c,76 :: 		}
	GOTO        L_main0
;A.c,77 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
