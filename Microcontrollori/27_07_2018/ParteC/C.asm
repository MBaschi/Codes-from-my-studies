
_main:

;C.c,18 :: 		void main() {
;C.c,21 :: 		unsigned short int RA0_NEW=0;
	CLRF        main_RA0_NEW_L0+0 
	CLRF        main_RA0_OLD_L0+0 
	CLRF        main_stato_accensione_L0+0 
	CLRF        main_potenza_motore_L0+0 
	CLRF        main_potenza_motore_anteriore_L0+0 
;C.c,32 :: 		TRISA=0b00000111;
	MOVLW       7
	MOVWF       TRISA+0 
;C.c,33 :: 		ANSELA=0b11111000;
	MOVLW       248
	MOVWF       ANSELA+0 
;C.c,35 :: 		TRISE=0b00000100; //per ora RE2 è un imput perchè devo settare il PWM
	MOVLW       4
	MOVWF       TRISE+0 
;C.c,36 :: 		LATE=0; //tutto spento inizialmente
	CLRF        LATE+0 
;C.c,39 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;C.c,40 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;C.c,41 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;C.c,42 :: 		Lcd_out(1,1,"VEICOLO SPENTO");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_C+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_C+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;C.c,44 :: 		CCPTMRS1.C5TSEL0=0;
	BCF         CCPTMRS1+0, 2 
;C.c,45 :: 		CCPTMRS1.C5TSEL1=1;
	BSF         CCPTMRS1+0, 3 
;C.c,47 :: 		PR6=255;
	MOVLW       255
	MOVWF       PR6+0 
;C.c,49 :: 		CCP5CON.CCP5M3=1;
	BSF         CCP5CON+0, 3 
;C.c,50 :: 		CCP5CON.CCP5M2=1;
	BSF         CCP5CON+0, 2 
;C.c,52 :: 		CCPR5L=0; //inizialmente spento
	CLRF        CCPR5L+0 
;C.c,54 :: 		T6CON.TMR6ON=1;
	BSF         T6CON+0, 2 
;C.c,56 :: 		TRISE.RE2=0;
	BCF         TRISE+0, 2 
;C.c,58 :: 		T0CON=0b11001000;
	MOVLW       200
	MOVWF       T0CON+0 
;C.c,59 :: 		TMR0L=255;//in questo modo abbiamo overflow ogni 256*(4/fosc)*(256-TMROL)*PSA=128*1=128us
	MOVLW       255
	MOVWF       TMR0L+0 
;C.c,61 :: 		INTCON=0b10100000;
	MOVLW       160
	MOVWF       INTCON+0 
;C.c,64 :: 		while(1){
L_main0:
;C.c,67 :: 		RA0_NEW=PORTA.RA0;
	MOVLW       0
	BTFSC       PORTA+0, 0 
	MOVLW       1
	MOVWF       main_RA0_NEW_L0+0 
;C.c,69 :: 		if (RA0_NEW && RA0_NEW!=RA0_OLD){
	MOVF        main_RA0_NEW_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
	MOVF        main_RA0_NEW_L0+0, 0 
	XORWF       main_RA0_OLD_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
L__main23:
;C.c,70 :: 		stato_accensione=!stato_accensione;
	MOVF        main_stato_accensione_L0+0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       main_stato_accensione_L0+0 
;C.c,71 :: 		if (stato_accensione==1){
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main5
;C.c,72 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;C.c,73 :: 		Lcd_out(1,1,"VEICOLO ACCESO");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_C+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_C+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;C.c,74 :: 		LATE.RE0=1;
	BSF         LATE+0, 0 
;C.c,75 :: 		}
	GOTO        L_main6
L_main5:
;C.c,77 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;C.c,78 :: 		Lcd_out(1,1,"VEICOLO SPENTO");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr3_C+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr3_C+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;C.c,79 :: 		LATE.RE0=0;
	BCF         LATE+0, 0 
;C.c,80 :: 		}
L_main6:
;C.c,81 :: 		}
L_main4:
;C.c,82 :: 		RA0_OLD=RA0_NEW;
	MOVF        main_RA0_NEW_L0+0, 0 
	MOVWF       main_RA0_OLD_L0+0 
;C.c,85 :: 		if (stato_accensione==1){
	MOVF        main_stato_accensione_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main7
;C.c,87 :: 		if (PORTA.RA1 && tmr0_overflof>20000){
	BTFSS       PORTA+0, 1 
	GOTO        L_main10
	MOVLW       128
	XORLW       78
	MOVWF       R0 
	MOVLW       128
	XORWF       _tmr0_overflof+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main25
	MOVF        _tmr0_overflof+0, 0 
	SUBLW       32
L__main25:
	BTFSC       STATUS+0, 0 
	GOTO        L_main10
L__main22:
;C.c,88 :: 		potenza_motore+=1;
	INCF        main_potenza_motore_L0+0, 1 
;C.c,89 :: 		tmr0_overflof=0;
	CLRF        _tmr0_overflof+0 
	CLRF        _tmr0_overflof+1 
;C.c,90 :: 		CCPR5L=potenza_motore;
	MOVF        main_potenza_motore_L0+0, 0 
	MOVWF       CCPR5L+0 
;C.c,91 :: 		}
L_main10:
;C.c,92 :: 		if (PORTA.RA2 && tmr0_overflof>20000){
	BTFSS       PORTA+0, 2 
	GOTO        L_main13
	MOVLW       128
	XORLW       78
	MOVWF       R0 
	MOVLW       128
	XORWF       _tmr0_overflof+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main26
	MOVF        _tmr0_overflof+0, 0 
	SUBLW       32
L__main26:
	BTFSC       STATUS+0, 0 
	GOTO        L_main13
L__main21:
;C.c,93 :: 		potenza_motore-=1;
	DECF        main_potenza_motore_L0+0, 1 
;C.c,94 :: 		tmr0_overflof=0;
	CLRF        _tmr0_overflof+0 
	CLRF        _tmr0_overflof+1 
;C.c,95 :: 		CCPR5L=potenza_motore;
	MOVF        main_potenza_motore_L0+0, 0 
	MOVWF       CCPR5L+0 
;C.c,96 :: 		}
L_main13:
;C.c,97 :: 		potenza_motore_percent=potenza_motore*0.39; //0,39=100/256
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
;C.c,99 :: 		IntToStr(potenza_motore_percent,potenza_motore_char);
	MOVF        R0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVLW       0
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_potenza_motore_char_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_potenza_motore_char_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;C.c,100 :: 		Lcd_Out(2,1,"MOTORE:");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr4_C+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr4_C+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;C.c,101 :: 		Lcd_Out(2,5,potenza_motore_char);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       5
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_potenza_motore_char_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_potenza_motore_char_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;C.c,102 :: 		Lcd_Out(2,11,"%");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       11
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr5_C+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr5_C+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;C.c,105 :: 		potenza_motore_anteriore=potenza_motore; //divido per 2 il valore della potenza del motore posteriore shiftando
	MOVF        main_potenza_motore_L0+0, 0 
	MOVWF       main_potenza_motore_anteriore_L0+0 
;C.c,108 :: 		if (clk_pwm < potenza_motore_anteriore){  // fintantò che il clock è andato in overflow meno volte della potenza lascia acceso
	MOVF        main_potenza_motore_L0+0, 0 
	SUBWF       _clk_pwm+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main14
;C.c,109 :: 		LATE.RE1=1;
	BSF         LATE+0, 1 
;C.c,110 :: 		}
L_main14:
;C.c,112 :: 		if(clk_pwm> potenza_motore_anteriore && clk_pwm<256){
	MOVF        _clk_pwm+0, 0 
	SUBWF       main_potenza_motore_anteriore_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main17
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORLW       1
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main27
	MOVLW       0
	SUBWF       _clk_pwm+0, 0 
L__main27:
	BTFSC       STATUS+0, 0 
	GOTO        L_main17
L__main20:
;C.c,113 :: 		LATE.RE1=0;
	BCF         LATE+0, 1 
;C.c,114 :: 		}
	GOTO        L_main18
L_main17:
;C.c,116 :: 		clk_pwm=0;
	CLRF        _clk_pwm+0 
;C.c,117 :: 		}
L_main18:
;C.c,119 :: 		}
L_main7:
;C.c,121 :: 		}
	GOTO        L_main0
;C.c,122 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_interrupt:

;C.c,124 :: 		void interrupt(){
;C.c,125 :: 		if (INTCON.TMR0IF){
	BTFSS       INTCON+0, 2 
	GOTO        L_interrupt19
;C.c,126 :: 		INTCON.TMR0IE=0;
	BCF         INTCON+0, 5 
;C.c,127 :: 		tmr0_overflof+=128; //us
	MOVLW       128
	ADDWF       _tmr0_overflof+0, 1 
	MOVLW       0
	ADDWFC      _tmr0_overflof+1, 1 
;C.c,128 :: 		clk_pwm+=1;
	INCF        _clk_pwm+0, 1 
;C.c,129 :: 		INTCON.TMR0IF=0;
	BCF         INTCON+0, 2 
;C.c,130 :: 		INTCON.TMR0IE=1;
	BSF         INTCON+0, 5 
;C.c,132 :: 		}
L_interrupt19:
;C.c,133 :: 		}
L_end_interrupt:
L__interrupt29:
	RETFIE      1
; end of _interrupt
