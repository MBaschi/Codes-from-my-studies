#include "DHT.h"

#define SensorI 3 //clothes sensor pin 
#define SensorII 4 // ambient sensor pin

#define DHTTYPE DHT11
DHT dht1(SensorI, DHTTYPE); 
DHT dht2(SensorII,DHTTYPE); 

#define Fan 6 // fan pin
#define Potentiometer A0 // potentiometer pin
#define Finis_led 12 // pin of the finish led
#define Fast_dryng_led 9 // if HIGH fast drying modality is on
#define Normal_regime_led 10 // if HIGH normal regime modality is on
#define Energy_saving_led 11// if HIGH energy saving modality is on

const int potPin = 4;
int finish=0; // if finish=0 the drying is not completed if =1 it's complete
 
void setup() {
  Serial.begin(9600);

  dht1.begin();
  dht2.begin();
  
  pinMode(potPin, INPUT);
  pinMode(Fan,OUTPUT);
  pinMode(Potentiometer,INPUT);
  pinMode(Finis_led,OUTPUT);
  pinMode(Fast_dryng_led,OUTPUT);
  pinMode(Normal_regime_led,OUTPUT);
  pinMode(Energy_saving_led,OUTPUT);


  
  digitalWrite(Fan,HIGH);
  digitalWrite(Finis_led,LOW);
  digitalWrite(Fast_dryng_led,LOW);
  digitalWrite(Normal_regime_led,LOW);
  digitalWrite(Energy_saving_led,LOW);
 
  delay (600000);// 10 min of delay to let the humidity grow abbove 10 of the ambient relati e humidity
}


void loop() {

if (finish==0){
 
  // SET THE MODALITY AND COMMUNICATE TO THE USER
  int pot_value=analogRead(Potentiometer);
  float modality=map(pot_value,0,1024,0,3);
  
    if (modality<=1){  // fast dryng 
      digitalWrite(Fast_dryng_led,HIGH); // comunicate the modality
      digitalWrite(Normal_regime_led,LOW);
      digitalWrite(Energy_saving_led,LOW);

      digitalWrite(Fan,HIGH);
       }
   if (1<modality<=2){  // 5 min on 5 min off 
      digitalWrite(Fast_dryng_led,LOW);
      digitalWrite(Normal_regime_led,HIGH);
      digitalWrite(Energy_saving_led,LOW);
      
      digitalWrite(Fan,HIGH);
      delay(300000);
      digitalWrite(Fan,LOW);
      delay(300000);
      
       }
  if (2<modality<=3){  // 3 min on 9 min off 
      digitalWrite(Fast_dryng_led,LOW);
      digitalWrite(Normal_regime_led,LOW);
      digitalWrite(Energy_saving_led,HIGH);
      
      digitalWrite(Fan,HIGH);
      delay(180000);
      digitalWrite(Fan,LOW);
      delay(540000);
       }
      
  // VERIFY IF DRYNG IS COMPLETE AND COMMUNICATE TO THE USER
  float h1 = dht1.readHumidity(); // humidity of the clothes
  float h2 = dht2.readHumidity(); // humidity of the ambient  
  if (h1<h2+10){
    finish=1; // the dryng is complete
    digitalWrite(Finis_led,HIGH);
    digitalWrite(Fast_dryng_led,LOW);
    digitalWrite(Normal_regime_led,LOW);
    digitalWrite(Energy_saving_led,LOW);
    }

    delay (3000); // to avoid problem in close loop repeating
 }

 delay (3000);
  
}
