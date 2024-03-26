#include <SoftwareSerial.h> //libreria per la gestione delle comunicazioni con dispostitivi esterni
SoftwareSerial SSerial(10,11); //imposta i pin 10 e 11 come pin le comunicazione seriale : al pin 11 TX (trasmettitore) al pin 10 RX (ricevitore)
// ricorda: il pin Tx arduino va collegato al pin Rx del modulo bluetotth, da una parte invio e dall altra ricevo, stessa cosa per l'altrop pin


int dir1PinA = 2;
int dir2PinA = 3;

// avanti SX
int dir1PinB = 4;
int dir2PinB = 5;

int speedPinA= 6;
int speedPinB = 7;

/*// avanti DX
int A_DX_1 = 2;
int A_DX_2 = 3;

// avanti SX
int A_SX_1 = 4;
int A_SX_1 = 5;

// avanti DX
int D_DX_1 = 6;
int A_DX_2 = 7;

// avanti SX
int A_SX_1 = 8;
int A_SX_1 = 9;*/

void setup() {
  //COMUNICAZIONE SERIALE
  Serial.begin(9600); //imposta la velocità di comunicazione in bit al secondo
  Serial.println("ok"); // verifica che la comunicazione è stata iniziallizata
  SSerial.begin(9600); //iniziializzo la comunicazione BT

  //CONTROLLO RUOTE
  pinMode(dir1PinA, OUTPUT);
  pinMode(dir2PinA, OUTPUT);
  pinMode(speedPinA, OUTPUT);
  pinMode(dir1PinB, OUTPUT);
  pinMode(dir2PinB, OUTPUT);
  pinMode(speedPinB, OUTPUT);

         analogWrite(speedPinA, 0);
         digitalWrite(dir1PinA, LOW);
         digitalWrite(dir2PinA,LOW);

          analogWrite(speedPinB, 0);
          digitalWrite(dir1PinB, LOW);
         digitalWrite(dir2PinB, LOW);
 delay(1000);

}

void loop() {
 
  if(SSerial.available()){ // sta arrivando un dato
    int a=SSerial.read();
         Serial.println(a);
  
    
      if (a=0){ //COMANDO FERMA
    
         digitalWrite(dir1PinA, LOW);
         digitalWrite(dir2PinA, HIGH);
        
          digitalWrite(dir1PinB, LOW);
          digitalWrite(dir2PinB, HIGH);
        }
   
  }
  
  

}
