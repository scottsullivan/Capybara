import java.util.Date;
import java.util.*;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

public class TriggeredSensor {
  static DateFormat timeStampFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
  
  private List<TriggeredSensorObserver> observers = new ArrayList<TriggeredSensorObserver>();
  public void addObserver(TriggeredSensorObserver observer) {
    observers.add(observer);
  }
  
  protected void notifyReadingUpdated() {
    for (TriggeredSensorObserver obs : observers) {
      obs.sensorReadingUpdated(getReading());
    }
  }
  
   public SensorReading getReading() {
    return new SensorReading(getTimeStamp(), 0, "Don't do this");
  }
  
  public String getTimeStamp() {
    Date date = new Date();
    return timeStampFormat.format(date);
  }

  
}
