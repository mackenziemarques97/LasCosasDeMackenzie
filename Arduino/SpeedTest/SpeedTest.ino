#include <stdio.h>
#define xPulse 8
#define xDir 9

#define yPulse 10
#define yDir 11

#define xMin 2
#define xMax 3
#define yMin 4
#define yMax 5

int direction = 1;
unsigned long microsteps = 16;
int b[2];
int bstore[2];
/*Default values for small prototype rig*/
unsigned long dimensions[2]={30000*microsteps,30000*microsteps};
unsigned long location[2]={0,0};
int virtDimX = 100;
intvirtDimY = 50;
int vel = 150;
String val;

/* Moves to xMax then xMin and counts the number of steps it took.
 * Does the same in the y-direction
 * Returns the number of steps
 * Ends at (xMin, yMin)
 */
int* findDimensions() {
  recalibrate(xMax);
  int a = recalibrate(xMin);
  recalibrate(yMax);
  int b = recalibrate(yMin);
  static int i[2] = {a,b};
  return i;
}

/* Moves target to specified edge (xMax, xMin, yMax, yMin)
 * Standardizes edge as the point when the microswitch is just released.
 * Returns number of steps it took to get there
 */
unsigned long recalibrate(int pin) {
  delay(1000);
  unsigned long steps = 0;
  int val = digitalRead(pin);
  while(val) {
    if(pin==xMin) {
      line(-microsteps*5,0,vel);
    } else if(pin==xMax) {
      line(microsteps*5,0,vel);
    } else if(pin==yMin) {
      line(0,-microsteps*5,vel);
    } else if(pin==yMax){
      line(0,microsteps*5,vel);
    }
    steps+=10;
    //if(steps>2500) {
    //  Serial.end();
    //  break;
    //}
    
    val = digitalRead(pin);
    if(val==0) {
      while(val==0) {
        if(pin==xMin) {
          line(microsteps,0,vel);
          location[0]=0;
          delay(200);
        } else if(pin==xMax) {
          line(-microsteps,0,vel);
          location[0]=dimensions[0];
          delay(200);
        } else if(pin==yMin) {
          line(0,microsteps,vel);
          location[1]=0;
          delay(200);
        } else if(pin==yMax){
          line(0,-microsteps,vel);
          location[1]=dimensions[1];
          delay(200);
        } 
        val = digitalRead(pin);
        steps-=1;
      }
      break;
    }
  }
  return steps;
}

/* Implementation of Bresenham's Algorithm for a line 
 * Input vector (in number of steps) along with pulse width
 * Proprioceptive location
 * v is speed in delayMicroseconds
 */
void line(long x1, long y1, int v) {
  location[0]+=x1;
  location[1]+=y1;
  long x0 = 0, y0=0;
  long md1, md2, s_s1, s_s2;
  long dx = abs(x1-x0), sx = x0< x1 ? 1 : -1;
  long dy = abs(y1-y0), sy = y0< y1 ? 1 : -1;
  long err = (dx>dy ? dx : -dy)/2, err_save; 
  digitalWrite(xDir,(sx+1)/2);
  digitalWrite(yDir,(sy+1)/2);
  for(;;){    
    if (x0==x1 && y0==y1) break;
    err_save = err;
    if (err_save >-dx) { 
      err -= dy; 
      x0 += sx;
      digitalWrite(xPulse, HIGH);
      if (err_save<dy) {
        err += dx; 
        y0 += sy;
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
    } else if (err_save<dy) {
        err += dx;
        y0 += sy;
        digitalWrite(yPulse, HIGH);
        delayMicroseconds(v);
        digitalWrite(yPulse, LOW);
        delayMicroseconds(v);
    } else {
    }
  }
}

double* parseCommand(char strCommand[]) {
  const char delim[2] = ":";
  char *fstr;
  fstr = strtok(strCommand,delim);
  Serial.println(fstr);
  if (strcmp(fstr,"Calibrate")==0) {
    static double j[1];
    j[0]=1;
    //Serial.println(j);
    return j;
  } else if (strcmp(fstr,"Saccade")==0) {
    static double j[4];
    j[0] = 2;
    int i = 1;
    while(fstr!=NULL) {
      fstr=strtok(NULL,delim);
      j[i++]=atof(fstr);
    }
    return j;
  } else if (strcmp(fstr,"Smooth")==0) {
    static double j[7];
    j[0]=3;
    int i = 1;
    while(fstr!=NULL) {
      fstr=strtok(NULL,delim);
      j[i++]=atof(fstr);
    }
    return j;
  } else if (strcmp(fstr,"SpeedModeling")==0) {
    //Serial.println("speedModeling");
    static double j[7];
    j[0]=4;
    int i = 1;
    while(fstr!=NULL) {
      fstr=strtok(NULL,delim);
      j[i++]=atof(fstr);
    }
    return j;
  } else {
    //Serial.println("notworking");
    static double j[1];
    j[0]=5;
    //Serial.println(j);
    return j;
  }
}

/* Main setup function
 * Verifies serial connection and traces edges for dimensions
 */
void setup()
{
  pinMode(xPulse,OUTPUT);
  pinMode(xDir,OUTPUT);
  pinMode(yPulse,OUTPUT);
  pinMode(yDir,OUTPUT);
  pinMode(xMin,INPUT);
  pinMode(xMax,INPUT);
  pinMode(yMin,INPUT);
  pinMode(yMax,INPUT);
  digitalWrite(xMin,HIGH);
  digitalWrite(xMax,HIGH);
  digitalWrite(yMin,HIGH);
  digitalWrite(yMax,HIGH);
  
  digitalWrite(yDir,direction);
  digitalWrite(xDir,direction);
  Serial.begin(9600);

  /* Communcates with Serial connection to verify */
  Serial.println("Type the letter a, then hit enter.");
  char serialInit = 'b';
  while (serialInit != 'a')
  {
    serialInit = Serial.read();
  }
  Serial.println("Ready!");

  int *i = findDimensions();
  dimensions[0] = *i * microsteps;
  dimensions[1]= *(i+1) * microsteps;
  //double array[11]= {0,156.4,309,454,587.8,707.1,809,891,951.1,987.7,1000};
  //int arraySize = 11;
  //Serial.println("Beginning");   
}


void loop() {
  // put your main code here, to run repeatedly:
  Serial.flush();
  val = Serial.readString();
  if(val!=NULL) {
    /* Speed Trials
     * Still needs testing
     */
    //Serial.println("Beginning");
    int spdi,spdf,dspd,yi,yf,dy;
    while(1) {
      val = Serial.readString();
      if(val!=NULL) {
        char commandRead[val.length()+1];
        val.toCharArray(commandRead,val.length()+1);
        Serial.println(commandRead);
        double *command = parseCommand(commandRead);
        spdi = (int) *(command+1);
        spdf = (int) *(command+2);
        dspd = (int) *(command+3);
        yi = (int) *(command+4);
        yf = (int) *(command+5);
        dy = (int) *(command+6);
        break;
        //Serial.println("Breaking");
      }
    }
    Serial.println(spdi);
    Serial.println(dy);
    
    /* Number of loops for speed and angles*/
    int speedloops = (int) ((spdf-spdi)/dspd + 1);
    int distanceloops = (int) ((yf-yi)/dy + 1);

    /* Intialize loop arrays that will be sent over*/
    unsigned long speedRuns[distanceloops];
    int xDistance[distanceloops];
    int yDistance[distanceloops];
    /* Speed Loop */
    int trialNum;
    for(int j = spdi; j<=spdf;j+=dspd) {
      int maxDelay = j;
      /* Distance Loop */
      for(int i = yi; i<=yf;i+=dy) {
        recalibrate(xMin);
        recalibrate(yMin);
        delay(1000);
        int x = 1000; // Steps
        int y = i;

        /* Calculate how long it takes to move to specified position at specified delayMicroseconds */
        long startTime = millis();
        line((long) x*microsteps,(long) y*microsteps,maxDelay);
        long endTime = millis();
        //int index = (int) (j/2) - 3;
        long timed = endTime-startTime;

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
      for(int i = 0;i<distanceloops;i++) {
        Serial.println(speedRuns[i]);
        Serial.println(xDistance[i]);
        Serial.println(yDistance[i]);
      }
      trialNum = 0;
    }
    Serial.println("Done");
  }

}
