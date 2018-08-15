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

/*TEMPORARY: Testing the speed model
    int angleTrials = 10;
    long minDim = min((long)(dimensions[0] / microsteps), (long)(dimensions[1] / microsteps));
    int ddistance = (int) (0.9 * minDim / (angleTrials - 1));
    int maxDistance = ddistance * (angleTrials - 1);
    for (int i = 15; i <= 75; i += 5) {
    int Delay = i;
    for (int j = 0; j <= maxDistance; j += ddistance) {
      recalibrate(xMin);
      recalibrate(yMin);
      delay(1000);
      int x = maxDistance;
      int y = j;
      long startTime = millis();
      line((long) x * microsteps, (long) y * microsteps, Delay);
      long endTime = millis();
      long timed = endTime - startTime;
      long path = sqrt(pow(x, 2) + pow(y, 2));
      float sec = timed / 1000.0;
      long speedA = (path / sec) * (0.037699/200.0);
      double ang = atan((double) y / x) * (180 / pi);
      //Serial.println(path);
      //Serial.println(timed);
      //Serial.println(sec);
      Serial.print("Delay: ");
      Serial.print(i);
      Serial.print(" Angle: ");
      Serial.println(ang);
      Serial.println(speedA);
      Serial.println(" m/s");
    }
    }*/
