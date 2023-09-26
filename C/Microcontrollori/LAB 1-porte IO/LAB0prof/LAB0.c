void main() {
    // voglio scrivere tutto quello che ricevo dalla porta C sulla porta D
// SETTING: spegni il buffer d'uscita di C e accendi quello d'ingressso, per D viceversa 
TRISC = 0xFF; // setto la porta c come input non devo scirver TRISC=1 perchè significa TRISC=0000 0001 che significa solo l'ultima porta è di input
 TRISC = 255; // modo alternativo: traduce 255 decimale in binario che è appunto 111111111

 ANSELC = 0; // setto la porta c come ingresso settanto ANSEL =0

 TRISD = 0; // setto la porta D come output
 ANSELC = 0xFF; // alcune istruzioni potrebbero essere evitate perchè 
  
  while(1)
        LATD = PORTC;
}