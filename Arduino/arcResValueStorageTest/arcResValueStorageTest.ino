/*Used to test how storage of 1000-element array
 * for arc resolution speeds
 */
#include <stdio.h>
#include <math.h>
#include <avr/pgmspace.h>
 
//Initialization
#define ledPin 13
String vals;

const float arcRes[] PROGMEM = {};

float* parseArray(char strInput[]) {
  const char delim[2] = ":";
  char * strtokIn;
  strtokIn = strtok(strInput, delim);
  if (strcmp(strtokIn, "X") == 0) {
    static float valsNew[65];
    valsNew[0] = 1;
    int i = 1;
    while (strtokIn != NULL) {
      strtokIn = strtok(NULL, delim);
      valsNew[i++] = atof(strtokIn);
    }
    return valsNew;
  }
}



void setup() {
  // put your setup code here, to run once:
  pinMode(ledPin, OUTPUT);
  Serial.begin(9600);
  Serial.println("Beginning");

  //for (int i=0; i<=999; i++) {
    Serial.println("entered loop");
    const int arcRes[0] PROGMEM = {random(1200)};
    Serial.println(arcRes[0]);
  //}
  Serial.println("End");
}

void loop() {
  vals = Serial.readString();
  float valsNew;

  if (vals != NULL) {
    char inputArray[vals.length() + 1];
    vals.toCharArray(inputArray, vals.length() + 1);
    float *resSpeeds = parseArray(inputArray);
    for (int i = 0; i <=63 ; i++) {
      Serial.println(*(resSpeeds + (i + 1)), 4);
    }

    /*
      Serial.println(*(forward_coeffs + 1), 4);
      Serial.println(*(forward_coeffs + 2), 4);
      Serial.println(*(forward_coeffs + 3), 4);
      Serial.println(*(forward_coeffs + 4), 4);*/

    //for (int i = 0; i<=3; i++){
    //Serial.println(*(received + (i+1)));
    //}

    /*if (*received == 1) {
      for (int i = 0; i <= 3; i++) {
        digitalWrite(ledPin, HIGH);
        delay(1000);
        digitalWrite(ledPin, LOW);
        delay(1000);
      }
      }*/
  }
}

