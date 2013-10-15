// - - - - - - - - - - - - - - - - - - - - - - - 
// Capybara Data Visualization
// Scott Sullivan and Erik Dahl / Involution Studios
// - - - - - - - - - - - - - - - - - - - - - - -

// FEATURES TO ADD

// find the earliest and latest date in the array list
// throw that shit up on the screen

import java.util.Date;

JSONObject json;
ArrayList<Trigger> triggers = new ArrayList();

// - - - - - - - - - - - - - - - - - - - - - - - 
// TRIGGER CLASS
// - - - - - - - - - - - - - - - - - - - - - - - 
void setup() {
  size(1280, 720, P3D);

  loadData("1");
  loadData("2");
  loadData("3");
  loadData("4");
  loadData("5");
  loadData("6");

  for (Trigger t : triggers) {
    t.init();
    //t.display();
  }

  findFirstLast();
}

// - - - - - - - - - - - - - - - - - - - - - - - 
// DRAW LOOP
// - - - - - - - - - - - - - - - - - - - - - - - 
void draw() {
  background(0);
  for (Trigger t:triggers) {
    t.update();
    t.display();
  }
}
// - - - - - - - - - - - - - - - - - - - - - - - 
// LOAD DATA
// - - - - - - - - - - - - - - - - - - - - - - - 
void loadData(String sensorNo) {
  json = loadJSONObject("http://mysterious-plains-9032.herokuapp.com/projects/524e2cd01429d8912c000002/data?auth_token=6QY7rMzkz4vn1USwy4xy");

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
// TIME HANDLING
// - - - - - - - - - - - - - - - - - - - - - - - 
void findFirstLast() {
  Date startDate = triggers.get(5).time;
  Date endDate = triggers.get(5).time;

  long startTime = startDate.getTime();
  long endTime = endDate.getTime();

  for (Trigger t:triggers) {
    long currentTime = t.time.getTime();

    if (currentTime < startTime) startTime = currentTime;
    if (currentTime > endTime) endTime = currentTime;
  }

  for (Trigger t:triggers) {
    long currentTime = t.time.getTime();

    t.timeFraction = ((float) (currentTime - startTime)) / ((float) (endTime - startTime));
    println(t.timeFraction);
  }

  for (Trigger t:triggers) {
    t.tpos.x = map(t.timeFraction, 0, 1, 0, width);
    t.tpos.y = map(Integer.parseInt(t.sensor), 1, 6, 100, height - 100);
  }
}

// - - - - - - - - - - - - - - - - - - - - - - - 
// TRIGGER CLASS
// - - - - - - - - - - - - - - - - - - - - - - - 
class Trigger {
  String timeString;
  String value;
  String sensor;
  long timeNum;
  float timeFraction;
  Date time;

  PVector pos = new PVector();
  PVector tpos = new PVector();

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

  void update() {
    pos.lerp(tpos, 0.1);
  }

  void display() {
    noStroke();
    fill(255, 50);
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    ellipse(0, 0, 5, 5);
    popMatrix();
  }
}

