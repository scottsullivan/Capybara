import java.util.Date; 

ArrayList<Trigger> triggers = new ArrayList();

float timer = 0;

void setup() {
  size(1280, 720, P3D);
  loadOpenPaths("triggers.csv");
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
      t.router = r.getString(i, "router");
      t.location = r.getInt(i, "location");
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

