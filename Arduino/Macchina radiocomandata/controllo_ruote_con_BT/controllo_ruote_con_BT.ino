#include <SoftwareSerial.h> //libreria per la gestione delle comunicazioni con dispostitivi esterni
SoftwareSerial SSerial(10,11); //imposta i pin 10 e 11 come pin le comunicazione seriale : al pin 11 TX (trasmettitore) al pin 10 RX (ricevitore)
// ricorda: il pin Tx arduino va collegato al pin Rx del modulo bluetotth, da una parte invio e dall altra ricevo, stessa cosa per l'altrop pin

int dir_1[4]={2,4,6,8}; //{avanti dx, avanti sx, dietro dx,dietro sx}
int dir_2[4]={3,5,7,9};

void setup() {
  int i=0;
  //COMUNICAZIONE SERIALE
  Serial.begin(9600); //imposta la velocità di comunicazione in bit al secondo
  Serial.println("ok"); // verifica che la comunicazione è stata iniziallizata
  SSerial.begin(9600); //iniziializzo la comunicazione BT

  //CONTROLLO RUOTE
      for(i=0;i<4;i++){
       pinMode(dir_1[i], OUTPUT);
       pinMode(dir_2[i], OUTPUT);
       }
     for(i=0;i<4;i++){
       digitalWrite(dir_1[i], LOW);
       digitalWrite(dir_2[i], LOW);
       }
  }
     


void loop() {
 
  if(SSerial.available()){ // sta arrivando un dato
    int i=0;
    int a=SSerial.read();
         Serial.println(a);
  
      if (a==0){ //COMANDO FERMA
          for(i=0;i<4;i++){
             digitalWrite(dir_1[i], LOW);
             digitalWrite(dir_2[i], LOW);
         }
      }

     if (a==1){ //COMANDO AVANTI
          for(i=0;i<4;i++){
             digitalWrite(dir_1[i], HIGH);
             digitalWrite(dir_2[i], LOW);
         }
      }

     if (a==2){ //COMANDO DESTRA
          for(i=1;i<4;i=i+2){ // solo le ruote di sinitra devono andare avanti quindi chiamo solo il secondo e il quarto elemento del arrari (pin ruote di sinitra)
             digitalWrite(dir_1[i], HIGH);
             digitalWrite(dir_2[i], LOW);
         }

         for(i=0;i<4;i=i+2){ // blocco le ruote di destra
             digitalWrite(dir_1[i], LOW);
             digitalWrite(dir_2[i], LOW);
         }
      }
  
     if (a==3){ //COMANDO INDIETRO
          for(i=0;i<4;i++){
             digitalWrite(dir_1[i], LOW);
             digitalWrite(dir_2[i], HIGH);
         }
      }

     if (a==4){ //COMANDO SINISTRA
          for(i=0;i<4;i=i+2){ // opposto di comando destra
             digitalWrite(dir_1[i], HIGH);
             digitalWrite(dir_2[i], LOW);
         }

         for(i=1;i<4;i=i+2){ // blocco le ruote di sisnitra
             digitalWrite(dir_1[i], LOW);
             digitalWrite(dir_2[i], LOW);
         }
      }
  }

  
delay(100);  

}
