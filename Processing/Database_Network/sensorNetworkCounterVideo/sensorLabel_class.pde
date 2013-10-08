public class SensorLabel implements CountingSensorObserver {
  int drawX;
  int drawY;
  String name;

  public SensorLabel(int x, int y, CountingSensor sensor) {
    drawX = x;
    drawY = y;
    name = sensor.getName();
    sensor.addObserver(this);
  }

  public void sensorValueUpdated(CountingSensor s) {
    updateSensorValue(s.getValue());
  }

  public void sensorCountUpdated(CountingSensor s) {
    updateCounterDrawing(s.getCount());
  }


  void updateCounterDrawing( int count) {
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
    text(count, drawX + 149, drawY + 68);
  }

  void updateSensorValue(int value) {
    fill(255);
    rect(drawX + 210, drawY, 90, 100);

    textFont(font, 15);
    fill(#808285);
    text("reading", drawX + 222, drawY + 38);

    fill(#58595b);
    textFont(font, 30);
    text(value, drawX + 222, drawY + 68);
  }

}

