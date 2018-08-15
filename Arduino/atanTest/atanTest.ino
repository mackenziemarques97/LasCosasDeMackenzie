float pi = 3.14159265359;

void setup() {
  // put your setup code here, to run once:
Serial.begin(9600);
int x = 10;
int y = 10;
double ang = atan(y/x) * (180/pi);
Serial.println(ang);
}

void loop() {
  // put your main code here, to run repeatedly:

}
