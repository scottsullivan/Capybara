JSONObject json;
Dot[] ones;

void setup() {
  size(1280, 720);
  loadData();
}

void draw() {
  for (Dot d : ones) {
    d.display();
  }
}

void loadData() {
  // Load JSON file
  // Temporary full path until path problem resolved.
  json = loadJSONObject("data.json");

  JSONArray one = json.getJSONArray("1");
  JSONArray two = json.getJSONArray("2");
  JSONArray three = json.getJSONArray("3");
  JSONArray four = json.getJSONArray("4");
  JSONArray five = json.getJSONArray("5");
  JSONArray six = json.getJSONArray("6");

  ones = new Dot[one.size()];
  //  twos = new Dot[two.size()];
  //  threes = new Dot[three.size()];
  //  fours = new Dot[four.size()];
  //  fives = new Dot[five.size()];
  //  sixes = new Dot[six.size()];

  for (int i = 0; i < one.size(); i++) {
    //JSONObject dot = one.getJSONArray("ones");
    JSONObject time = one.getJSONObject("time");
    //String time = one.getString("time");

    ones[i] = new Dot(time);
  }
}

// - - - - Dot class

class Dot {
  String time;

  // Create  the Dot
  Bubble(String t) {
    time = s;
  }

  // Display the Dot
  void display() {
    stroke(0);
    strokeWeight(2);
    noFill();
    ellipse(x, y, 10, 10);
    fill(0);
  }
}

