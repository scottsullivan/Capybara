public interface TriggeredSensor {

  public void addObserver(TriggeredSensorObserver c);

  public SensorReading getReading();
}
