
_main:

;lab3.c,20 :: 		void main() {
;lab3.c,22 :: 		int a = -10000;
	MOVLW       240
	MOVWF       main_a_L0+0 
	MOVLW       216
	MOVWF       main_a_L0+1 
;lab3.c,27 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;lab3.c,28 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;lab3.c,29 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;lab3.c,34 :: 		strcpy(txt,"CiaoCiaoCiaoCiao");
	MOVLW       main_txt_L0+0
	MOVWF       FARG_strcpy_to+0 
	MOVLW       hi_addr(main_txt_L0+0)
	MOVWF       FARG_strcpy_to+1 
	MOVLW       ?lstr1_lab3+0
	MOVWF       FARG_strcpy_from+0 
	MOVLW       hi_addr(?lstr1_lab3+0)
	MOVWF       FARG_strcpy_from+1 
	CALL        _strcpy+0, 0
;lab3.c,35 :: 		Lcd_Out(1,4,txt);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       4
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_txt_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_txt_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;lab3.c,37 :: 		IntToStr(a,numtxt);
	MOVF        main_a_L0+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        main_a_L0+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_numtxt_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_numtxt_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;lab3.c,38 :: 		Lcd_Out(2,5,numtxt);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       5
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_numtxt_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_numtxt_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;lab3.c,39 :: 		Lcd_Out(2,1,"Ris=");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_lab3+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_lab3+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;lab3.c,41 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
