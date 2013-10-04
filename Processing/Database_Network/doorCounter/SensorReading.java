/**
 * A SensorReading is what the rest of the world cares about getting from a sensor.
 * It has a timestamp, the id of the sensor that produced it, and a value in the form
 * of a astring.
 */
public class SensorReading {
  public String time;
  public int sensorIndex;
  public String readingValue;

  public SensorReading(String timeStamp, int index, String val) {
    time = timeStamp;
    sensorIndex = index;
    readingValue = val;
  }

  public SensorReading(String timeStamp, int index, int val) {
    time = timeStamp;
    sensorIndex = index;
    readingValue = Integer.toString(val);
  }

  public int getIndex() {
    return this.sensorIndex;
  }

  public String getTimeStamp() {
    return this.time;
  }

  public String getValue() {
    return this.readingValue;
  }

  public String toCSV() {
    return String.format("%s,%s,%s", getIndex(), getValue(), getTimeStamp());
  }
}
