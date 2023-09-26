#define FANPIN 6

volatile int stato=HIGH;
void cambia(){
  stato=!stato;
 
}
void setup() {
  pinMode(12,OUTPUT);
  pinMode(FANPIN,OUTPUT);
  attachInterrupt(digitalPinToInterrupt(2),cambia, CHANGE); 
  Serial.begin(9600);
 
  

}

void loop() {
  digitalWrite(FANPIN,stato);
  digitalWrite(12,stato);
   Serial.println(stato);
}
