// KITT 2.0 variable delay
// LCD SETTING
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

//VARIABILI GLOBALI
int counter_1=0; // contatore per accensione led che aumenta ad ogni interrupt, quando supera il valore fissato dalla variabile delay_kitt passo allo stadio successivo e lo riazzero
int counter_2=0; // contatore per cronometro

void main() {
  // per realizzare l'effetto kitt: sovrappongo un effetto kitt che va da sinstra a destre con uno che va da destra a sinistra
  
  //VARIABILI
   unsigned short int dx=0b00000001; // parte destra del effetto (primi 4 bit)
   unsigned short int sx=0b10000000; // parte sinistra del effetto (ultimi 4 bit)
   unsigned short int dir=0; // direzione, quando siamo a metà cambia
 
   int delay_kitt=500; // quanto tempo passa tra un passaggio di stato e l'altro in ms
   int delay_kitt_max=1500;
   int delay_kitt_min=100;
   unsigned short int cron_val=0; //valore cronometro
   char cron_char[7];
   unsigned short int cron_condition=0;// se è uguale a zero il cronoemtro è fermo se è uguale a 1 allora il conometro va
   
   
    unsigned short int A[4]={0};     //valore porta in cui salvo valori porta A
    unsigned short int A_old[4]={0}; //valore porta in cui salvo vecchi valori porta A
    

 // PORTE SETTING
  TRISD=0;//accendo buffer di output
  TRISA=0b00011111;// 
  ANSELA=0b11100000;// accendo buffer d'ingresso per porte 0 1 2 3 4 
  LATD=0x00000000; // valore inziale portd :tutto spento
  
  Lcd_Init(); // inizzializza LCD
  Lcd_Cmd(_LCD_CLEAR);// metti il cursore in posizione uno
  Lcd_Cmd(_LCD_CURSOR_OFF);// nacondi il cursore
  Lcd_Out(1,1,"0");
 //INTERRUPT SETTING
  T0CON=0b11000111;// timer 0 configuration: (1):enable timer-(1):8bit-(0):selcet internal clock-(0):selcte edge-(0):activate prescalar-(111):prescaler value
  TMR0L=0x3D;
  INTCON=0b10100000; // interruprt configuration: (1):GIE-(0):disable periphal interupt-(1):TMR0IE(0):INT0IE(0):RBIE-(0):TMR0IF(0):INT0IF(0)

// PROGRAMMA
  while (1){
     //KITT
     if(counter_1>delay_kitt) {
        if (dir==0){ 
           LATD=LATD+dx+sx; //PORTD=PORTD+dx+sx;  //cosi non funziona e non capisco perchè
            dx<<=1;
            sx>>=1;
           } 
        else {
            dx>>=1;
            sx<<=1;
            LATD=LATD-dx-sx;
           }
         
        if (LATD==0b11111111){ // siamo al centro e dx=00010000 sx=0000100 
            dir=1;
          }
       if (LATD==0b00000000){ 
            dir=0;
          }
        
      counter_1=0; //riazzera il counter 
    }
    //CRONOMETRO
    if (counter_2>1000 && cron_condition==1 ){ // counter 2 ha superato un secondo e il cronometro è accesso
        counter_2=0; // riazzero subito counter 2 perhè le istruzioni successive possono causarmi del offset
       cron_val+=1; // non devo preoccuparmi degli overflow di cron_val perchè le specifiche richiedono che arrivi ad un massimo di 255
       IntToStr(cron_val,cron_char); // trasformalo in stringa
       Lcd_Out(1,1,cron_char); // stampalo
       
    }
  //POLLING PORTA
       A[0]=PORTA.RA0;
       A[1]=PORTA.RA1;
       A[2]=PORTA.RA2;
       A[3]=PORTA.RA3;
       A[4]=PORTA.RA4;
    
       if (A[0]&& A_old[0]!=A[0]){ // se premo RA0 fai partire il cronometro
         cron_condition=1;
         }
       if (A[1]&& A_old[1]!=A[1]){ // se premo RA1 stoppa il cronometro
         cron_condition=0;
         }   
       if (A[2]&& A_old[2]!=A[2]){ // se premo RA2 resetta il cronometro
          cron_val=0;
          Lcd_Out(1,1,"0"); // mostrta che l'hai riazzerato
         }
       if (A[3] && A_old[3]!=A[3] && delay_kitt<delay_kitt_max){ // se premo RA3 aumenta il kitt delay
          delay_kitt+=50;
         }
       if (A[4] &&  A_old[4]!=A[4] && delay_kitt>delay_kitt_min){ // se premo RA4 diminuisci il kitt delay
          delay_kitt-=50;
         }
         A_old[0]=A[0];
         A_old[1]=A[1];
         A_old[2]=A[2];
         A_old[3]=A[3];
         A_old[4]=A[4];
    
   } 

  }
  
void interrupt(){
    INTCON.GIE=0; // disabilito interrupt
    if (INTCON.TMR0IF){
        INTCON.TMR0IF=0;
            counter_1+=25;
            counter_2+=25;
    }
    INTCON.GIE=1;
}