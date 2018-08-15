String coeffsString; /*String object to store inputs read from the Serial Connection*/
float forward_coeffs[16];
float reverse_coeffs[16];

void loadInfo() {
  Serial.println("ReadyToReceiveCoeffs"); /*signal MATLAB to begin send coeffs*/
  while (1) { /*loop through infinitely*/
    //Serial.println("ReadyToReceiveCoeffs"); /*signal MATLAB to begin send coeffs*/
    coeffsString = Serial.readString();/*read characters from serial connection into String object*/
    float coeffsArray;
    /*this section of code is nearly identical to part of parseCommand function above*/
    if (coeffsString != NULL) {
      char inputArray[coeffsString.length() + 1];
      coeffsString.toCharArray(inputArray, coeffsString.length() + 1);
      float *coeffs = parseCoeffs(inputArray);
      //Serial.println("CoeffsReceived");
      //      delay(2000);
      //      for (int i=0; i<(*(coeffs + 1)); i++){
      //        Serial.println(*(coeffs + (i+2)), 4);
      //      }

      if (*coeffs == 2) {/*if the reverse_coeffs has been received from MATLAB*/
        Serial.println("CoeffsReceived");
        break; /*break from the while loop*/
      }

    }
  }
}


/*parseCoeffs function
   parses coefficients sent through serial connection and returns coefficients array
   method nearly identical to that used in parseCommand function
*/
float* parseCoeffs(char strInput[]) {
  const char delim[2] = ":";
  char * strtokIn;
  strtokIn = strtok(strInput, delim);
  if (strcmp(strtokIn, "forward_coeffs") == 0) {
    static float coeffsArray[18]; /*preallocate space for designating forward or reverse coeffs and number of coefficients total*/
    coeffsArray[0] = 1; /*corresponds to forward_coeffs*/
    coeffsArray[1] = 16; /*16 coefficients in forward_coeffs*/
    int i = 2;
    while (strtokIn != NULL) {
      strtokIn = strtok(NULL, delim);
      coeffsArray[i++] = atof(strtokIn);
    }
    for (i = 0; i < 16; i++) {
      forward_coeffs[i] = coeffsArray[i + 2];
    }
    return coeffsArray;
  } else if (strcmp(strtokIn, "reverse_coeffs") == 0) {
    static float coeffsArray[18];
    coeffsArray[0] = 2; /*corresponds to reverse_coeffs*/
    coeffsArray[1] = 16; /*16 coefficients in reverse_coeffs*/
    int i = 2;
    while (strtokIn != NULL) {
      strtokIn = strtok(NULL, delim);
      coeffsArray[i++] = atof(strtokIn);
    }
    for (i = 0; i < 16; i++) {
      reverse_coeffs[i] = coeffsArray[i + 2];
    }
    return coeffsArray;
  }
}
void setup() {
Serial.begin(9600);

/*Communicates with Serial port to verify connection*/
Serial.println("Type the letter a, then hit enter.");
char serialInit = 'b';
while (serialInit != 'a')
{
  serialInit = Serial.read();
}
loadInfo();
Serial.println("Ready");
}

void loop() {
  // put your main code here, to run repeatedly:

}
