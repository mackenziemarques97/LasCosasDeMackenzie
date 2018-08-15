/* The prupose of this script is to investigate the basics
    of serial communication between MATLAB and Arduino.
*/

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
  /*read characters from serial into a string*/
  String incoming = Serial.readString();
  /*if five is not empty
     blink GREEN 5 times
     then turn off
  */
  if (incoming != NULL) {
    /*send five to MATLAB and print in command window
    */
    char incomingC[incoming.length() + 1];
    incoming.toCharArray(incomingC, incoming.length() + 1);
    Serial.println(incomingC);
    for (int i = 0; i <= 2; i++) {
      pinMode(GREEN, HIGH);
      delay(500);
      pinMode(GREEN, LOW);
      delay(500);
    }
  }
}
