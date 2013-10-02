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
  background(#dd5a47);

  drawLabels();

  for (Trigger t:triggers) {
    t.update();
    t.render();
  }

  // mouse version
  float tf = map(mouseX, 0, width, 0, 1);
  for (Trigger t:triggers) {
    if (t.timeFraction < tf) {
      t.label();
    }
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

