// - - - - - - - - - - - - - - - - - - - - - - - 
// Capybara Data Visualization
// Scott Sullivan and Erik Dahl / Involution Studios
// - - - - - - - - - - - - - - - - - - - - - - -

// - - - - - - - - - - - - - - - - - - - - - - - 
// IMPORT LIBRARIES
// - - - - - - - - - - - - - - - - - - - - - - - 
import java.util.Date; 

// - - - - - - - - - - - - - - - - - - - - - - - 
// GLOBAL VARIABLES
// - - - - - - - - - - - - - - - - - - - - - - - 
JSONObject json;

Trigger[] triggers;

// - - - - - - - - - - - - - - - - - - - - - - - 
// SETUP
// - - - - - - - - - - - - - - - - - - - - - - - 
void setup() {
  size(1280, 720, P3D);
  json = loadJSONObject("readings.json");
  
  loadData("1");
  loadData("2");
  loadData("3");
  loadData("4");
  loadData("5");
  loadData("6");
}

// - - - - - - - - - - - - - - - - - - - - - - - 
// DRAW LOOP
// - - - - - - - - - - - - - - - - - - - - - - - 
void draw() {
  background(0);

  for (Trigger t:triggers) {
    t.update();
    t.render();
  }
}

// - - - - - - - - - - - - - - - - - - - - - - - 
// LOAD DATA
// - - - - - - - - - - - - - - - - - - - - - - - 
void loadData(String sensor) {
  JSONObject sensor = json.getJSONObject(sensor);
  JSONArray readings = sensor.getJSONArray("readings");

  for (int i = 0; i < readings.size(); i++) {
    JSONObject triggers = readings.getJSONObject(i); 

    String time = triggers.getString("time");
    String value = triggers.getString("value");

    triggers[i] = new Trigger(value, time, sensor);
  }
}

// - - - - - - - - - - - - - - - - - - - - - - - 
// TIME EVAL
// - - - - - - - - - - - - - - - - - - - - - - - 
void placeVisits() {
  for (Trigger t:triggers) {
    t.tpos.x = map(t.timeFraction, 0, 1, 0, width);
    t.tpos.y = map(t.location, 1, 6, 100, height - 100);
  }
}

void setTimes() {
  Date startDate = triggers.get(0).time;
  Date endDate = triggers.get(triggers.size() -1).time;
  for (Trigger t:triggers) {
    long startTime = startDate.getTime();
    long endTime = endDate.getTime();
    long visitTime = t.time.getTime();
    t.timeFraction = ((float) (visitTime - startTime)) / ((float) (endTime - startTime));
    println(t.timeFraction);
  }
}

// - - - - - - - - - - - - - - - - - - - - - - - 
// TRIGGER CLASS
// - - - - - - - - - - - - - - - - - - - - - - - 
class Trigger {
  String value;
  String timeString;
  String sensor

  PVector pos = new PVector();
  PVector tpos = new PVector();

  // Create  the Bubble
  Trigger(String value_, String timeString_, String sensor_) {
    value = value_;
    timeString = timeString_;
    sensor = sensor_;
  }

  void init() {
    //2013-10-09T17:14:03Z 
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-ddThh:mm:ssZ");
    try {
      time = sdf.parse(timeString);
    } 
    catch(Exception e) {
      println("error parsing date" + e);
    }
  }

  void update() {
    pos.lerp(tpos, 0.1);
  }


  // Display the Bubble
  void render() {
    noStroke();
    fill(255, 50);
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    ellipse(0, 0, 5, 5);
    popMatrix();
  }
} // - - end Trigger class

