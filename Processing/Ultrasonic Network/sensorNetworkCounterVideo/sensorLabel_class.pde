class SensorLabel {
  XBeeSensorData xBeeData;
  String name;
  int drawX;
  int drawY;
  int trigger;
  int id;
  int moveCount = 0;
  boolean bodyPreviouslyThere = false;

  public SensorLabel(int idNumber, int x, int y, String sensorName, int threshold) {
    drawX = x;
    drawY = y;
    id = idNumber;
    name = sensorName;
    trigger = threshold;
  }

  void drawNumbers() {
    //check that actual data came in:
    if (xBeeData != null) {
      if (xBeeData.value !=0 && xBeeData.address != null) {
        println(xBeeData.address);
        println(xBeeData.value);
        updateSensorOutput();
        //text(xBeeData.value, drawX, drawY);
        int sensorOut = xBeeData.value;

        //condition2
        // if there was *just* a body there but now it's gone
        if (bodyPreviouslyThere && !isSomeoneThere()) {
          moveCount++; 

          updateCounterDrawing();
          writeToCsv();
          bodyPreviouslyThere = false;
        }

        //condition1
        // if there wasn't a body there but now there is!
        if (!bodyPreviouslyThere && isSomeoneThere()) {
          bodyPreviouslyThere = true;
        }
        //updateSensorDrawing(sensorOut);
      }
    }
  }

  boolean isSomeoneThere() {
    return xBeeData.value <= trigger;
  }

  void updateCounterDrawing() {
    fill(255);
    rect(drawX, drawY, 210, 100);
    fill(#e6e7e8);
    rect(drawX, drawY + 35, 124, 30);
    fill(#58595b);
    textFont(font, 15);
    text(name, drawX + 8, drawY + 55);

    fill(#808285);
    text("count", drawX + 149, drawY + 38);

    fill(#58595b);
    textFont(font, 30);
    text(moveCount, drawX + 149, drawY + 68);
  }

  void updateSensorOutput() {
    fill(255);
    rect(drawX + 210, drawY, 90, 100);

    textFont(font, 15);
    fill(#808285);
    text("reading", drawX + 222, drawY + 38);

    fill(#58595b);
    textFont(font, 30);
    text(xBeeData.value, drawX + 222, drawY + 68);
  }

  void writeToCsv() {
    output.println(month() + "/" + day() + "/" + year() + "," + hour() + ":" + minute() + ":" + second() + "," + id);
  }
}

