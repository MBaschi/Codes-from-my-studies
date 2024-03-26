
_main:

;step_3.c,22 :: 		void main() {
;step_3.c,26 :: 		unsigned short int dx=0b00000001; // parte destra del effetto (primi 4 bit)
	MOVLW       1
	MOVWF       main_dx_L0+0 
	MOVLW       128
	MOVWF       main_sx_L0+0 
	CLRF        main_dir_L0+0 
	MOVLW       244
	MOVWF       main_delay_kitt_L0+0 
	MOVLW       1
	MOVWF       main_delay_kitt_L0+1 
	MOVLW       220
	MOVWF       main_delay_kitt_max_L0+0 
	MOVLW       5
	MOVWF       main_delay_kitt_max_L0+1 
	MOVLW       100
	MOVWF       main_delay_kitt_min_L0+0 
	MOVLW       0
	MOVWF       main_delay_kitt_min_L0+1 
	CLRF        main_cron_val_L0+0 
	CLRF        main_cron_condition_L0+0 
	CLRF        main_A_L0+0 
	CLRF        main_A_L0+1 
	CLRF        main_A_L0+2 
	CLRF        main_A_L0+3 
	CLRF        main_A_old_L0+0 
	CLRF        main_A_old_L0+1 
	CLRF        main_A_old_L0+2 
	CLRF        main_A_old_L0+3 
	CLRF        main_C_L0+0 
	CLRF        main_C_old_L0+0 
;step_3.c,45 :: 		TRISD=0;//accendo buffer di output
	CLRF        TRISD+0 
;step_3.c,46 :: 		LATD=0x00000000; // valore inziale portd :tutto spento
	CLRF        LATD+0 
;step_3.c,48 :: 		TRISA=0b00011111;//
	MOVLW       31
	MOVWF       TRISA+0 
;step_3.c,49 :: 		ANSELA=0b11100000;// accendo buffer d'ingresso per porte 0 1 2 3 4
	MOVLW       224
	MOVWF       ANSELA+0 
;step_3.c,51 :: 		TRISC=0b00011111;//
	MOVLW       31
	MOVWF       TRISC+0 
;step_3.c,52 :: 		ANSELC=0b11111110;// accendo buffer d'ingresso per porte 0 1 2 3 4
	MOVLW       254
	MOVWF       ANSELC+0 
;step_3.c,55 :: 		Lcd_Init(); // inizzializza LCD
	CALL        _Lcd_Init+0, 0
;step_3.c,56 :: 		Lcd_Cmd(_LCD_CLEAR);// metti il cursore in posizione uno
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;step_3.c,57 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);// nacondi il cursore
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;step_3.c,58 :: 		Lcd_Out(1,1,"0");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_step_3+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_step_3+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;step_3.c,60 :: 		T0CON=0b11000111;// timer 0 configuration: (1):enable timer-(1):8bit-(0):selcet internal clock-(0):selcte edge-(0):activate prescalar-(111):prescaler value
	MOVLW       199
	MOVWF       T0CON+0 
;step_3.c,61 :: 		TMR0L=0x3D;
	MOVLW       61
	MOVWF       TMR0L+0 
;step_3.c,62 :: 		INTCON=0b10100000; // interruprt configuration: (1):GIE-(0):disable periphal interupt-(1):TMR0IE(0):INT0IE(0):RBIE-(0):TMR0IF(0):INT0IF(0)
	MOVLW       160
	MOVWF       INTCON+0 
;step_3.c,65 :: 		while (1){
L_main0:
;step_3.c,67 :: 		if(counter_1>delay_kitt) {
	MOVLW       128
	XORWF       main_delay_kitt_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       _counter_1+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main37
	MOVF        _counter_1+0, 0 
	SUBWF       main_delay_kitt_L0+0, 0 
L__main37:
	BTFSC       STATUS+0, 0 
	GOTO        L_main2
;step_3.c,68 :: 		if (dir==0){
	MOVF        main_dir_L0+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main3
;step_3.c,69 :: 		LATD=LATD+dx+sx; //PORTD=PORTD+dx+sx;  //cosi non funziona e non capisco perchè
	MOVF        main_dx_L0+0, 0 
	ADDWF       LATD+0, 0 
	MOVWF       R0 
	MOVF        main_sx_L0+0, 0 
	ADDWF       R0, 0 
	MOVWF       LATD+0 
;step_3.c,70 :: 		dx<<=1;
	RLCF        main_dx_L0+0, 1 
	BCF         main_dx_L0+0, 0 
;step_3.c,71 :: 		sx>>=1;
	RRCF        main_sx_L0+0, 1 
	BCF         main_sx_L0+0, 7 
;step_3.c,72 :: 		}
	GOTO        L_main4
L_main3:
;step_3.c,74 :: 		dx>>=1;
	MOVF        main_dx_L0+0, 0 
	MOVWF       R2 
	RRCF        R2, 1 
	BCF         R2, 7 
	MOVF        R2, 0 
	MOVWF       main_dx_L0+0 
;step_3.c,75 :: 		sx<<=1;
	MOVF        main_sx_L0+0, 0 
	MOVWF       R1 
	RLCF        R1, 1 
	BCF         R1, 0 
	MOVF        R1, 0 
	MOVWF       main_sx_L0+0 
;step_3.c,76 :: 		LATD=LATD-dx-sx;
	MOVF        R2, 0 
	SUBWF       LATD+0, 0 
	MOVWF       R0 
	MOVF        R1, 0 
	SUBWF       R0, 0 
	MOVWF       LATD+0 
;step_3.c,77 :: 		}
L_main4:
;step_3.c,79 :: 		if (LATD==0b11111111){ // siamo al centro e dx=00010000 sx=0000100
	MOVF        LATD+0, 0 
	XORLW       255
	BTFSS       STATUS+0, 2 
	GOTO        L_main5
;step_3.c,80 :: 		dir=1;
	MOVLW       1
	MOVWF       main_dir_L0+0 
;step_3.c,81 :: 		}
L_main5:
;step_3.c,82 :: 		if (LATD==0b00000000){
	MOVF        LATD+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main6
;step_3.c,83 :: 		dir=0;
	CLRF        main_dir_L0+0 
;step_3.c,84 :: 		}
L_main6:
;step_3.c,86 :: 		counter_1=0; //riazzera il counter
	CLRF        _counter_1+0 
	CLRF        _counter_1+1 
;step_3.c,87 :: 		}
L_main2:
;step_3.c,89 :: 		if (counter_2>1000 && cron_condition==1 ){ // counter 2 ha superato un secondo e il cronometro è accesso
	MOVLW       128
	XORLW       3
	MOVWF       R0 
	MOVLW       128
	XORWF       _counter_2+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main38
	MOVF        _counter_2+0, 0 
	SUBLW       232
L__main38:
	BTFSC       STATUS+0, 0 
	GOTO        L_main9
	MOVF        main_cron_condition_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main9
L__main35:
;step_3.c,90 :: 		counter_2=0; // riazzero subito counter 2 perhè le istruzioni successive possono causarmi del offset
	CLRF        _counter_2+0 
	CLRF        _counter_2+1 
;step_3.c,91 :: 		cron_val+=1; // non devo preoccuparmi degli overflow di cron_val perchè le specifiche richiedono che arrivi ad un massimo di 255
	INCF        main_cron_val_L0+0, 1 
;step_3.c,93 :: 		}
L_main9:
;step_3.c,95 :: 		A[0]=PORTA.RA0;
	MOVLW       0
	BTFSC       PORTA+0, 0 
	MOVLW       1
	MOVWF       main_A_L0+0 
;step_3.c,96 :: 		A[1]=PORTA.RA1;
	MOVLW       0
	BTFSC       PORTA+0, 1 
	MOVLW       1
	MOVWF       main_A_L0+1 
;step_3.c,97 :: 		A[2]=PORTA.RA2;
	MOVLW       0
	BTFSC       PORTA+0, 2 
	MOVLW       1
	MOVWF       main_A_L0+2 
;step_3.c,98 :: 		A[3]=PORTA.RA3;
	MOVLW       0
	BTFSC       PORTA+0, 3 
	MOVLW       1
	MOVWF       main_A_L0+3 
;step_3.c,99 :: 		A[4]=PORTA.RA4;
	MOVLW       0
	BTFSC       PORTA+0, 4 
	MOVLW       1
	MOVWF       main_A_L0+4 
;step_3.c,101 :: 		if (A[0]&& A_old[0]!=A[0]){ // se premo RA0 fai partire il cronometro
	MOVF        main_A_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main12
	MOVF        main_A_old_L0+0, 0 
	XORWF       main_A_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main12
L__main34:
;step_3.c,102 :: 		cron_condition=1;
	MOVLW       1
	MOVWF       main_cron_condition_L0+0 
;step_3.c,103 :: 		}
L_main12:
;step_3.c,104 :: 		if (A[1]&& A_old[1]!=A[1]){ // se premo RA1 stoppa il cronometro
	MOVF        main_A_L0+1, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main15
	MOVF        main_A_old_L0+1, 0 
	XORWF       main_A_L0+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main15
L__main33:
;step_3.c,105 :: 		cron_condition=0;
	CLRF        main_cron_condition_L0+0 
;step_3.c,106 :: 		}
L_main15:
;step_3.c,107 :: 		if (A[2]&& A_old[2]!=A[2]){ // se premo RA2 resetta il cronometro
	MOVF        main_A_L0+2, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main18
	MOVF        main_A_old_L0+2, 0 
	XORWF       main_A_L0+2, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main18
L__main32:
;step_3.c,108 :: 		cron_val=0;
	CLRF        main_cron_val_L0+0 
;step_3.c,109 :: 		Lcd_Out(1,1,"0"); // mostrta che l'hai riazzerato
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_step_3+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_step_3+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;step_3.c,110 :: 		}
L_main18:
;step_3.c,111 :: 		if (A[3] && A_old[3]!=A[3] && delay_kitt<delay_kitt_max){ // se premo RA3 aumenta il kitt delay
	MOVF        main_A_L0+3, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main21
	MOVF        main_A_old_L0+3, 0 
	XORWF       main_A_L0+3, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main21
	MOVLW       128
	XORWF       main_delay_kitt_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       main_delay_kitt_max_L0+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main39
	MOVF        main_delay_kitt_max_L0+0, 0 
	SUBWF       main_delay_kitt_L0+0, 0 
L__main39:
	BTFSC       STATUS+0, 0 
	GOTO        L_main21
L__main31:
;step_3.c,112 :: 		delay_kitt+=50;
	MOVLW       50
	ADDWF       main_delay_kitt_L0+0, 1 
	MOVLW       0
	ADDWFC      main_delay_kitt_L0+1, 1 
;step_3.c,113 :: 		}
L_main21:
;step_3.c,114 :: 		if (A[4] &&  A_old[4]!=A[4] && delay_kitt>delay_kitt_min){ // se premo RA4 diminuisci il kitt delay
	MOVF        main_A_L0+4, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main24
	MOVF        main_A_old_L0+4, 0 
	XORWF       main_A_L0+4, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main24
	MOVLW       128
	XORWF       main_delay_kitt_min_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       main_delay_kitt_L0+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main40
	MOVF        main_delay_kitt_L0+0, 0 
	SUBWF       main_delay_kitt_min_L0+0, 0 
L__main40:
	BTFSC       STATUS+0, 0 
	GOTO        L_main24
L__main30:
;step_3.c,115 :: 		delay_kitt-=50;
	MOVLW       50
	SUBWF       main_delay_kitt_L0+0, 1 
	MOVLW       0
	SUBWFB      main_delay_kitt_L0+1, 1 
;step_3.c,116 :: 		}
L_main24:
;step_3.c,117 :: 		A_old[0]=A[0];
	MOVF        main_A_L0+0, 0 
	MOVWF       main_A_old_L0+0 
;step_3.c,118 :: 		A_old[1]=A[1];
	MOVF        main_A_L0+1, 0 
	MOVWF       main_A_old_L0+1 
;step_3.c,119 :: 		A_old[2]=A[2];
	MOVF        main_A_L0+2, 0 
	MOVWF       main_A_old_L0+2 
;step_3.c,120 :: 		A_old[3]=A[3];
	MOVF        main_A_L0+3, 0 
	MOVWF       main_A_old_L0+3 
;step_3.c,121 :: 		A_old[4]=A[4];
	MOVF        main_A_L0+4, 0 
	MOVWF       main_A_old_L0+4 
;step_3.c,123 :: 		C=PORTC.RC0;
	MOVLW       0
	BTFSC       PORTC+0, 0 
	MOVLW       1
	MOVWF       main_C_L0+0 
;step_3.c,124 :: 		if (C && C_old!=C){ // se premo RC0 aggiorna il display
	MOVF        main_C_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main27
	MOVF        main_C_old_L0+0, 0 
	XORWF       main_C_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main27
L__main29:
;step_3.c,125 :: 		IntToStr(cron_val,cron_char);
	MOVF        main_cron_val_L0+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVLW       0
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_cron_char_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_cron_char_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;step_3.c,126 :: 		Lcd_Out(1,1,cron_char);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_cron_char_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_cron_char_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;step_3.c,127 :: 		}
L_main27:
;step_3.c,128 :: 		}
	GOTO        L_main0
;step_3.c,130 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_interrupt:

;step_3.c,132 :: 		void interrupt(){
;step_3.c,133 :: 		INTCON.GIE=0; // disabilito interrupt
	BCF         INTCON+0, 7 
;step_3.c,134 :: 		if (INTCON.TMR0IF){
	BTFSS       INTCON+0, 2 
	GOTO        L_interrupt28
;step_3.c,135 :: 		INTCON.TMR0IF=0;
	BCF         INTCON+0, 2 
;step_3.c,136 :: 		counter_1+=25;
	MOVLW       25
	ADDWF       _counter_1+0, 1 
	MOVLW       0
	ADDWFC      _counter_1+1, 1 
;step_3.c,137 :: 		counter_2+=25;
	MOVLW       25
	ADDWF       _counter_2+0, 1 
	MOVLW       0
	ADDWFC      _counter_2+1, 1 
;step_3.c,138 :: 		}
L_interrupt28:
;step_3.c,139 :: 		INTCON.GIE=1;
	BSF         INTCON+0, 7 
;step_3.c,140 :: 		}
L_end_interrupt:
L__interrupt42:
	RETFIE      1
; end of _interrupt
