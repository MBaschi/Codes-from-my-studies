
_main:

;B.c,17 :: 		void main() {
;B.c,20 :: 		unsigned short int RA0_NEW=0;
	CLRF        main_RA0_NEW_L0+0 
	CLRF        main_RA0_OLD_L0+0 
	CLRF        main_stato_accensione_L0+0 
	CLRF        main_potenza_motore_L0+0 
;B.c,29 :: 		TRISA=0b00000111;
	MOVLW       7
	MOVWF       TRISA+0 
;B.c,30 :: 		ANSELA=0b11111000;
	MOVLW       248
	MOVWF       ANSELA+0 
;B.c,32 :: 		TRISE=0b00000100; //per ora RE2 è un imput perchè devo settare il PWM
	MOVLW       4
	MOVWF       TRISE+0 
;B.c,33 :: 		LATE=0; //tutto spento inizialmente
	CLRF        LATE+0 
;B.c,36 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;B.c,37 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;B.c,38 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;B.c,39 :: 		Lcd_out(1,1,"VEICOLO SPENTO");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_B+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_B+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;B.c,41 :: 		CCPTMRS1.C5TSEL0=0;
	BCF         CCPTMRS1+0, 2 
;B.c,42 :: 		CCPTMRS1.C5TSEL1=1;
	BSF         CCPTMRS1+0, 3 
;B.c,44 :: 		PR6=255;
	MOVLW       255
	MOVWF       PR6+0 
;B.c,46 :: 		CCP5CON.CCP5M3=1;
	BSF         CCP5CON+0, 3 
;B.c,47 :: 		CCP5CON.CCP5M2=1;
	BSF         CCP5CON+0, 2 
;B.c,49 :: 		CCPR5L=0; //inizialmente spento
	CLRF        CCPR5L+0 
;B.c,51 :: 		T6CON.TMR6ON=1;
	BSF         T6CON+0, 2 
;B.c,53 :: 		TRISE.RE2=0;
	BCF         TRISE+0, 2 
;B.c,55 :: 		T0CON=0b11001000;
	MOVLW       200
	MOVWF       T0CON+0 
;B.c,56 :: 		TMR0L=100;//in questo modo abbiamo overflow ogni 256*(4/fosc)*(256-TMROL)*PSA=128*126=19968us =20 ms
	MOVLW       100
	MOVWF       TMR0L+0 
;B.c,58 :: 		INTCON=0b10100000;
	MOVLW       160
	MOVWF       INTCON+0 
;B.c,61 :: 		while(1){
L_main0:
;B.c,64 :: 		RA0_NEW=PORTA.RA0;
	MOVLW       0
	BTFSC       PORTA+0, 0 
	MOVLW       1
	MOVWF       main_RA0_NEW_L0+0 
;B.c,66 :: 		if (RA0_NEW && RA0_NEW!=RA0_OLD){
	MOVF        main_RA0_NEW_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
	MOVF        main_RA0_NEW_L0+0, 0 
	XORWF       main_RA0_OLD_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
L__main17:
;B.c,67 :: 		stato_accensione=!stato_accensione;
	MOVF        main_stato_accensione_L0+0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       main_stato_accensione_L0+0 
;B.c,68 :: 		if (stato_accensione==1){
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main5
;B.c,69 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;B.c,70 :: 		Lcd_out(1,1,"VEICOLO ACCESO");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_B+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_B+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;B.c,71 :: 		LATE.RE0=1;
	BSF         LATE+0, 0 
;B.c,72 :: 		}
	GOTO        L_main6
L_main5:
;B.c,74 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;B.c,75 :: 		Lcd_out(1,1,"VEICOLO SPENTO");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr3_B+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr3_B+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;B.c,76 :: 		LATE.RE0=0;
	BCF         LATE+0, 0 
;B.c,77 :: 		}
L_main6:
;B.c,78 :: 		}
L_main4:
;B.c,79 :: 		RA0_OLD=RA0_NEW;
	MOVF        main_RA0_NEW_L0+0, 0 
	MOVWF       main_RA0_OLD_L0+0 
;B.c,82 :: 		if (stato_accensione==1){
	MOVF        main_stato_accensione_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main7
;B.c,84 :: 		if (PORTA.RA1 && tmr0_overflof==1){
	BTFSS       PORTA+0, 1 
	GOTO        L_main10
	MOVF        _tmr0_overflof+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main10
L__main16:
;B.c,85 :: 		potenza_motore+=1;
	INCF        main_potenza_motore_L0+0, 1 
;B.c,86 :: 		tmr0_overflof=0;
	CLRF        _tmr0_overflof+0 
;B.c,87 :: 		CCPR5L=potenza_motore;
	MOVF        main_potenza_motore_L0+0, 0 
	MOVWF       CCPR5L+0 
;B.c,88 :: 		}
L_main10:
;B.c,89 :: 		if (PORTA.RA2 && tmr0_overflof==1){
	BTFSS       PORTA+0, 2 
	GOTO        L_main13
	MOVF        _tmr0_overflof+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main13
L__main15:
;B.c,90 :: 		potenza_motore-=1;
	DECF        main_potenza_motore_L0+0, 1 
;B.c,91 :: 		tmr0_overflof=0;
	CLRF        _tmr0_overflof+0 
;B.c,92 :: 		CCPR5L=potenza_motore;
	MOVF        main_potenza_motore_L0+0, 0 
	MOVWF       CCPR5L+0 
;B.c,93 :: 		}
L_main13:
;B.c,94 :: 		potenza_motore_percent=potenza_motore*0.39; //0,39=100/256
	MOVF        main_potenza_motore_L0+0, 0 
	MOVWF       R0 
	CALL        _byte2double+0, 0
	MOVLW       20
	MOVWF       R4 
	MOVLW       174
	MOVWF       R5 
	MOVLW       71
	MOVWF       R6 
	MOVLW       125
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	CALL        _double2byte+0, 0
;B.c,96 :: 		IntToStr(potenza_motore_percent,potenza_motore_char);
	MOVF        R0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVLW       0
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_potenza_motore_char_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_potenza_motore_char_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;B.c,97 :: 		Lcd_Out(2,1,"MOTORE:");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr4_B+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr4_B+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;B.c,98 :: 		Lcd_Out(2,5,potenza_motore_char);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       5
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_potenza_motore_char_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_potenza_motore_char_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;B.c,99 :: 		Lcd_Out(2,11,"%");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       11
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr5_B+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr5_B+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;B.c,100 :: 		}
L_main7:
;B.c,102 :: 		}
	GOTO        L_main0
;B.c,103 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_interrupt:

;B.c,105 :: 		void interrupt(){
;B.c,106 :: 		if (INTCON.TMR0IF){
	BTFSS       INTCON+0, 2 
	GOTO        L_interrupt14
;B.c,107 :: 		INTCON.TMR0IE=0;
	BCF         INTCON+0, 5 
;B.c,108 :: 		tmr0_overflof=1;
	MOVLW       1
	MOVWF       _tmr0_overflof+0 
;B.c,109 :: 		INTCON.TMR0IF=0;
	BCF         INTCON+0, 2 
;B.c,110 :: 		INTCON.TMR0IE=1;
	BSF         INTCON+0, 5 
;B.c,111 :: 		}
L_interrupt14:
;B.c,112 :: 		}
L_end_interrupt:
L__interrupt20:
	RETFIE      1
; end of _interrupt
