import java.util.List;
import java.util.ArrayList;
class SensorDataStore implements CountingSensorObserver {

  private List<DataAdapter> adapters;


  public void monitorSensor(CountingSensor s) {
    s.addObserver(this);
  }

  public void monitorSensors(CountingSensor... sensors) {
    for (CountingSensor s : sensors) {
      s.addObserver(this);
    }
  }

/**
 * A CountingSensor's value is the raw measurement of the
 * sensor at any given time
 */
  public void sensorValueUpdated(CountingSensor s) {
  }

  public void sensorCountUpdated(CountingSensor s) {
    saveReading(s.getReading());
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
