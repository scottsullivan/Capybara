import java.util.List;
import java.util.ArrayList;
class SensorDataStore implements TriggeredSensorObserver {

  private List<DataAdapter> adapters;


  public void monitorSensor(TriggeredSensor s) {
    s.addObserver(this);
  }

  public void monitorSensors(TriggeredSensor... sensors) {
    for (TriggeredSensor s : sensors) {
      s.addObserver(this);
    }
  }

/**
 * A TriggeredSensor's value is the raw measurement of the
 * sensor at any given time
 */
 
  public void sensorReadingUpdated(SensorReading s) {
    saveReading(s);
  }

  public SensorDataStore() {
    adapters = new ArrayList<DataAdapter>();
  }

  public void addAdapter(DataAdapter a) {
    adapters.add(a);
  }

  public void saveReading(SensorReading r) {
    for (DataAdapter adapter : adapters) {
      adapter.saveReading(r);
    }
  }

}
