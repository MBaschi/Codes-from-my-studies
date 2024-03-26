int dir1PinA = 2;
int dir2PinA = 4;
int speedPinA = 3;
void setup() {
  Serial.begin(9600);
   pinMode(dir1PinA, OUTPUT);
  pinMode(dir2PinA, OUTPUT);
   pinMode(speedPinA, OUTPUT);
  // put your setup code here, to run once:

}

void loop() {

  digitalWrite(dir1PinA, LOW);
  digitalWrite(dir2PinA, HIGH);
 
   int sp;
  for (sp=0;sp<255;sp=sp+10){
   analogWrite(speedPinA, sp);
    Serial.println(sp);
  delay(1000);
  }
  
  // put your main code here, to run repeatedly:

}
