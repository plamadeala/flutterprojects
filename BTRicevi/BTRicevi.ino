/* Riceve messaggi che vengono inviati via Bluetooth HC-05 da una app. 
*/

#include <SoftwareSerial.h>

const int RXPin = 2;  // da collegare su TX di HC05
const int TXPin = 3;  // da collegare su RX di HC05
const int ritardo = 10;

//creo una nuova porta seriale via software
SoftwareSerial myBT = SoftwareSerial(RXPin, TXPin);
  
char msgChar;
  
void setup()
{
  pinMode(RXPin, INPUT);
  pinMode(TXPin, OUTPUT);
    
  myBT.begin(9600);

  Serial.begin(9600); 
}

void loop() 
{
  while(myBT.available()){
    msgChar = char(myBT.read());
    Serial.print(msgChar);
  }
  delay(ritardo); //delay                
}
