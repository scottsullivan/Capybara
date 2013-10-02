public interface CountingSensor {
  public int getCount();
  public int getValue();
  public String getName();
  public int getIndex();
  public void addObserver(CountingSensorObserver c);

  public SensorReading getReading();
}
