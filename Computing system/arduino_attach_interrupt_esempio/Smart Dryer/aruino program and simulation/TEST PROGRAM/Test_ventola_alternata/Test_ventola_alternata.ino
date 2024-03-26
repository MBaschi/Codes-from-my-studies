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
int i=0;
int on=100;
volatile int led_state=HIGH;

void ChangeDelay(){
     led_state=!led_state;
     digitalWrite(LEDPIN,led_state);
     Serial.print("BUTTON");
  }
void setup() {
  Serial.begin(9600);
  Serial.println("CLEARDATA");
  Serial.println("LABEL,t,T1,T2,RH1,RH2,on");
  
  pinMode(potPin, INPUT);
  pinMode(FANPIN,OUTPUT);
  pinMode(BUTTONPIN,INPUT);
  pinMode(LEDPIN,OUTPUT);
 
  dht1.begin();
  dht2.begin();
  dht3.begin();
 
  digitalWrite(FANPIN,HIGH);
  
}


void loop() {

  delay(3000);


 //temperature and humity of sensor 1 
  float h1 = dht1.readHumidity();
  float t1 = dht1.readTemperature();

//temperature and humity of sensor 2
  float h2 = dht2.readHumidity();
  float t2 = dht2.readTemperature();

if (i==40){
   digitalWrite(FANPIN,LOW);
   on=0;
}

if (i==61){
   digitalWrite(FANPIN,HIGH);
   on=100;
   i=0;
}


  

  // Check if any reads failed and exit early (to try again).
  if (isnan(h1) || isnan(t1)||isnan(h2) || isnan(t2)) {
    Serial.println(F("Failed to read from DHT sensor!"));
    return;
  }

 
 Serial.print("DATA,TIME,"); 
  Serial.print(t1); Serial.print(",");Serial.print(t2);Serial.print(",");
  Serial.print(h1); Serial.print(",");Serial.print(h2);Serial.print(",");
 Serial.println(on);

i=i+1;
  
  
}
