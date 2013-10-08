public class DoorSensor extends TriggeredSensor {
  private int index;
  private String enterExit;
  
  public DoorSensor(int _index) { 
    index = _index;
  }
    
  public SensorReading getReading() {
    return new SensorReading(getTimeStamp(), index, getEnterExit());
  }
  
  public void triggerEnterExit(String status) {
    enterExit = status;
    notifyReadingUpdated();
  }
  
  private String getEnterExit() {
   return enterExit;
  }
}
