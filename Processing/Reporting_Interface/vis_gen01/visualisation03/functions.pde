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
    t.tpos.x = map(t.timeFraction, 0, 1, 100, 1225);
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

void drawLabels() {
  stroke(0, 50);
  fill(0, 50);
  text("11:00 AM", 105, 10);
  line(100, 0, 100, height);
  text("12:00 PM", 230, 10);
  line(225, 0, 225, height);
  text("1:00 PM", 355, 10);
  line(350, 0, 350, height);
  text("2:00 PM", 480, 10);
  line(475, 0, 475, height);
  text("3:00 PM", 605, 10);
  line(600, 0, 600, height);
  text("4:00 PM", 730, 10);
  line(725, 0, 725, height);
  text("5:00 PM", 855, 10);
  line(850, 0, 850, height);
  text("6:00 PM", 980, 10);
  line(975, 0, 975, height);
  text("7:00 PM", 1105, 10);
  line(1100, 0, 1100, height);
  text("8:00 PM", 1230, 10);
  line(1225, 0, 1225, height);
}

