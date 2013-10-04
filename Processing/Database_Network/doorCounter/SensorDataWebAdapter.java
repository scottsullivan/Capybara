import org.json.*;


import java.util.*;
class SensorDataWebAdapter implements DataAdapter {
  private int bufferSize = 5;
  private int readingCount = 0;
  private Map sensorBuckets = new HashMap();
  private String apiKey;
  private String projectId;
  private String rootURL;
  private String postURL;
  private String checkURL;
  private HttpDataWriter writer;


  public void saveReading(SensorReading r) {
    String sIndex = Integer.toString(r.getIndex());
    ArrayList bucketList;
    if (sensorBuckets.containsKey(sIndex)) {
      bucketList = (ArrayList) sensorBuckets.get(sIndex);
    } else {
      bucketList = new ArrayList();
      sensorBuckets.put(sIndex, bucketList);
    }
    bucketList.add(r);
    readingCount++;
    if (readingCount >= bufferSize) {
      flushReadingBuffer();
    }

  }

  public SensorDataWebAdapter(String _rootURL, String _projectId, String _apiKey) {
     this.rootURL= _rootURL;
     this.projectId = _projectId;
     this.apiKey = _apiKey;
     this.postURL = String.format("%s/readings?auth_token=%s", rootURL, apiKey);
     this.checkURL = String.format("%s/tokens/check?auth_token=%s", rootURL, apiKey);

     this.writer = new HttpDataWriter();
     checkLogin();
  }

  public void checkLogin() {
    this.writer.getStatus(this.checkURL);
  }

  private JSON readingBufferToJSON() {
    JSON project = JSON.createObject();
    project.setString("project_id", this.projectId);

    JSON sensorArray = JSON.createArray();
    Iterator iter = sensorBuckets.entrySet().iterator();
    while (iter.hasNext()) {
      Map.Entry mEntry = (Map.Entry) iter.next();
      JSON thisSensor = JSON.createObject();
      thisSensor.setString("project_index", mEntry.getKey().toString());
      thisSensor.setJSON("readings", readingsArray((ArrayList)mEntry.getValue()));
      sensorArray.append(thisSensor);
    }

    project.setJSON("sensors", sensorArray);
    return project;

  }

  private JSON readingsArray(ArrayList<SensorReading> list) {
    JSON thisArray = JSON.createArray();
    for (SensorReading r : list) {
      JSON reading = JSON.createObject();
      reading.setString("time", r.getTimeStamp());
      reading.setString("value", r.getValue());
      thisArray.append(reading);
    }

    return thisArray;
  }

  private void flushReadingBuffer() {
    writer.postJSON(this.postURL, readingBufferToJSON().toString());
    this.readingCount = 0;
    this.sensorBuckets = new HashMap();
  }


}
