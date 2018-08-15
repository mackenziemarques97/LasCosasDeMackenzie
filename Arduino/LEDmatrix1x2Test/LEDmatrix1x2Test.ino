int LEDdelay = 1000;
int BLUE1 = 53;
int GREEN1 = 52;
int RED1 = 51;
int BLUE2 = 49;
int GREEN2 = 48;
int RED2 = 47;

int LEDarray[] = {BLUE1, GREEN1, RED1, BLUE2, GREEN2, RED2};

void setup() {
  pinMode(BLUE1, OUTPUT);
  pinMode(GREEN1, OUTPUT);
  pinMode(RED1, OUTPUT);
  pinMode(BLUE2, OUTPUT);
  pinMode(GREEN2, OUTPUT);
  pinMode(RED2, OUTPUT);
  digitalWrite(BLUE1, HIGH);
  digitalWrite(GREEN1, HIGH);
  digitalWrite(RED1, HIGH);
  digitalWrite(BLUE2, HIGH);
  digitalWrite(GREEN2, HIGH);
  digitalWrite(RED2, HIGH);

  Serial.begin(9600); 
}

void loop() {
    for (int i = 0; i <= 5; i++) {
      Serial.println(LEDarray[i]);
      digitalWrite(LEDarray[i], HIGH);
      delay(LEDdelay);
      digitalWrite(LEDarray[i], LOW);
      delay(LEDdelay);
      digitalWrite(LEDarray[i], HIGH);
    }
}

