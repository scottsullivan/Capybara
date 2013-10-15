import java.util.Date;

JSONObject json;
ArrayList<Trigger> triggers = new ArrayList();

// - - - - - - - - - - - - - - - - - - - - - - - 
// TRIGGER CLASS
// - - - - - - - - - - - - - - - - - - - - - - - 
void setup() {
  loadData("1");
  loadData("2");
  loadData("3");
  loadData("4");
  loadData("5");
  loadData("6");

  for (Trigger t : triggers) {
    t.init();
    t.display();
  }
}

// - - - - - - - - - - - - - - - - - - - - - - - 
// DRAW LOOP
// - - - - - - - - - - - - - - - - - - - - - - - 
void draw() {
}

// - - - - - - - - - - - - - - - - - - - - - - - 
// LOAD DATA
// - - - - - - - - - - - - - - - - - - - - - - - 
void loadData(String sensorNo) {
  json = loadJSONObject("readings.json");

  JSONObject sensor = json.getJSONObject(sensorNo);
  JSONArray readings = sensor.getJSONArray("readings");

  for (int i = 0; i < readings.size(); i++) {
    Trigger t = new Trigger();
    triggers.add(t);

    JSONObject triggers = readings.getJSONObject(i); 

    t.timeString = triggers.getString("time");
    t.value = triggers.getString("value");
    t.sensor = sensorNo;
  }
}

// - - - - - - - - - - - - - - - - - - - - - - - 
// TRIGGER CLASS
// - - - - - - - - - - - - - - - - - - - - - - - 
class Trigger {
  String timeString;
  String value;
  String sensor;
  Date time;

  void init() {
    //2013-10-09T17:14:03Z 
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd'T'hh:mm:ss'Z'");
    try {
      time = sdf.parse(timeString);
    } 
    catch(Exception e) {
      println("error parsing date" + e);
    }
  }

//  void update() {
//    pos.lerp(tpos, 0.1);
//  }

  void display() {
    println(time + ", " + sensor);
  }
}

