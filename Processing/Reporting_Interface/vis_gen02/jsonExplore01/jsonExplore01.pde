JSONArray json;

void setup() {

  json = loadJSONArray("triggers.json");

  for (int i = 0; i < json.size(); i++) {

    JSONObject tigertree = json.getJSONObject(i); 

    String t = tigertree.getString("t");
    String address = tigertree.getString("address");

    println(t + ", " + address);
  }
}

void draw() {
}

