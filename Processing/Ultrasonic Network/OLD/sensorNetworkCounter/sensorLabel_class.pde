class SensorLabel {
  XBeeSensorData xBeeData;
  String name;
  int drawX;
  int drawY;
  int moveCount = 0;
  boolean bodyPreviouslyThere = false;

  public SensorLabel( int x, int y, String sensorName) {
    drawX = x;
    drawY = y;
    name = sensorName;
  }

  void drawNumbers() {
    //check that actual data came in:
    if (xBeeData != null) {
      if (xBeeData.value !=0 && xBeeData.address != null) {
        println(xBeeData.address);
        println(xBeeData.value);
        //text(xBeeData.value, drawX, drawY);
        int sensorOut = xBeeData.value;

        //condition2
        // if there was *just* a body there but now it's gone
        if (bodyPreviouslyThere && !isSomeoneThere(sensorOut)) {
          moveCount++; 

          updateCounterDrawing(moveCount, sensorOut, drawX, drawY, name);
          output.println(month() + "/" + day() + "/" + year() + "," + hour() + ":" + minute() + ":" + second() + "," + xBeeData.address);
          output.flush(); // Writes the remaining data to the file

          bodyPreviouslyThere = false;
        }

        //condition1
        // if there wasn't a body there but now there is!
        if (!bodyPreviouslyThere && isSomeoneThere(sensorOut)) {
          bodyPreviouslyThere = true;
        }
        //updateSensorDrawing(sensorOut);
      }
    }
  }
}
