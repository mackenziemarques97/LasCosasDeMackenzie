
#include <stdio.h>
#include <math.h>
/*define LED pins*/
#define RED 48
#define BLUE 49
#define GREEN 50

void setup() {
  /*LED pins set as outputs
       at setup, RED on, BLUE & GREEN off
  */
  pinMode(RED, OUTPUT);
  pinMode(BLUE, OUTPUT);
  pinMode(GREEN, OUTPUT);
  pinMode(RED, HIGH);
  pinMode(BLUE, LOW);
  pinMode(GREEN, LOW);
  /*set data rate in bits per second (baud) for serial data transmission
     9600 baud
  */
  Serial.begin(9600);
  /*confirm serial connection
  */
  Serial.println("A");
  char SerialInit = 'B';
  while (SerialInit != 'A')
  {
    SerialInit = Serial.read();
  }
  /*turn off RED
  */
  pinMode(RED, LOW);
  delay(1000);
}

void loop() {
  String incoming = Serial.readString();
  if (incoming != NULL) {
    char incomingChar[incoming.length() + 1];
    incoming.toCharArray(incomingChar, incoming.length() + 1);
    Serial.println(incoming);
  }
  delay(2000);
  Serial.println("Done");
}
