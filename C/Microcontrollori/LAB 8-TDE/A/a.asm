
_main:

;a.c,17 :: 		void main() {
;a.c,19 :: 		unsigned short int conteggio=0;
	CLRF        main_conteggio_L0+0 
	CLRF        main_RD5_L0+0 
	CLRF        main_RD6_L0+0 
	CLRF        main_RD7_L0+0 
	CLRF        main_RD5_old_L0+0 
	CLRF        main_RD6_old_L0+0 
	CLRF        main_RD7_old_L0+0 
;a.c,32 :: 		TRISD.RB5=1; //incremento
	BSF         TRISD+0, 5 
;a.c,33 :: 		TRISD.RB6=1; //decremento
	BSF         TRISD+0, 6 
;a.c,34 :: 		TRISD.RB7=1; //azzeramento
	BSF         TRISD+0, 7 
;a.c,36 :: 		TRISC=0;
	CLRF        TRISC+0 
;a.c,38 :: 		Lcd_Init(); // inizzializza LCD
	CALL        _Lcd_Init+0, 0
;a.c,39 :: 		Lcd_Cmd(_LCD_CLEAR);// metti il cursore in posizione uno
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;a.c,40 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);// nacondi il cursore
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;a.c,41 :: 		Lcd_Out(1,1,conteggio_char);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_conteggio_char_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_conteggio_char_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;a.c,46 :: 		while (1){
L_main0:
;a.c,48 :: 		RD5=PORTD.RB5;
	MOVLW       0
	BTFSC       PORTD+0, 5 
	MOVLW       1
	MOVWF       main_RD5_L0+0 
;a.c,49 :: 		RD6=PORTD.RB6;
	MOVLW       0
	BTFSC       PORTD+0, 6 
	MOVLW       1
	MOVWF       main_RD6_L0+0 
;a.c,50 :: 		RD7=PORTD.RB7;
	MOVLW       0
	BTFSC       PORTD+0, 7 
	MOVLW       1
	MOVWF       main_RD7_L0+0 
;a.c,52 :: 		LATC.RB5=PORTD.RB5;
	BTFSC       PORTD+0, 5 
	GOTO        L__main15
	BCF         LATC+0, 5 
	GOTO        L__main16
L__main15:
	BSF         LATC+0, 5 
L__main16:
;a.c,53 :: 		LATC.RB6=PORTD.RB7;
	BTFSC       PORTD+0, 7 
	GOTO        L__main17
	BCF         LATC+0, 6 
	GOTO        L__main18
L__main17:
	BSF         LATC+0, 6 
L__main18:
;a.c,54 :: 		LATC.RB7=PORTD.RB6;
	BTFSC       PORTD+0, 6 
	GOTO        L__main19
	BCF         LATC+0, 7 
	GOTO        L__main20
L__main19:
	BSF         LATC+0, 7 
L__main20:
;a.c,56 :: 		if(RD5 && RD5!=RD5_old && conteggio<255 ){ // aumenta conteggio, NOTA non ho scritto if(PORTD.RD5 && PORTD.RD5!=RD5_old ) perchè avrei letto la porta 2 volte
	MOVF        main_RD5_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
	MOVF        main_RD5_L0+0, 0 
	XORWF       main_RD5_old_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
	MOVLW       255
	SUBWF       main_conteggio_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main4
L__main13:
;a.c,57 :: 		conteggio+=1;
	INCF        main_conteggio_L0+0, 1 
;a.c,58 :: 		}
L_main4:
;a.c,60 :: 		if(RD6 && RD6!=RD6_old && conteggio>0 ){ // diminuisci conteggio
	MOVF        main_RD6_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main7
	MOVF        main_RD6_L0+0, 0 
	XORWF       main_RD6_old_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main7
	MOVF        main_conteggio_L0+0, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_main7
L__main12:
;a.c,61 :: 		conteggio-=1;
	DECF        main_conteggio_L0+0, 1 
;a.c,62 :: 		}
L_main7:
;a.c,64 :: 		if(RD7 && RD7!=RD7_old ){ // azzera conteggio
	MOVF        main_RD7_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main10
	MOVF        main_RD7_L0+0, 0 
	XORWF       main_RD7_old_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main10
L__main11:
;a.c,65 :: 		conteggio=0;
	CLRF        main_conteggio_L0+0 
;a.c,66 :: 		}
L_main10:
;a.c,68 :: 		RD5_old=RD5;
	MOVF        main_RD5_L0+0, 0 
	MOVWF       main_RD5_old_L0+0 
;a.c,69 :: 		RD6_old=RD6;
	MOVF        main_RD6_L0+0, 0 
	MOVWF       main_RD6_old_L0+0 
;a.c,70 :: 		RD7_old=RD7;
	MOVF        main_RD7_L0+0, 0 
	MOVWF       main_RD7_old_L0+0 
;a.c,72 :: 		IntToStr(conteggio,conteggio_char);
	MOVF        main_conteggio_L0+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVLW       0
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_conteggio_char_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_conteggio_char_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;a.c,73 :: 		Lcd_Out(1,1,conteggio_char);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_conteggio_char_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_conteggio_char_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;a.c,74 :: 		}
	GOTO        L_main0
;a.c,75 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
