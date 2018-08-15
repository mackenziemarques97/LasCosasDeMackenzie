#define xPulse 8
#define xDir 9

void setup() {
  // put your setup code here, to run once:
pinMode(xPulse, OUTPUT);
pinMode(xDir, OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
digitalWrite(xDir, 1);
digitalWrite(xPulse, HIGH);
delayMicroseconds(100);
digitalWrite(xPulse, LOW);

}
