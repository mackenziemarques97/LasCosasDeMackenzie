const int row [2] = {2, 3};//power, common anode pins
//2 is row 1
//3 is row 2
const int col [6] = {53, 52, 51, 49, 48, 47};//LED pins
//53 is BLUE11 (row 1, column 1)
//52 is GREEN11
//51 is RED11
//49 is BLUE12 (row 1, column 2)
//48 is GREEN12
//47 is RED 12

int LEDdelay = 1000;

void setup() {
  for (int InPin = 0; InPin <= 1; InPin++) {
    pinMode(row[InPin], INPUT);
    digitalWrite(row[InPin], HIGH);
  }

  for (int OutPin = 0; OutPin <= 5; OutPin++) {
    pinMode(col[OutPin], OUTPUT);
    digitalWrite(col[OutPin], HIGH);
  }


  Serial.begin(9600);
}

void loop() {
  for (int j = 0; j <= 1; j++) {
    digitalWrite(row[j], LOW);
    for (int i = 0; i <= 5; i++) {
      digitalWrite(col[i], LOW);
      delay(LEDdelay);
      digitalWrite(col[i], HIGH);
      delay(LEDdelay);
    }
    digitalWrite(row[j], HIGH);
  }
}
