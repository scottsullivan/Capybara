JSONObject json;
Tester[] testers;

void setup() {
  loadData();
  for (Tester t : testers) {
    t.display();
  }
}

void draw() {
}

// - - - - - - - - - - - - - - - - - - - - - - - 
// TRIGGER CLASS
// - - - - - - - - - - - - - - - - - - - - - - - 
class Tester {
  String time;
  String value;

  Tester(String time_, String value_) {
    time = time_;
    value = value_;
  }

  // Display the Bubble
  void display() {
    println(time + ", " + value);
  }
}

void loadData() {
  // Load JSON file
  // Temporary full path until path problem resolved.
  json = loadJSONObject("readings.json");

  JSONObject sensor = json.getJSONObject("1");
  JSONArray readings = sensor.getJSONArray("readings");

  // The size of the array of Bubble objects is determined by the total XML elements named "bubble"
  testers = new Tester[readings.size()]; 

  for (int i = 0; i < readings.size(); i++) {
    JSONObject triggers = readings.getJSONObject(i); 

    String time = triggers.getString("time");
    String value = triggers.getString("value");

    // Put object in array
    testers[i] = new Tester(value, time);
  }
}

