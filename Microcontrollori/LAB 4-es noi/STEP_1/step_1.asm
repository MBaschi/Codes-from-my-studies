
_main:

;step_1.c,21 :: 		void main() {
;step_1.c,25 :: 		unsigned short int dx=0b00000001; // parte destra del effetto (primi 4 bit)
	MOVLW       1
	MOVWF       main_dx_L0+0 
	MOVLW       128
	MOVWF       main_sx_L0+0 
	CLRF        main_dir_L0+0 
	CLRF        main_D_L0+0 
	MOVLW       244
	MOVWF       main_delay_kitt_L0+0 
	MOVLW       1
	MOVWF       main_delay_kitt_L0+1 
	CLRF        main_cron_val_L0+0 
;step_1.c,34 :: 		TRISD=0;//accendo buffer di output
	CLRF        TRISD+0 
;step_1.c,35 :: 		PORTD=0x00000000; // valore inziale portd :tutto spento
	CLRF        PORTD+0 
;step_1.c,36 :: 		Lcd_Init(); // inizzializza LCD
	CALL        _Lcd_Init+0, 0
;step_1.c,37 :: 		Lcd_Cmd(_LCD_CLEAR);// metti il cursore in posizione uno
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;step_1.c,38 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);// nacondi il cursore
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;step_1.c,41 :: 		T0CON=0b11000111;// timer 0 configuration: (1):enable timer-(1):8bit-(0):selcet internal clock-(0):selcte edge-(0):activate prescalar-(111):prescaler value
	MOVLW       199
	MOVWF       T0CON+0 
;step_1.c,42 :: 		TMR0L=0x3D;
	MOVLW       61
	MOVWF       TMR0L+0 
;step_1.c,43 :: 		INTCON=0b10100000; // interruprt configuration: (1):GIE-(0):disable periphal interupt-(1):TMR0IE(0):INT0IE(0):RBIE-(0):TMR0IF(0):INT0IF(0)
	MOVLW       160
	MOVWF       INTCON+0 
;step_1.c,46 :: 		while (1){
L_main0:
;step_1.c,48 :: 		if(counter_1>delay_kitt) {
	MOVLW       128
	XORWF       main_delay_kitt_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       _counter_1+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main10
	MOVF        _counter_1+0, 0 
	SUBWF       main_delay_kitt_L0+0, 0 
L__main10:
	BTFSC       STATUS+0, 0 
	GOTO        L_main2
;step_1.c,49 :: 		if (dir==0){
	MOVF        main_dir_L0+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main3
;step_1.c,50 :: 		D=D+dx+sx; //PORTD=PORTD+dx+sx;  //cosi non funziona e non capisco perchè
	MOVF        main_dx_L0+0, 0 
	ADDWF       main_D_L0+0, 1 
	MOVF        main_sx_L0+0, 0 
	ADDWF       main_D_L0+0, 1 
;step_1.c,51 :: 		dx<<=1;
	RLCF        main_dx_L0+0, 1 
	BCF         main_dx_L0+0, 0 
;step_1.c,52 :: 		sx>>=1;
	RRCF        main_sx_L0+0, 1 
	BCF         main_sx_L0+0, 7 
;step_1.c,53 :: 		}
	GOTO        L_main4
L_main3:
;step_1.c,55 :: 		dx>>=1;
	MOVF        main_dx_L0+0, 0 
	MOVWF       R2 
	RRCF        R2, 1 
	BCF         R2, 7 
	MOVF        R2, 0 
	MOVWF       main_dx_L0+0 
;step_1.c,56 :: 		sx<<=1;
	MOVF        main_sx_L0+0, 0 
	MOVWF       R0 
	RLCF        R0, 1 
	BCF         R0, 0 
	MOVF        R0, 0 
	MOVWF       main_sx_L0+0 
;step_1.c,57 :: 		D=D-dx-sx;
	MOVF        R2, 0 
	SUBWF       main_D_L0+0, 1 
	MOVF        R0, 0 
	SUBWF       main_D_L0+0, 1 
;step_1.c,58 :: 		}
L_main4:
;step_1.c,60 :: 		if (D==0b11111111){ // siamo al centro e dx=00010000 sx=0000100
	MOVF        main_D_L0+0, 0 
	XORLW       255
	BTFSS       STATUS+0, 2 
	GOTO        L_main5
;step_1.c,61 :: 		dir=1;
	MOVLW       1
	MOVWF       main_dir_L0+0 
;step_1.c,62 :: 		}
L_main5:
;step_1.c,63 :: 		if (D==0b00000000){
	MOVF        main_D_L0+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main6
;step_1.c,64 :: 		dir=0;
	CLRF        main_dir_L0+0 
;step_1.c,65 :: 		}
L_main6:
;step_1.c,66 :: 		PORTD=D;
	MOVF        main_D_L0+0, 0 
	MOVWF       PORTD+0 
;step_1.c,67 :: 		counter_1=0; //riazzera il counter
	CLRF        _counter_1+0 
	CLRF        _counter_1+1 
;step_1.c,68 :: 		}
L_main2:
;step_1.c,70 :: 		if (counter_2>1000){ // counter 2 ha superato un secondo
	MOVLW       128
	XORLW       3
	MOVWF       R0 
	MOVLW       128
	XORWF       _counter_2+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main11
	MOVF        _counter_2+0, 0 
	SUBLW       232
L__main11:
	BTFSC       STATUS+0, 0 
	GOTO        L_main7
;step_1.c,71 :: 		counter_2=0; // riazzero subito counter 2 perhè le istruzioni successive possono causarmi del offset
	CLRF        _counter_2+0 
	CLRF        _counter_2+1 
;step_1.c,72 :: 		cron_val+=1; // non devo preoccuparmi degli overflow di cron_val perchè le specifiche richiedono che arrivi ad un massimo di 255
	INCF        main_cron_val_L0+0, 1 
;step_1.c,73 :: 		IntToStr(cron_val,cron_char); // trasformalo in stringa
	MOVF        main_cron_val_L0+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVLW       0
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_cron_char_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_cron_char_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;step_1.c,74 :: 		Lcd_Out(1,1,cron_char); // stampalo
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_cron_char_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_cron_char_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;step_1.c,76 :: 		}
L_main7:
;step_1.c,78 :: 		}
	GOTO        L_main0
;step_1.c,80 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_interrupt:

;step_1.c,82 :: 		void interrupt(){
;step_1.c,83 :: 		INTCON.GIE=0; // disabilito interrupt
	BCF         INTCON+0, 7 
;step_1.c,84 :: 		if (INTCON.TMR0IF){
	BTFSS       INTCON+0, 2 
	GOTO        L_interrupt8
;step_1.c,85 :: 		INTCON.TMR0IF=0;
	BCF         INTCON+0, 2 
;step_1.c,86 :: 		counter_1+=25;
	MOVLW       25
	ADDWF       _counter_1+0, 1 
	MOVLW       0
	ADDWFC      _counter_1+1, 1 
;step_1.c,87 :: 		counter_2+=25;
	MOVLW       25
	ADDWF       _counter_2+0, 1 
	MOVLW       0
	ADDWFC      _counter_2+1, 1 
;step_1.c,88 :: 		}
L_interrupt8:
;step_1.c,89 :: 		INTCON.GIE=1;
	BSF         INTCON+0, 7 
;step_1.c,90 :: 		}
L_end_interrupt:
L__interrupt13:
	RETFIE      1
; end of _interrupt
