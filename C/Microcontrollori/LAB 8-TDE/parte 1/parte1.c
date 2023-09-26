// Lcd module connections
sbit LCD_RS at LATB4_bit;
sbit LCD_EN at LATB5_bit;
sbit LCD_D4 at LATB0_bit;
sbit LCD_D5 at LATB1_bit;
sbit LCD_D6 at LATB2_bit;
sbit LCD_D7 at LATB3_bit;

sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB0_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D7_Direction at TRISB3_bit;
// End Lcd module connections

void main() {
// VARIABILI
 unsigned short int conteggio=0;
 
 unsigned short int RD5X=0;
 unsigned short int RD6X=0;
 unsigned short int RD7X=0;

 unsigned short int RD5_old=0;
 unsigned short int RD6_old=0;
 unsigned short int RD7_old=0;

 char conteggio_char [7];
//INIZZIALIZZAZIONE 
  //PORTE
  TRISD.RD5=1; //incremento
  TRISD.RD6=1; //decremento
  TRISD.RD7=1; //azzeramento
  ANSELD=0;

  //LCD
  Lcd_Init(); // inizzializza LCD
  Lcd_Cmd(_LCD_CLEAR);// metti il cursore in posizione uno
  Lcd_Cmd(_LCD_CURSOR_OFF);// nacondi il cursore
  Lcd_Out(1,1,conteggio_char);
  

//PROGRAMMA
  
  while (1){
    //POLLING PORT D
     RD5X=PORTD.RD5;
     RD6X=PORTD.RD6;
     RD7X=PORTD.RD7;

     if(RD5X && RD5X!=RD5_old && conteggio<255 ){ // aumenta conteggio, NOTA non ho scritto if(PORTD.RD5 && PORTD.RD5!=RD5_old ) perchè avrei letto la porta 2 volte
       conteggio+=1;
     }
     
     if(RD6X && RD6X!=RD6_old && conteggio>0 ){ // diminuisci conteggio
       conteggio-=1;
     }

     if(RD7X && RD7X!=RD7_old ){ // azzera conteggio
       conteggio=0;
     }
    
     RD5_old=RD5X;
     RD6_old=RD6X;
     RD7_old=RD7X;
    //STAMPA
    IntToStr(conteggio,conteggio_char);
    Lcd_Out(1,1,conteggio_char);
  }
}