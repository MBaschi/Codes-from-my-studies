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
   
    int a = 10; // varibaile numerica
    char numtxt[7]; // variabile char da 7 caratteri

    char txt[17]; // variabile char da 17 caratteri

    Lcd_Init(); // inizzializza LCD
    Lcd_Cmd(_LCD_CLEAR);// metti il cursore in posizione uno
    Lcd_Cmd(_LCD_CURSOR_OFF);// nacondi il cursore
    
    strcpy(txt,"Ciao"); // per le variabili string non posso fare txt="ciao" ma devo usare la funzione string copy
    Lcd_Out(1,4,txt); //alla riga 1 della colonna 4 stampa txt

    IntToStr(a,numtxt); // se devo stampare un numero lo devo convertire in una stringa con questa funzione
    strcat(txt,numtxt); //attacca numtxt a txt e lo salva in txt
    // Se provo a scrivere su una parte di LCD in cui ho già scritto qualcosa il vecchio testo viene sovrascritto
    // se scrivo in due sezioni diverse invece la vecchia stringa non viene cancellata
    //ES 1:
    Lcd_Out(1,1,"ciao"); 
    Lcd_Out(1,8,"ciao");  // RISULTATO : "ciao   ciao"
    // ES 2:
    Lcd_Out(1,1,"ciao"); 
    Lcd_Cmd(_LCD_CLEAR);
    Lcd_Out(1,8,"ciao");  // RISULTATO : "       ciao"
}