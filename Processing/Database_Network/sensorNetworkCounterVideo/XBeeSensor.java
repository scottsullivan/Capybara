import java.util.*;
public class XBeeSensor implements CountingSensor {

  static Map<String, XBeeSensor> sensors = new HashMap<String, XBeeSensor>();
  String name;
  String address;
  int id;
  int trigger;
  XBeeSensorData xBeeData;
  int moveCount = 0;
  boolean bodyPreviouslyThere = false;
  private List<CountingSensorObserver> observers = new ArrayList<CountingSensorObserver>();

  public static XBeeSensor registerSensor(int id, String name, String address, int trigger) {
    XBeeSensor s = new XBeeSensor(id, name, address, trigger);
    sensors.put(address, s);
    return s;
  }

  public XBeeSensor(int _id, String _name, String _address, int _trigger) {
    id = _id;
    name = _name;
    address = _address;
    trigger = _trigger;
  }

  public void addObserver(CountingSensorObserver observer) {
    observers.add(observer);
  }

  public static void update(XBeeSensorData newData) {
    if ((newData != null) && (newData.address != null)) {
      sensors.get(newData.address).setData(newData);
    }
  }

  public int getValue() {
    return this.xBeeData.value;
  }
  
  public int getIndex() {
    return this.id;
  }

  public int getCount() {
    return this.moveCount;
  }

  public String getName() {
    return this.name;
  }

  public SensorReading getReading() {
    return new SensorReading(xBeeData.getTimeStamp(), this.id, getCount());
  }

  public void setData(XBeeSensorData data) {
    xBeeData = data;
    if (xBeeData.value != 0) {
      notifyValueChanged();
    }
    // if there was *just* a body there but now it's gone
    if (bodyPreviouslyThere && !isSomeoneThere()) {
      moveCount++;
      notifyCountChanged();
      bodyPreviouslyThere = false;
    }

    if (!bodyPreviouslyThere && isSomeoneThere()) {
      bodyPreviouslyThere = true;
    }
  }

  private boolean isSomeoneThere() {
    return xBeeData.value <= trigger;
  }

  private void notifyCountChanged() {
    for (CountingSensorObserver obs : observers) {
      obs.sensorCountUpdated(this);
    }
  }

  private void notifyValueChanged() {
    for (CountingSensorObserver obs : observers) {
      obs.sensorValueUpdated(this);
    }
  }
}
