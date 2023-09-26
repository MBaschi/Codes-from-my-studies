//programma per accendere e spegnere un controllato dal telefono

#include <SoftwareSerial.h> //libreria per la gestione delle comunicazioni con dispostitivi esterni
SoftwareSerial SSerial(10,11); //imposta i pin 7 e 8 come pin le comunicazione seriale : al pin 8 TX (trasmettitore) al pin 7 RX (ricevitore)
// ricorda: il pin Tx arduino va collegato al pin Rx del modulo bluetotth, da una parte invio e dall altra ricevo, stessa cosa per l'altrop pin
void setup() {
  Serial.begin(9600); //imposta la velocità di comunicazione in bit al secondo
  Serial.println("ok"); // verifica che la comunicazione è stata iniziallizata
  SSerial.begin(9600); //iniziializzo le variabili di comunicazioni

 pinMode(13,OUTPUT); //iniziallizzo il pin 13 (quello a cui è colegato il led) come output
 digitalWrite(13,HIGH);
 delay(1000);
 digitalWrite(13,LOW);
}

String str=""; // stringa vuota

void loop() {
  if(SSerial.available()){ //restituisce i byte disponibili per la lettura. quindi se non gli dico niente la funzione mi restituisce 0 e non entro nel if 
    char ch=SSerial.read();//salva la variabile che ti arriva come carattere
    Serial.println(ch); //per il debug printa l'input
    if((ch=='\n'|| (ch=='\r'))){    //se come input non ricevo nulla
      cmd(str); //funzione comand scritta dopo
      str="";// riazzera str
    }else {
      str+=ch; //accoda al carattere str l'input ricevuto
        }
  }
}

void cmd(String str){
  char c=str.charAt(0); //c è il primo carattere di str
  if (c=='a'){ // accende il led
    Serial.println("ON"); //mi fa vedere che accende il led
    digitalWrite(13,HIGH); // accende il led
  }
  else if (c=='s'){ // spegne il led
    Serial.println("OFF"); //mi fa vedere che spegne il led
    digitalWrite(13,LOW); // spegneil led
  }
}
