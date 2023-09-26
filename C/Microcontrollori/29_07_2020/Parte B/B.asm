
_main:

;B.c,19 :: 		void main() {
;B.c,21 :: 		unsigned short int stato_accensione=0;
	CLRF        main_stato_accensione_L0+0 
	MOVLW       1
	MOVWF       main_velocita_motore_L0+0 
	CLRF        main_vel_change_L0+0 
;B.c,38 :: 		TRISC=0b00011001;
	MOVLW       25
	MOVWF       TRISC+0 
;B.c,39 :: 		ANSELC=0b11100110;
	MOVLW       230
	MOVWF       ANSELC+0 
;B.c,41 :: 		TRISA.RA4=0;
	BCF         TRISA+0, 4 
;B.c,42 :: 		ANSELA.RA4=1;
	BSF         ANSELA+0, 4 
;B.c,44 :: 		TRISD=0;
	CLRF        TRISD+0 
;B.c,45 :: 		ANSELD=255;
	MOVLW       255
	MOVWF       ANSELD+0 
;B.c,46 :: 		LATD=1;
	MOVLW       1
	MOVWF       LATD+0 
;B.c,48 :: 		Lcd_init();
	CALL        _Lcd_Init+0, 0
;B.c,49 :: 		Lcd_cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;B.c,50 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;B.c,51 :: 		Lcd_Out(1,1,"SPENTO");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_B+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_B+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;B.c,55 :: 		TRISE.RE2=1;
	BSF         TRISE+0, 2 
;B.c,56 :: 		ANSELE.RE2=0;
	BCF         ANSELE+0, 2 
;B.c,58 :: 		CCPTMRS1=0; //timer 2
	CLRF        CCPTMRS1+0 
;B.c,60 :: 		PR2=255;
	MOVLW       255
	MOVWF       PR2+0 
;B.c,62 :: 		CCP5CON.CCP5M3=1;
	BSF         CCP5CON+0, 3 
;B.c,63 :: 		CCP5CON.CCP5M2=1;
	BSF         CCP5CON+0, 2 
;B.c,65 :: 		CCPR5L=0;
	CLRF        CCPR5L+0 
;B.c,67 :: 		T2CON=0b00000111;
	MOVLW       7
	MOVWF       T2CON+0 
;B.c,69 :: 		TRISE.RE2=0;
	BCF         TRISE+0, 2 
;B.c,73 :: 		while (1){
L_main0:
;B.c,75 :: 		RC0_new=PORTC.RC0;
	MOVLW       0
	BTFSC       PORTC+0, 0 
	MOVLW       1
	MOVWF       main_RC0_new_L0+0 
;B.c,77 :: 		if(RC0_new==1 && RC0_new!=RC0_old){  //ACCENSIONE
	MOVF        main_RC0_new_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main4
	MOVF        main_RC0_new_L0+0, 0 
	XORWF       main_RC0_old_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
L__main20:
;B.c,78 :: 		stato_accensione=!stato_accensione; //cambia stato
	MOVF        main_stato_accensione_L0+0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       main_stato_accensione_L0+0 
;B.c,81 :: 		if (stato_accensione==0){
	MOVF        R1, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main5
;B.c,82 :: 		Lcd_cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;B.c,83 :: 		Lcd_Out(1,1,"SPENTO"); //comunica stato
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_B+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_B+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;B.c,84 :: 		LATE.RE2=0; //spegni motore
	BCF         LATE+0, 2 
;B.c,85 :: 		LATA.RA4=0; //spegni led
	BCF         LATA+0, 4 
;B.c,86 :: 		}
L_main5:
;B.c,88 :: 		if (stato_accensione==1){
	MOVF        main_stato_accensione_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main6
;B.c,89 :: 		Lcd_cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;B.c,90 :: 		Lcd_Out(1,1,"ACCESO");//comunica stato
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr3_B+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr3_B+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;B.c,91 :: 		LATE.RE2=1;   //accendi motore
	BSF         LATE+0, 2 
;B.c,92 :: 		LATA.RA4=1;   //accendi led
	BSF         LATA+0, 4 
;B.c,93 :: 		}
L_main6:
;B.c,94 :: 		}
L_main4:
;B.c,96 :: 		RC0_old=RC0_new; //salvo vecchio valore per vedere se cambia
	MOVF        main_RC0_new_L0+0, 0 
	MOVWF       main_RC0_old_L0+0 
;B.c,99 :: 		if (stato_accensione==1){
	MOVF        main_stato_accensione_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main7
;B.c,101 :: 		RC3_new=PORTC.RC3;
	MOVLW       0
	BTFSC       PORTC+0, 3 
	MOVLW       1
	MOVWF       main_RC3_new_L0+0 
;B.c,102 :: 		RC4_new=PORTC.RC4;
	MOVLW       0
	BTFSC       PORTC+0, 4 
	MOVLW       1
	MOVWF       main_RC4_new_L0+0 
;B.c,104 :: 		if (RC3_new==1 && RC3_new!=RC3_old && velocita_motore<8){ //acccendi motore
	MOVF        main_RC3_new_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main10
	MOVF        main_RC3_new_L0+0, 0 
	XORWF       main_RC3_old_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main10
	MOVLW       8
	SUBWF       main_velocita_motore_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main10
L__main19:
;B.c,105 :: 		velocita_motore+=1;
	INCF        main_velocita_motore_L0+0, 1 
;B.c,106 :: 		vel_change=1;
	MOVLW       1
	MOVWF       main_vel_change_L0+0 
;B.c,107 :: 		LATD=LATD+2^(velocita_motore);
	MOVLW       2
	ADDWF       LATD+0, 0 
	MOVWF       R0 
	MOVF        main_velocita_motore_L0+0, 0 
	XORWF       R0, 0 
	MOVWF       LATD+0 
;B.c,108 :: 		}
L_main10:
;B.c,110 :: 		if (RC4_new==1 && RC4_new!=RC4_old && velocita_motore>0){ //spegni motore
	MOVF        main_RC4_new_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main13
	MOVF        main_RC4_new_L0+0, 0 
	XORWF       main_RC4_old_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main13
	MOVF        main_velocita_motore_L0+0, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_main13
L__main18:
;B.c,111 :: 		velocita_motore-=1;
	DECF        main_velocita_motore_L0+0, 1 
;B.c,112 :: 		vel_change=1;
	MOVLW       1
	MOVWF       main_vel_change_L0+0 
;B.c,113 :: 		LATD=LATD-2^(velocita_motore);
	MOVLW       2
	SUBWF       LATD+0, 0 
	MOVWF       R0 
	MOVF        main_velocita_motore_L0+0, 0 
	XORWF       R0, 0 
	MOVWF       LATD+0 
;B.c,114 :: 		}
L_main13:
;B.c,115 :: 		RC3_old=RC3_new;
	MOVF        main_RC3_new_L0+0, 0 
	MOVWF       main_RC3_old_L0+0 
;B.c,116 :: 		RC4_old=RC4_new;
	MOVF        main_RC4_new_L0+0, 0 
	MOVWF       main_RC4_old_L0+0 
;B.c,118 :: 		IntToStr(velocita_motore,velocita_motore_char);
	MOVF        main_velocita_motore_L0+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVLW       0
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_velocita_motore_char_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_velocita_motore_char_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;B.c,119 :: 		Lcd_Out(2,1,velocita_motore_char);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_velocita_motore_char_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_velocita_motore_char_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;B.c,120 :: 		IntToStr(LATD,velocita_motore_char);
	MOVF        LATD+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVLW       0
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_velocita_motore_char_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_velocita_motore_char_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;B.c,121 :: 		Lcd_Out(2,5,velocita_motore_char);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       5
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_velocita_motore_char_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_velocita_motore_char_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;B.c,123 :: 		if (vel_change==1){
	MOVF        main_vel_change_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main14
;B.c,126 :: 		CCPR5L=PR2*velocita_motore/8;
	MOVF        PR2+0, 0 
	MULWF       main_velocita_motore_L0+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        PRODH+0, 0 
	MOVWF       R1 
	MOVLW       8
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R0, 0 
	MOVWF       CCPR5L+0 
;B.c,127 :: 		vel_change=0;
	CLRF        main_vel_change_L0+0 
;B.c,128 :: 		}
L_main14:
;B.c,133 :: 		}
L_main7:
;B.c,137 :: 		}
	GOTO        L_main0
;B.c,138 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_vu_meter:

;B.c,140 :: 		unsigned short int vu_meter(unsigned short int vel){
;B.c,142 :: 		unsigned short int latd=0;
	CLRF        vu_meter_latd_L0+0 
;B.c,145 :: 		for (i=0;i++;i<vel){
	CLRF        R2 
	CLRF        R3 
L_vu_meter15:
	MOVF        R2, 0 
	MOVWF       R0 
	MOVF        R3, 0 
	MOVWF       R1 
	INFSNZ      R2, 1 
	INCF        R3, 1 
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_vu_meter16
;B.c,146 :: 		latd=latd+2^(i);
	MOVLW       2
	ADDWF       vu_meter_latd_L0+0, 1 
	MOVF        R2, 0 
	XORWF       vu_meter_latd_L0+0, 1 
;B.c,147 :: 		}
	GOTO        L_vu_meter15
L_vu_meter16:
;B.c,148 :: 		return latd;
	MOVF        vu_meter_latd_L0+0, 0 
	MOVWF       R0 
;B.c,149 :: 		}
L_end_vu_meter:
	RETURN      0
; end of _vu_meter
