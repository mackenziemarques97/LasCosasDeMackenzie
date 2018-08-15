#include <stdio.h>
#include <math.h>

/* Defining Pins */
/*pins for the x-axis stepper motor*/
#define xPulse 8 /*50% duty cycle pulse width modulation*/
#define xDir 9 /*rotation direction*/
/*pins for the y-axis stepper motor*/
#define yPulse 10
#define yDir 11
/*pins for the 4 microswitchces*/
#define xMin 2
#define xMax 3
#define yMin 4
#define yMax 5
/*pins for LED*/
#define RED 48
#define BLUE 49
#define GREEN 50

/* Defining initial variables and arrays */
int direction = 1; /*viewing from behind motor, with shaft facing away, 1 = clockwise, 0 = counterclockwise*/
unsigned long microsteps = 16; /*divides the steps per revolution by this number, corresponds to microstepping settings on stepper driver, 16 corresponds to 3200 pulse/rev*/
unsigned long dimensions[2] = {30000 * microsteps, 30000 * microsteps}; /*preallocating dimensions to previously measured values*/
unsigned long location[2] = {0, 0}; /*presetting location*/
/*arbitrary upper limit for location input, with lower limit of 0*/
int virtDimX = 100; /* max x dimension that can be inputted*/
int virtDimY = 50; /*max y dimension that can be inputted*/

int vel = 60; /*default velocity for calibration and basic movement actions in terms of square pulse width (microseconds)*/
float pi = 3.14159265359; /*numerical value used for pi*/
String val; /*String object to store inputs read from the Serial Connection*/
//int xErr,yErr;


/* parseCommand function: Parses command received from Serial Connection and returns designated inputs */
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
    /*arc:radius:angInit:angFinal:vel:arcRes*/
    static double inputs[6];
    inputs[0] = 4;
    int i = 1;
    while (fstr != NULL) {
      fstr = strtok(NULL, delim);
      inputs[i++] = atof(fstr);
    }
    return inputs;

  } else if (strcmp(fstr, "SpeedModeling") == 0) {
    static double inputs[7];
    inputs[0] = 5;
    int i = 1;
    while (fstr != NULL) {
      fstr = strtok(NULL, delim);
      inputs[i++] = atof(fstr);
    }
    return inputs;

  } else { /*implement in any other case*/
    /* Else return empty array */
    static double j[1];
    j[0] = 10000;
    //Serial.println(j);
    return j;
  }
}


/*arcMove function:
  Inputs: radius = distance from center os monkey's eyes to target
  angInit = starting angle in degrees
  andFinal = final angle in degrees
  velArc = speed of movement
  moves to initial angle, then moves to final angle
  approximates a circle by drawing small lines
*/
void arcMove(float radius, float angInit, float angFinal, int velArc, int arcRes) {
  float angInit_rad = (pi / 180) * (-angInit + 90); /*convert initial angle from degrees to radians*/
  float angInit_res = angInit_rad * arcRes; /*adjust initial angle in radians by input resolution*/
  float angFinal_res = (pi / 180) * (-angFinal + 90) * arcRes; /*convert final angle from degrees to radians then adjust by input resolution*/
  long dispInitx = 0.5 * dimensions[0] + ((float) radius) * cos(angInit_rad) - location[0];
  long dispInity = ((float) radius) * sin(angInit_rad) - location[1];
  line(dispInitx, dispInity, vel); /*move to initial position, x-direction: center + rcos(angInit), y-direction: 0 + rsin(angInit)*/
  for (int i = angInit_res; i <= angFinal_res; i++) { /*move from initial to final angle*/
    int dx = round(-radius / arcRes * sin((float)i / arcRes)); /*change in x-direction, derivative of rcos(theta) adjusted for resolution*/
    int dy = round(radius / arcRes * cos((float)i / arcRes)); /*change in y-direction, derivative of rsin(theta) adjusted for resolution*/
    line(dx, dy, velArc); /*draw small line, which represents part of circle/arc*/
  }
}


/* findDimensions function:
   Moves to xMax from current location then to xMin and counts the number of steps it took
   Does the same in the y-direction
   Returns the number of steps in a 2-element array, x & y dimension
   Ends at (xMin, yMin)
*/
int* findDimensions() {
  recalibrate(xMax); /*move to xMax*/
  int a = recalibrate(xMin); /*a = number of steps necessary to move from xMax to xMin*/
  recalibrate(yMax); /*move to yMax*/
  int b = recalibrate(yMin); /*b = number of steps necessary to move from yMax to yMin*/
  static int i[2] = {a, b}; /*store x & y dimensions in an array in terms of number of steps*/
  return i;
}

/* recalibrate function:
   Moves target to specified edge (xMax, xMin, yMax, yMin)
   Standardizes edge as the point when the microswitch is just released.
   Returns number of steps it took to get there
   0 = pressed, 1 = unpressed for pin reads
*/
unsigned long recalibrate(int pin) { /*input is microswitch pin*/
  delay(1000);
  unsigned long steps = 0;
  /*Specific pin recalibration/movement toward that pin*/
  int val = digitalRead(pin); /*read the pin, 0 = pressed, 1 = unpressed*/
  while (val) {
    if (pin == xMin) { /*if pin is xMin*/
      line(-microsteps * 10, 0, vel); /*move in negative x-direction toward xMin*/
    } else if (pin == xMax) { /*if pin is xMax*/
      line(microsteps * 10, 0, vel); /*move in positive x-direction toward xMax*/
    } else if (pin == yMin) { /*if pin is yMin*/
      line(0, -microsteps * 10, vel); /*move in negative y-direction toward yMin*/
    } else if (pin == yMax) { /*if pin is yMax*/
      line(0, microsteps * 10, vel); /*move in positive y-direction toward yMax*/
    }
    steps += 10; /*add 10 to steps counter*/


    if (steps > (long) dimensions[1] * 1.2) { /*if the number of steps is greater than 120% of the number of steps of the y-dimension*/
      Serial.end(); /*end the serial connection*/
      break; /*break put of the loop*/
    }

    /*Overshoot adjustment: moves back until pin is just released*/
    val = digitalRead(pin);
    if (val == 0) { /*if switch is pressed*/
      while (val == 0) { /*while switch is pressed*/
        if (pin == xMin) {
          line(microsteps, 0, vel); /*if xMin microswitch is pressed (if value read from pin is 0), move forward in x-direction*/
          location[0] = 0; /*update x-coordinate location to 0*/
          delay(200);
        } else if (pin == xMax) {
          line(-microsteps, 0, vel); /*if xMax microswitch is pressed, move back in negative x-direction*/
          location[0] = dimensions[0]; /*update x-coordinate location to max x-dimension*/
          delay(200);
        } else if (pin == yMin) {
          line(0, microsteps, vel); /*if yMin microswitch is pressed, move forward in y-direction*/
          location[1] = 0; /*update y-coordinate location to 0*/
          delay(200);
        } else if (pin == yMax) {
          line(0, -microsteps, vel); /*if yMax microswitch is pressed, move back in negative y-direction*/
          location[1] = dimensions[1]; /*update y-coordinate location to max y-dimension*/
          delay(200);
        }
        val = digitalRead(pin); /*continue reading the state of the pin*/
        steps -= 1; /*remove one step from total step count, correcting for the overshoot*/
      }
      break; /*when val no longer is 0, switch has just been released, break from the loop*/
    }
  }
  return steps; /*returns the number of steps*/
}


/* Implementation of Bresenham's Algorithm for a line
   Input vector (in number of steps) along with pulse width (velocity/speed)
   Proprioceptive location
*/
void line(long x1, long y1, int v) { /*inputs: x-component of vector, y-component of vector, speed/pulse width*/
  location[0] += x1; /*add x1 to current x-coordinate location*/
  location[1] += y1; /*add y1 to current y-coordinate location*/
  long x0 = 0, y0 = 0;
  long dx = abs(x1 - x0), signx = x0 < x1 ? 1 : -1; /*change in x is absolute value of difference between (x1,y1) location and origin*/
  /*if x0 is less than x1, set signx equal to 1; if x0 is not less than x1, set signx equal to -1*/
  /*if x-component of vector (desired x displacement) is positive, signx = 1 (clockwise rotation of motor)*/
  long dy = abs(y1 - y0), signy = y0 < y1 ? 1 : -1; /*same as above, except in terms of y*/
  long err = (dx > dy ? dx : -dy) / 2, e2; /*if dx is greater than dy, set error equal to dx/2; if dx is not greater than dy, set error equal to -dy/2*/
  digitalWrite(xDir, (signx + 1) / 2); /*setup x motor rotation direction, if signx = 1, rotate counterclockwise; if signx = -1, don't move*/
  digitalWrite(yDir, (signy + 1) / 2); /*setup y motor rotation direction*/
  for (;;) { /*infinite loop (;;)*/
    if (x0 == x1 && y0 == y1) break; /*once the desired location is reached, break out of the infinite loop and halt movement*/
    e2 = err; /*to maiantain error at start of loop, since error changes in some cases*/
    if (e2 > -dx) { /*if error is greater than negative dx*/
      err -= dy; /*subtract dy from the error*/
      x0 += signx; /*add signx (1 or -1) to the x-coordinate location*/
      /*HIGH to LOW represents one cycle of square wave, which corresponds to motor rotation*/
      digitalWrite(xPulse, HIGH);
      if (e2 < dy) { /*if error is less than dy*/
        err += dx; /*add dx to error*/
        y0 += signy; /*add signy (1 or -1) to the y-coordinate location*/
        /*motors of both dimensions moving*/
        digitalWrite(yPulse, HIGH);
        delayMicroseconds(v);
        digitalWrite(xPulse, LOW);
        digitalWrite(yPulse, LOW);
        delayMicroseconds(v);
      } else {
        delayMicroseconds(v);
        digitalWrite(xPulse, LOW);
        delayMicroseconds(v);
      }
    } else if (e2 < dy) {
      err += dx;
      y0 += signy;
      /*y-dimension motor movement*/
      digitalWrite(yPulse, HIGH);
      delayMicroseconds(v);
      digitalWrite(yPulse, LOW);
      delayMicroseconds(v);
    } else {
    }
  }
}



/* Main setup function
   Verifies serial connection and traces edges for dimensions
*/
void setup()
{ /*pulse and direction pins for x & y-dimension motors are outputting signal*/
  pinMode(xPulse, OUTPUT);
  pinMode(xDir, OUTPUT);
  pinMode(yPulse, OUTPUT);
  pinMode(yDir, OUTPUT);
  /*microswitch pins are awaiting input signal (pressed or unpressed)*/
  pinMode(xMin, INPUT);
  pinMode(xMax, INPUT);
  pinMode(yMin, INPUT);
  pinMode(yMax, INPUT);
  /*initially set microswitch pins to HIGH (1), indicating unpressed*/
  digitalWrite(xMin, HIGH);
  digitalWrite(xMax, HIGH);
  digitalWrite(yMin, HIGH);
  digitalWrite(yMax, HIGH);
  /*LED pins output*/
  pinMode(RED, OUTPUT);
  pinMode(GREEN, OUTPUT);
  pinMode(BLUE, OUTPUT);
  /*initially, red & blue off, green on*/
  digitalWrite(RED, LOW);
  digitalWrite(BLUE, LOW);
  digitalWrite(GREEN, HIGH);
  digitalWrite(yDir, direction);
  digitalWrite(xDir, direction);
  /*set serial data transmission rate*/
  Serial.begin(9600);

  /* Communicates with Serial connection to verify */
  Serial.println("Type the letter a, then hit enter.");
  char serialInit = 'b';
  while (serialInit != 'a') /*while serialInit does not equal a, which is always since serialInit = b*/
  {
    serialInit = Serial.read(); /*be ready to read incoming serial data*/
  }
  Serial.println("Ready");

  /* Determines dimensions */
  int *i = findDimensions(); /*pointer of the array that contains the x & y-dimensions in terms of steps*/
  /* Scales dimensions to be in terms of microsteps*/
  dimensions[0] = *i * microsteps; //106528; /*x-dimension*/
  dimensions[1] =  *(i + 1) * microsteps; //54624; /*y-dimension*/
  Serial.print("x-dim steps");
  Serial.println(*i);
  Serial.print("y-dim steps");
  Serial.println(*(i + 1));
  digitalWrite(GREEN, LOW); /*turn off green*/
}



/* Main looping function
   Waits for commands from Serial Connection and executes actions
*/
void loop()
{
  Serial.flush();
  long dispx, dispy;
  int xErr, yErr;
  val = Serial.readString(); /*read characters from input into a String object*/

  /* Execute once there is incoming Serial information
     Parse incoming command from Serial connection
  */
  if (val != NULL) { /*if val is not empty*/
    char inputArray[val.length() + 1]; /*create an array the size of val string +1*/
    val.toCharArray(inputArray, val.length() + 1); /*convert val from String object to null terminated character array*/
    double *command = parseCommand(inputArray); /*create pointer variable to parsed commands*/
    switch ((int) *command) { /*switch case based on first command*/
      case 1: // calibrate
        /* Calibrates to xMin and yMin and updates location to (0,0) */
        digitalWrite(GREEN, HIGH);
        xErr = recalibrate(xMin); /*xErr is number of steps from initial x-coordinate location to 0*/
        yErr = recalibrate(yMin); /*yErr is number of steps from initial y-coordinate location to 0*/
        location[0] = 0;
        location[1] = 0;
        Serial.println("Done");
        delay(1000);
        digitalWrite(GREEN, LOW);
        break;
      case 2: // move:x0:y0:hold duration
        /* Simple move to designated location and holds for a certain time
        */
        /*x/y displacement = desired x/y-cooridnate divided by the product of virtual dimension and total x/y-dimension, minus current x/y-coordinate location*/
        dispx = (long) (*(command + 1) / virtDimX * dimensions[0]) - location[0]; /* Converting input virtual dimensions to microsteps*/
        dispy = (long) (*(command + 2) / virtDimY * dimensions[1]) - location[1];
        /*move by designated vector displacement*/
        line(dispx, dispy, vel);
        digitalWrite(BLUE, HIGH);
        Serial.println("Done");
        delay(*(command + 3)); /*delay by the specified hold duration*/
        digitalWrite(BLUE, LOW);
        break;
      case 3: // oscillate:x0:y0:x1:y1:speed:repetitions:resolution
        {
          /* Oscillate
             Moves to first coordinate and oscillates between that and second coordinate
          */
          /*change in x/y, difference between initial x/y and final x/y adjusted for virtual dimension and size of system*/
          long dx = (long) ((*(command + 3) - * (command + 1)) / virtDimX * dimensions[0]); /* Converting input virtual dimensions to microsteps*/
          long dy = (long) ((*(command + 4) - * (command + 2)) / virtDimY * dimensions[1]);
          /*calculating x/y displacement, difference between desired initial x/y and current x/y*/
          dispx = (long) (*(command + 1) / virtDimX * dimensions[0]) - location[0];
          dispy = (long) (*(command + 2) / virtDimY * dimensions[1]) - location[1];
          /*move along calculated displacement vector from current location to desired starting point*/
          line(dispx, dispy, vel);
          digitalWrite(RED, HIGH);
          delay(1000);
          int maxSpeed = *(command + 5); /*max speed implemented is input speed from command*/
          int delta = *(command + 7); /*this does nothing right now...*/
          long store_a = -dx / 2; /*ditto*/
          long store_b = -dy / 2; /*ditto*/
          //int f = 3;
          int minSpeed = 60; /*Minimum speed that target slows down to at edges of movement*/
          int dv = minSpeed - maxSpeed;
          /*vector from initial to final location scaled for...*/
          long dtx = (long) dx / (10 * dv / 2);
          long dty = (long) dy / (10 * dv / 2);

          for (int j = 1; j <= *(command + 6); j++) { /*implemented number of times specified by repetitions input*/
            /* Speeds up in first 10% with intervals of 2 microseconds from min speed to max speed*/
            for (int i = 0; i < (int)dv / 2; i++) {
              int a = minSpeed - i * 2;
              line(dtx, dty, a);
            }

            /* Moves middle 80% at max speed*/
            line((long) dx * 0.8, (long) dy * 0.8, maxSpeed);

            /* Slows down end 10% */
            for (int i = 0; i < (int)dv / 2; i++) {
              int a = maxSpeed + i * 2;
              line(dtx, dty, a);
            }

            /* Speeds up end 10% back */
            for (int i = 0; i < (int)dv / 2; i++) {
              int a = minSpeed - i * 2;
              line(-dtx, -dty, a);
            }

            /* Moves middle 80% back at max speed*/
            line((long) - dx * 0.8, (long) - dy * 0.8, maxSpeed);

            /* Slows down end 10% back*/
            for (int i = 0; i < (int) dv / 2; i++) {
              int a = maxSpeed + i * 2;
              line(-dtx, -dty, a);
            }
          }
          digitalWrite(RED, LOW);
          Serial.println("Done");
          delay(2000);
        }
        break;
      case 4: // arc:radius:angInit:angFinal:velArc:arcRes
        {
          float angInit_rad = (pi / 180) * (-(*(command + 2)) + 90); /*convert initial angle from degrees to radians*/
          float angInit_res = angInit_rad * (*(command + 5)); /*adjust initial angle in radians by input resolution*/
          float angFinal_res = (pi / 180) * (-(*(command + 3)) + 90) * (*(command + 5)); /*convert final angle from degrees to radians then adjust by input resolution*/
          long dispInitx = dimensions[0] * 0.5 + ((float) * (command + 1)) * cos(angInit_rad) - location[0];
          long dispInity = ((float) * (command + 1)) * sin(angInit_rad) - location[1];
          line(dispInitx, dispInity, vel); /*move to initial position, x-direction: center + rcos(angInit), y-direction: 0 + rsin(angInit)*/
          for (int i = angInit_res; i <= angFinal_res; i++) { /*move from initial to final angle*/
            int dx = round(-(*(command + 1)) / (*(command + 5)) * sin((float)i / (*(command + 5)))); /*change in x-direction, derivative of rcos(theta) adjusted for resolution*/
            int dy = round((*(command + 1)) / (*(command + 5)) * cos((float)i / (*(command + 5)))); /*change in y-direction, derivative of rsin(theta) adjusted for resolution*/
            line(dx, dy, *(command + 4)); /*draw small line, which represents part of circle/arc*/
          }
          /*the following code is a temporary addition to test location accuracy*/
          //Serial.print("xloc:");
          //Serial.print(location[0]/16); /*final x-location in steps*/
          //Serial.print("; yloc:");
          //Serial.println(location[1]/16); /*final y-location in steps*/
          //xErr = recalibrate(xMin);
          //yErr = recalibrate(yMin);
          //Serial.print("x steps:");
          //Serial.print(xErr); /*number of steps to return to x=0*/
          //Serial.print("; y steps:");
          //Serial.println(yErr); /*number of steps to return to y=0*/
        }
        break;
      case 5: //SpeedModeling:spdi:spdf:dspd:yi:yf:dy
        {
            /* Speed Trials
               Still needs testing
            */
            int delayi,delayf,ddelay,angleTrials;
            Serial.println(inputArray);
            delayi = (int) * (command + 1);
            delayf = (int) * (command + 2);
            ddelay = (int) * (command + 3);
            angleTrials = (int) * (command + 4);
            long minDim = min((long)(dimensions[0] / microsteps), (long)(dimensions[1] / microsteps));
            int dx = (int) (0.9 * minDim / (angleTrials - 1));
            int maxDistance = dx * (angleTrials - 1);
            //maxDistance = (int) *(command+5);
            //dx = (int) *(command+6);
            Serial.println("Beginning");
            Serial.println(dx);

            /* Number of loops for speed and angles*/
            int delayloops = (int) ((delayf - delayi) / ddelay + 1); /*nothing for now*/

            /* Intialize loop arrays that will be sent over*/
            unsigned long speedRuns[angleTrials];
            int xDistance[angleTrials];
            int yDistance[angleTrials];
            /* Speed Loop */
            int trialNum;
            for (int j = delayi; j <= delayf; j += ddelay) {
              int maxDelay = j;
              /* Distance Loop */
              for (int i = 0; i <= maxDistance; i += dx) {
                recalibrate(xMin);
                recalibrate(yMin);
                delay(1000);
                int x = maxDistance; // Steps
                int y = i;

                /* Calculate how long it takes to move to specified position at specified delayMicroseconds */
                long startTime = millis();
                line((long) x * microsteps, (long) y * microsteps, maxDelay);
                long endTime = millis();
                //int index = (int) (j/2) - 3;
                long timed = endTime - startTime;

                /* Calculating total distance in metric */
                //float distance = sqrt(sq(x) + sq(y))*PI*11.64;
                //float spd = distance/timed;

                /* Saving information in appropriate arrays*/
                speedRuns[trialNum] = timed;
                xDistance[trialNum] = x;
                yDistance[trialNum] = y;
                trialNum++;

                //Serial.println(timed);
                //Serial.println(a);
                delay(2000);
              }

              /*Send x and y distances and time */
              Serial.println("Sending");
              for (int i = 0; i < angleTrials; i++) {
                Serial.println(speedRuns[i]);
                Serial.println(xDistance[i]);
                Serial.println(yDistance[i]);
              }
              trialNum = 0;
            }
            Serial.println("Done");
          }
        break;
    }
  }
}


