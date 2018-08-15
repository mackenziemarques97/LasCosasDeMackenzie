double forward_coeffs[16] = {0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09,0.010,0.011,0.012,0.013,0.014,0.015,0.016};

/*Function to calculate speed from given delay
   inputs: forward coefficients array, delay, angle
   calculate speed using nested exp2 function
*/
double delayToSpeed(double forward_coeffs[], double Delay, double angle) {
  double complex_coeffs[4];
  for (int i = 0; i <= 3; i++) {
    double temp_coeff[4]={forward_coeffs[0+i*4],forward_coeffs[1+i*4],forward_coeffs[2+i*4],forward_coeffs[3+i*4]};
    complex_coeffs[i] = exp2(temp_coeff, Delay);
  }
  double Speed = exp2(complex_coeffs, angle);
          return Speed;
}

/*2 term exponential function
   inputs: 1x4 coefficients array, independent variable (x)
   calculate scalar output of function
*/
double exp2(double coeffs[], double x) {
  double output = coeffs[0] * exp(coeffs[1] * x) + coeffs[2] * exp(coeffs[3] * x);
  return output;
}

void setup() {
  // put your setup code here, to run once:
Serial.begin(9600);

Serial.println(delayToSpeed(forward_coeffs, 10, 10));

}

void loop() {
  // put your main code here, to run repeatedly:

}
