volatile int stato=HIGH;
void cambia(){
  stato=!stato;
  Serial.print("BUTTON");
}
void setup() {
 pinMode(12,OUTPUT);
attachInterrupt(digitalPinToInterrupt(3),cambia, FALLING); %per forza pin 3 o 2
}

void loop() {
 digitalWrite(12,stato);

}
