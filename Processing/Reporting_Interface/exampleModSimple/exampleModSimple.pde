JSONObject json;

void setup() {

  json = loadJSONObject("readings.json");

  JSONObject sensor = json.getJSONObject("1");
  JSONArray readings = sensor.getJSONArray("readings");
  
  for (int i = 0; i < readings.size(); i++) {
    JSONObject triggers = readings.getJSONObject(i); 

    String time = triggers.getString("time");
    String value = triggers.getString("value");

    println(time + ", " + value);
  }
}
