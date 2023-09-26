
_main:

;parte1.c,17 :: 		void main() {
;parte1.c,19 :: 		unsigned short int conteggio=0;
	CLRF        main_conteggio_L0+0 
	CLRF        main_RD5X_L0+0 
	CLRF        main_RD6X_L0+0 
	CLRF        main_RD7X_L0+0 
	CLRF        main_RD5_old_L0+0 
	CLRF        main_RD6_old_L0+0 
	CLRF        main_RD7_old_L0+0 
;parte1.c,32 :: 		TRISD.RD5=1; //incremento
	BSF         TRISD+0, 5 
;parte1.c,33 :: 		TRISD.RD6=1; //decremento
	BSF         TRISD+0, 6 
;parte1.c,34 :: 		TRISD.RD7=1; //azzeramento
	BSF         TRISD+0, 7 
;parte1.c,35 :: 		ANSELD=0;
	CLRF        ANSELD+0 
;parte1.c,38 :: 		Lcd_Init(); // inizzializza LCD
	CALL        _Lcd_Init+0, 0
;parte1.c,39 :: 		Lcd_Cmd(_LCD_CLEAR);// metti il cursore in posizione uno
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;parte1.c,40 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);// nacondi il cursore
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;parte1.c,41 :: 		Lcd_Out(1,1,conteggio_char);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_conteggio_char_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_conteggio_char_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;parte1.c,46 :: 		while (1){
L_main0:
;parte1.c,48 :: 		RD5X=PORTD.RD5;
	MOVLW       0
	BTFSC       PORTD+0, 5 
	MOVLW       1
	MOVWF       main_RD5X_L0+0 
;parte1.c,49 :: 		RD6X=PORTD.RD6;
	MOVLW       0
	BTFSC       PORTD+0, 6 
	MOVLW       1
	MOVWF       main_RD6X_L0+0 
;parte1.c,50 :: 		RD7X=PORTD.RD7;
	MOVLW       0
	BTFSC       PORTD+0, 7 
	MOVLW       1
	MOVWF       main_RD7X_L0+0 
;parte1.c,52 :: 		if(RD5X && RD5X!=RD5_old && conteggio<255 ){ // aumenta conteggio, NOTA non ho scritto if(PORTD.RD5 && PORTD.RD5!=RD5_old ) perchè avrei letto la porta 2 volte
	MOVF        main_RD5X_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
	MOVF        main_RD5X_L0+0, 0 
	XORWF       main_RD5_old_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
	MOVLW       255
	SUBWF       main_conteggio_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main4
L__main13:
;parte1.c,53 :: 		conteggio+=1;
	INCF        main_conteggio_L0+0, 1 
;parte1.c,54 :: 		}
L_main4:
;parte1.c,56 :: 		if(RD6X && RD6X!=RD6_old && conteggio>0 ){ // diminuisci conteggio
	MOVF        main_RD6X_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main7
	MOVF        main_RD6X_L0+0, 0 
	XORWF       main_RD6_old_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main7
	MOVF        main_conteggio_L0+0, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_main7
L__main12:
;parte1.c,57 :: 		conteggio-=1;
	DECF        main_conteggio_L0+0, 1 
;parte1.c,58 :: 		}
L_main7:
;parte1.c,60 :: 		if(RD7X && RD7X!=RD7_old ){ // azzera conteggio
	MOVF        main_RD7X_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main10
	MOVF        main_RD7X_L0+0, 0 
	XORWF       main_RD7_old_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main10
L__main11:
;parte1.c,61 :: 		conteggio=0;
	CLRF        main_conteggio_L0+0 
;parte1.c,62 :: 		}
L_main10:
;parte1.c,64 :: 		RD5_old=RD5X;
	MOVF        main_RD5X_L0+0, 0 
	MOVWF       main_RD5_old_L0+0 
;parte1.c,65 :: 		RD6_old=RD6X;
	MOVF        main_RD6X_L0+0, 0 
	MOVWF       main_RD6_old_L0+0 
;parte1.c,66 :: 		RD7_old=RD7X;
	MOVF        main_RD7X_L0+0, 0 
	MOVWF       main_RD7_old_L0+0 
;parte1.c,68 :: 		IntToStr(conteggio,conteggio_char);
	MOVF        main_conteggio_L0+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVLW       0
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_conteggio_char_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_conteggio_char_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;parte1.c,69 :: 		Lcd_Out(1,1,conteggio_char);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_conteggio_char_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_conteggio_char_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;parte1.c,70 :: 		}
	GOTO        L_main0
;parte1.c,71 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
