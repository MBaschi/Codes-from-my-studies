
_main:

;A.c,17 :: 		void main() {
;A.c,19 :: 		unsigned short int stato_accensione=0;
	CLRF        main_stato_accensione_L0+0 
;A.c,28 :: 		TRISC=0b00011001;
	MOVLW       25
	MOVWF       TRISC+0 
;A.c,29 :: 		ANSELC=0b11100110;
	MOVLW       230
	MOVWF       ANSELC+0 
;A.c,31 :: 		TRISE.RE2=0;
	BCF         TRISE+0, 2 
;A.c,32 :: 		ANSELE.RE2=1;
	BSF         ANSELE+0, 2 
;A.c,34 :: 		TRISA.RA4=0;
	BCF         TRISA+0, 4 
;A.c,35 :: 		ANSELA.RA4=1;
	BSF         ANSELA+0, 4 
;A.c,37 :: 		Lcd_init();
	CALL        _Lcd_Init+0, 0
;A.c,38 :: 		Lcd_cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;A.c,39 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;A.c,40 :: 		Lcd_Out(1,1,"SPENTO");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_A+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_A+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;A.c,43 :: 		while (1){
L_main0:
;A.c,44 :: 		RC0_new=PORTC.RC0;
	MOVLW       0
	BTFSC       PORTC+0, 0 
	MOVLW       1
	MOVWF       main_RC0_new_L0+0 
;A.c,46 :: 		if(RC0_new==1 && RC0_new!=RC0_old){  //ACCENSIONE
	MOVF        main_RC0_new_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main4
	MOVF        main_RC0_new_L0+0, 0 
	XORWF       main_RC0_old_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
L__main7:
;A.c,47 :: 		stato_accensione=!stato_accensione; //cambia stato
	MOVF        main_stato_accensione_L0+0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       main_stato_accensione_L0+0 
;A.c,50 :: 		if (stato_accensione==0){
	MOVF        R1, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main5
;A.c,51 :: 		Lcd_cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;A.c,52 :: 		Lcd_Out(1,1,"SPENTO"); //comunica stato
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_A+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_A+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;A.c,53 :: 		LATE.RE2=0; //spegni motore
	BCF         LATE+0, 2 
;A.c,54 :: 		LATA.RA4=0; //spegni led
	BCF         LATA+0, 4 
;A.c,55 :: 		}
L_main5:
;A.c,57 :: 		if (stato_accensione==1){
	MOVF        main_stato_accensione_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main6
;A.c,58 :: 		Lcd_cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;A.c,59 :: 		Lcd_Out(1,1,"ACCESO");//comunica stato
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr3_A+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr3_A+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;A.c,60 :: 		LATE.RE2=1;   //accendi motore
	BSF         LATE+0, 2 
;A.c,61 :: 		LATA.RA4=1;   //accendi led
	BSF         LATA+0, 4 
;A.c,62 :: 		}
L_main6:
;A.c,63 :: 		}
L_main4:
;A.c,65 :: 		RC0_old=RC0_new; //salvo vecchio valore per vedere se cambia
	MOVF        main_RC0_new_L0+0, 0 
	MOVWF       main_RC0_old_L0+0 
;A.c,67 :: 		}
	GOTO        L_main0
;A.c,68 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
