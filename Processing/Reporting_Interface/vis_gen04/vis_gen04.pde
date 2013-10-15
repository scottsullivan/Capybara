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


  loadData();
  //  loadData("2");
  //  loadData("3");
  //  loadData("4");
  //  loadData("5");
  //  loadData("6");
}

// - - - - - - - - - - - - - - - - - - - - - - - 
// DRAW LOOP
// - - - - - - - - - - - - - - - - - - - - - - - 
void draw() {
  background(0);

  for (Trigger t:triggers) {
    //t.update();
    t.render();
  }
}

// - - - - - - - - - - - - - - - - - - - - - - - 
// LOAD DATA
// - - - - - - - - - - - - - - - - - - - - - - - 
void loadData() {
  json = loadJSONObject("readings.json");
  JSONObject sensor = json.getJSONObject("1");
  JSONArray readings = sensor.getJSONArray("readings");

  for (int i = 0; i < readings.size(); i++) {
    JSONObject triggerRead = readings.getJSONObject(i); 

    String time = triggerRead.getString("time");
    String value = triggerRead.getString("value");

    triggers[i] = new Trigger(value, time, "1");
  }
}

// - - - - - - - - - - - - - - - - - - - - - - - 
// TIME EVAL
// - - - - - - - - - - - - - - - - - - - - - - - 
//void setTimes() {
//  Date startDate = triggers.get(0).time;
//  Date endDate = triggers.get(triggers.size() -1).time;
//  
//  for (Trigger t:triggers) {
//    long startTime = startDate.getTime();
//    long endTime = endDate.getTime();
//    long visitTime = t.time.getTime();
//    t.timeFraction = ((float) (visitTime - startTime)) / ((float) (endTime - startTime));
//    println(t.timeFraction);
//  }
//}
//
//void placeVisits() {
//  for (Trigger t:triggers) {
//    t.tpos.x = map(t.timeFraction, 0, 1, 0, width);
//    t.tpos.y = map(t.location, 1, 6, 100, height - 100);
//  }
//}

// - - - - - - - - - - - - - - - - - - - - - - - 
// TRIGGER CLASS
// - - - - - - - - - - - - - - - - - - - - - - - 
class Trigger {
  String value;
  String timeString;
  String sensor;
  Date time;

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
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss ");
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
    //    noStroke();
    //    fill(255, 50);
    //    pushMatrix();
    //    translate(pos.x, pos.y, pos.z);
    //    ellipse(0, 0, 5, 5);
    //    popMatrix();
    println(sensor + "/" + time);
  }
} // - - end Trigger class

