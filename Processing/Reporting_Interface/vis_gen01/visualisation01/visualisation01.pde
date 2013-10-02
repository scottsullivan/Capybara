import java.util.Date; 

ArrayList<Trigger> triggers = new ArrayList();

float timer = 0;

void setup() {
  size(1280, 720, P3D);
  loadOpenPaths("ALL_4_14_2.csv");
  setTimes();
  placeVisits();
}

void draw() {
  background(0);

  // mouse version
 // float tf = map(mouseX, 0, width, 0, 1);
  for (Trigger t:triggers) {
    //if (t.timeFraction < tf) {
      t.update();
      t.render();
    //}
  }


  //timer version
  //  timer += 0.001;
  //  stroke(255);
  //  if (timer > 1) timer = 0;
  //  line(timer * width, 0, timer * width, height);
  //  for (Trigger t:triggers) {
  //    if (t.timeFraction < timer) {
  //      t.update();
  //      t.render();
  //    }
  //  }
}

  void loadOpenPaths(String url) {
    Table r = loadTable(url);
    r.removeTitleRow();
    for (int i = 0; i < r.getRowCount(); i++) {
      //date,routeer,door,gifts,womens one,womens two,mens,upstairs 
      Trigger t = new Trigger();
      triggers.add(t);
      t.timeString = r.getString(i, "date");
      t.router = r.getString(i, "routeer");
      t.door = r.getInt(i, "door");
      t.gifts = r.getInt(i, "gifts");
      t.womensOne = r.getInt(i, "womens one");
      t.womensTwo = r.getInt(i, "womens two");
      t.mens = r.getInt(i, "mens");
      t.upstairs = r.getInt(i, "upstairs");
      t.location = r.getInt(i, "location");
      //    t.lonLat.x = r.getFloat(i, "lon");
      //    t.lonLat.y = r.getFloat(i, "lat");
      //    t.alt = r.getFloat(i, "alt");
      t.init();
    }
  }

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

  //void keyPressed() {
  //  if (key == 'n') {
  //    //reposition points using an NYC bounding box 
  //    //new york -74.078256,40.623992,-73.744028,40.882218
  //    PVector tl = new PVector(-74.078256, 40.623992);
  //    PVector br = new PVector(-73.744028, 40.882218);
  //    placeVisits(tl, br);
  //  }
  //  if (key == 'o') {
  //    //ohio -84.8203,38.4032,-80.519,41.7603
  //    //reposition points using an Ohio bounding box
  //    PVector tl = new PVector(-84.8203, 38.4032);
  //    PVector br = new PVector(-80.519, 41.7603);
  //    placeVisits(tl, br);
  //  }
  //
  //  if (key == 'c') {
  //    //columbus -83.1834,39.8266,-82.8041,40.092
  //    PVector tl = new PVector(-83.1834, 39.8266);
  //    PVector br = new PVector(-82.8041, 40.092);
  //    placeVisits(tl, br);
  //  }
  //
  //  if (key == 'w') {
  //    placeVisits(new PVector(-180, -90), new PVector(190, 90));
  //  }
  //}

