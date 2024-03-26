#include "DHT.h"

#define DHTPIN1 3
#define DHTPIN2 4
#define DHTPIN3 5
#define DHTTYPE2 DHT22
#define DHTTYPE DHT11
#define FANPIN 6
#define BUTTONPIN 2
#define LEDPIN 12
DHT dht1(DHTPIN1, DHTTYPE);
DHT dht2(DHTPIN2,DHTTYPE);
DHT dht3(DHTPIN3,DHTTYPE2);
const int potPin = 4;
int finish=0;
int i=0;

volatile int led_state=LOW;

void ChangeDelay(){
     led_state=!led_state;
     digitalWrite(LEDPIN,led_state);
     
  }
void setup() {
  Serial.begin(9600);
  Serial.println("CLEARDATA");
  Serial.println("LABEL,t,RH1,RH3,RH3_,RH3_,F,I");
  
  pinMode(potPin, INPUT);
  pinMode(FANPIN,OUTPUT);
  pinMode(BUTTONPIN,INPUT);
  pinMode(LEDPIN,OUTPUT);
  attachInterrupt(digitalPinToInterrupt(BUTTONPIN),ChangeDelay,CHANGE);
  dht1.begin();
  dht2.begin();
  dht3.begin();
  digitalWrite(LEDPIN,led_state);
  digitalWrite(FANPIN,HIGH);
  
}


void loop() {
i=i+1;
  delay(3000); //3 SECONDI
 
 //temperature and humity of sensor 1 
  float h1 = dht1.readHumidity();
  float h3 = dht3.readHumidity();
  
  float h1_=h1;
  float h3_=h3;
  
  if (i==100){ //100 CICLICLI =5 MINUTI
    digitalWrite(FANPIN,LOW);
    delay(120000); //2 MINUTI 
    h1_ = dht1.readHumidity();
    h3_= dht3.readHumidity();
       if (h1_>h1+3){  // se spegnengo la ventola l'umidità cresce ancora spegnila e riavvia la procedura
          digitalWrite(FANPIN,HIGH);
          i=0;
          }
       else {  //se sale poco può darsi che siano asciutti
          delay(600000); //aspetta 10 minuti 
          h1_ = dht1.readHumidity();
          h3_= dht3.readHumidity();
              if (h1_>h3+15) { // se l'umidita è salita di 15 rispetto al ambiente allora continua 
                digitalWrite(FANPIN,HIGH);
                i=0;
                finish=0;
                }
              else { // se è rimansta sotto allora i vestiti sono asciutti
                digitalWrite(FANPIN,LOW);
                 finish=1;
                 i=0;
               }
       }
   }  
    
    
  
  

 
 Serial.print("DATA,TIME,"); 
  Serial.print(h1); Serial.print(",");Serial.print(",");Serial.print(h3); Serial.print(",");
  Serial.print(h1_); Serial.print(",");Serial.print(",");Serial.print(h3_); Serial.print(",");
  Serial.print(finish);Serial.println(i);
}
