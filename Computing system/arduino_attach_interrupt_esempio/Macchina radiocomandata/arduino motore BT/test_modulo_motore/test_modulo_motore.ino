// Motore 1
int dir1PinA = 2;
int dir2PinA = 3;
int speedPinA = 7; // Deve essere un pino PWM per essere 
                   //in grado di controllare la velocità del motore

// Motore 2
int dir1PinB = 4;
int dir2PinB = 5;
int speedPinB = 8; // Deve essere un pino PWM per essere in grado
                    // di controllare la velocità del motore

void setup() {  // Installazione eseguita una volta al ripristino
  // initialize serial communication @ 9600 baud:
  Serial.begin(9600);

  //Definisce il pins del L298N Dual H-Bridge Motor Controller

  pinMode(dir1PinA, OUTPUT);
  pinMode(dir2PinA, OUTPUT);
  pinMode(speedPinA, OUTPUT);
  pinMode(dir1PinB, OUTPUT);
  pinMode(dir2PinB, OUTPUT);
  pinMode(speedPinB, OUTPUT);
  pinMode(A0, INPUT);
  pinMode(A1, INPUT);
  pinMode(A3, INPUT);
  pinMode(A4, INPUT);

  Serial.println("Test modulo L298");
  Serial.println("1 - Motore 1 Avanti");
  Serial.println("2 - Motore 1 STOP");
  Serial.println("3 - Motore 1 Indietro");
  Serial.println("4 - Motore 2 Avanti");
  Serial.println("5 - Motore 2 STOP");
  Serial.println("6 - Motore 2 Indietro");
  Serial.println("   ");

    digitalWrite(dir1PinA,LOW);
    digitalWrite(dir2PinA, LOW);
    digitalWrite(dir1PinB, LOW);
    digitalWrite(dir2PinB, LOW);
}

void loop() {
delay(3000);
 //Serial.print("out1-2:"); Serial.print(digitalRead(A1));Serial.println(digitalRead(A2));
  //Serial.print("out3-4:");Serial.print(digitalRead(A3));   Serial.println(digitalRead(A4));
  if (Serial.available() > 0) {
    int inByte = Serial.read();
    //int speed; // Local variable
    int sp = 200;
        
    switch (inByte) {
       
      //______________Motore 1______________
       
      case '1': // Motor 1 Avanti
        analogWrite(speedPinA, sp);//Imposta la velocità via PWM
        digitalWrite(dir1PinA, LOW);
        digitalWrite(dir2PinA, HIGH);
       
        Serial.println("Motore 1 Avanti"); // Scrive sul monitor seriale
        Serial.println("   "); // Crea una linea bianca sul monitor seriale
        break;

      case '2': // Motor 1 Fermo
        analogWrite(speedPinA, 0);
        digitalWrite(dir1PinA, LOW);
        digitalWrite(dir2PinA, LOW);
        
        Serial.println("Motore 1 Fermo");
        Serial.println("   ");
        break;

      case '3': // Motor 1 Indietro
        analogWrite(speedPinA, sp);
        digitalWrite(dir1PinA, HIGH);
        digitalWrite(dir2PinA, LOW);
        Serial.println("Motore 1 Indietro");
        Serial.println("   ");
        break;

      //______________Motore 2______________

      case '4': // Motore 2 Avanti
        analogWrite(speedPinB, sp);
        digitalWrite(dir1PinB, LOW);
        digitalWrite(dir2PinB, HIGH);
        Serial.println("Motore 2 Avanti");
        Serial.println("   ");
        break;

      case '5': // Motore 1 FERMO
        analogWrite(speedPinB, 0);
        digitalWrite(dir1PinB, LOW);
        digitalWrite(dir2PinB, LOW);
        Serial.println("Motore 2 Fermo");
        Serial.println("   ");
        break;

      case '6': // Motore 2 Indietro
        analogWrite(speedPinB, sp);
        digitalWrite(dir1PinB, HIGH);
        digitalWrite(dir2PinB, LOW);
        Serial.println("Motore 2 Indietro");
        Serial.println("   ");
        break;

    }
  }
}
