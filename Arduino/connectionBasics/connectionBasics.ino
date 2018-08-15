/* The prupose of this script is to investigate the basics
    of serial communication between MATLAB and Arduino.
*/

#include <stdio.h>
#include <math.h>
/*define LED pins*/
#define RED 48
#define BLUE 49
#define GREEN 50

double* parseCommand(char strCommand[]) { /*inputs are null terminated character arrays*/
  const char delim[2] = ":"; /*unchangeable character, 2 element array designating the delimiter as :*/
  char *fstr; /*first string defined as a pointer variable*/
  fstr = strtok(strCommand, delim); /*first call: determines first input of the string*/
  if (strcmp(fstr, "calibrate") == 0) { /*implement if first string is "calibrate"*/
    /* Calibrate
       No numerical inputs
    */
    static double inputs[1]; /*create inputs array with number of elements corresponding to number of inputs*/
    inputs[0] = 1; /*set first element in array to 1, switch case for calibrate*/
    return inputs;

  } else if (strcmp(fstr, "move") == 0) { /*implement if first string is "move"*/
    /* Move to specific coordinate
       Numerical Inputs:
       (x0,y0) - destination coordinates in designated coordinate system
       hold - hold target at (x0,y0) for milliseconds
       move:x0:y0:hold duration
    */
    static double inputs[4];
    inputs[0] = 2; /*set first element in array to 2, switch case for move*/
    int i = 1;
    /*assign numerical inputs to spaces in array*/
    while (fstr != NULL) { /*implement while the first string is not empty*/
      fstr = strtok(NULL, delim); /*split entire string into tokens (individual strings), returns pointer to first token*/
      inputs[i++] = atof(fstr); /*converts string to a double and stores in the designated space in the array*/
    }
    return inputs;

  } else if (strcmp(fstr, "oscillate") == 0) { /*implement if first string is "oscillate"*/
    /* Oscillate between two specific coordinates
        Numerical Inputs:
       (x0,y0) and (x1,y1) - coordinates to move between in designated coordinate system
       Speed - delayMicroseconds between pulses
       Repetitions - Number of times to oscillate
       Resolution - Resolution of pathway stepsize
       oscillate:x0:y0:x1:y1:speed:repetitions:resolution
    */
    static double inputs[8];
    inputs[0] = 3; /*set first element in array to 3, switch case for oscillate*/
    int i = 1;
    /*assign numerical inputs to spaces in array*/
    while (fstr != NULL) {
      fstr = strtok(NULL, delim);
      inputs[i++] = atof(fstr);
    }
    return inputs;

  } else if (strcmp(fstr, "arc") == 0) {
    /* Move in an arc
      Numerical inputs:
      radius - measured in steps, somewhat arbitrary at the moment
      angInit - arc starts at this angle
      angFinal - arc ends at this angle
      Delay - delay in microseconds for each line movement
      arcRes - number of arc divisions
      arc:radius:angInit:angFinal:Delay:arcRes
    */
    static double inputs[6];
    inputs[0] = 4;
    int i = 1;
    while (fstr != NULL) {
      fstr = strtok(NULL, delim);
      inputs[i++] = atof(fstr);
    }
    return inputs;

  } else if (strcmp(fstr, "SpeedModeling") == 0) {
    /*switch case
       SpeedModeling:delayi:delayf:ddelay:angleTrials
    */
    static double inputs[7];
    inputs[0] = 5;
    int i = 1;
    while (fstr != NULL) {
      fstr = strtok(NULL, delim);
      inputs[i++] = atof(fstr);
    }
    return inputs;

  } else { /*implement in any other case*/
    static double j[1];
    j[0] = 10000;
    return j;
  }
}

double* parseIncoming(char strInput[]) {
  const char delim[2] = ":";
  char *strtokIn;
  strtokIn = strtok(strInput, delim);
  if (strcmp(strtokIn, "integer") == 0) {
    static double inputNum[2];
    inputNum[0] = 1;
    int i = 1;
    while (strtokIn != NULL) {
      strtokIn = strtok(NULL, delim);
      inputNum[i++] = atof(strtokIn);
    }
    return inputNum;
  } else if (strcmp(strtokIn, "array1") == 0) {
    static double inputNum[5];
    inputNum[0] = 2;
    int i = 1;
    while (strtokIn != NULL) {
      strtokIn = strtok(NULL, delim);
      inputNum[i++] = atof(strtokIn);
    }
    return inputNum;
  }
    else if (strcmp(strtokIn, "array2") == 0){
      static double inputNum[5];
      inputNum[0] = 3;
      int i = 1;
      while(strtokIn != NULL) {
        strtokIn =strtok(NULL, delim);
        inputNum[i++] = atof(strtokIn);
      }
    }
    return inputNum;
  }*/


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
  double inputNum;
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
    //double *five = parseIncoming(incomingC);
    /*float *array1 = parseIncoming(incomingC);
    float *array2 = parseIncoming(incomingC);*/
    //if (*five == 1) {
      /*Serial.println(*(five + 1));
      for (int i = 0; i <= 2; i++) {
        pinMode(GREEN, HIGH);
        delay(500);
        pinMode(GREEN, LOW);
        delay(500);
      }
    }*/
    /*if (*array1 == 2) {
      Serial.println(*(array1 + 1));
      for (int i = 0; i <= 2; i++) {
        pinMode(BLUE, HIGH);
        delay(500);
        pinMode(BLUE, LOW);
        delay(500);
      }
    }*/
  }
}
