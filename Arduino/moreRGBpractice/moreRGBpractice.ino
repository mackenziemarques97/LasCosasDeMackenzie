int green = 50;


void setup() {
  // put your setup code here, to run once:
Serial.begin(9600);
pinMode(green, OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
digitalWrite(green, LOW);
Serial.println("on");
delay(2000);
digitalWrite(green, HIGH);
Serial.println("off");
delay(2000);
digitalWrite(green, LOW);
}
