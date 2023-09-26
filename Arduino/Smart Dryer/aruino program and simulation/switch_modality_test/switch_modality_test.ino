
#define Potentiometer A0 // potentiometer pin

#define Fast_dryng_led 10 // if HIGH fast drying modality is on
#define Normal_regime_led 11 // if HIGH normal regime modality is on
#define Energy_saving_led 12// if HIGH energy saving modality is on


void setup() {
  Serial.begin(9600);
  pinMode(Potentiometer,INPUT);
  pinMode(Fast_dryng_led,OUTPUT);
  pinMode(Normal_regime_led,OUTPUT);
  pinMode(Energy_saving_led,OUTPUT);




  digitalWrite(Fast_dryng_led,LOW);
  digitalWrite(Normal_regime_led,LOW);
  digitalWrite(Energy_saving_led,LOW);
  

}

void loop() {
 int pot_value=analogRead(Potentiometer);
  float modality=map(pot_value,0,1024,1,4);
   Serial.println(modality);
    Serial.println(pot_value);
    if (modality==1){  // fast dryng 
      digitalWrite(Fast_dryng_led,HIGH); // comunicate the modality
      digitalWrite(Normal_regime_led,LOW);
      digitalWrite(Energy_saving_led,LOW);
       }
   if (modality==2){  // 5 min on 5 min off 
      digitalWrite(Fast_dryng_led,LOW);
      digitalWrite(Normal_regime_led,HIGH);
      digitalWrite(Energy_saving_led,LOW);    
      
       }
  if (modality==3){  // 3 min on 9 min off 
      digitalWrite(Fast_dryng_led,LOW);
      digitalWrite(Normal_regime_led,LOW);
      digitalWrite(Energy_saving_led,HIGH);
      
       }
 delay(300);
}
