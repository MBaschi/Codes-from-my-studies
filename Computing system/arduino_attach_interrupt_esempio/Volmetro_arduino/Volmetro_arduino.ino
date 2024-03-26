int Analog_value;
float Volt_value;

void setup() {
   Serial.begin(9600);
   Serial.println("ok");
  
}

void loop() {
  Analog_value=analogRead(A0);
  Volt_value=(Analog_value*5.0)/1024.0;
   Serial.println(Volt_value);
   delay(1000);
}
