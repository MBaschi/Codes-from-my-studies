int ledPin = 10;
int interruptPin = 2;
volatile int state = LOW;

void setup() {
  Serial.begin(9600);
   Serial.print("0");
  pinMode(ledPin, OUTPUT);
  pinMode(interruptPin, INPUT);
  attachInterrupt(digitalPinToInterrupt(interruptPin), blink, CHANGE);
}

void loop() {
  int t;
  t=digitalRead(interruptPin); 
  Serial.print(t);
  digitalWrite(ledPin, state);
}

void blink() {
  Serial.print("1");
  state = !state;
}
