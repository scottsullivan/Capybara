// sketch to learn some simple interface things like tabs and buttons changing the sketch like an application

boolean button1Active = false;
boolean changed = false;
Target theTarget = new Target();
PrintWriter output;

void setup() {
  size(600, 400);
  background(255);
  smooth();
  loadData("target.csv");
}

void draw() {
  if (!button1Active && !changed) {
    defaultScreen();
    drawButtons();
    fill(255);
    textAlign(CENTER);
    text("SETUP", width-50, 25);
  }
  if (button1Active && !changed) {
    button1Screen();
    theTarget.display();
    drawButtons();
    fill(255);
    textAlign(CENTER);
    text("SAVE", width-50, 25);
    text("Drag the corners to match your front door", width/2-50, 25);
  }
  if (!button1Active && changed) {
    defaultScreen();
  }
}

void drawButtons() {
  noStroke();
  fill(150);
  rect(width-100, 0, 100, 40);
}

void button1Screen() {
  noStroke();
  fill(100);
  rect(0, 0, width, height);
}

void defaultScreen() {
  noStroke();
  fill(230);
  rect(0, 0, width, height);
}


void mousePressed() {  
  if (mouseX > width-100 && mouseX < width && mouseY < 40 && !button1Active) {
    button1Active = !button1Active;
  } 
  else {
    if (mouseX > width-100 && mouseX < width && mouseY < 40 && button1Active) {
      theTarget.writeToCsv();
      output.flush();
      output.close();
      button1Active = !button1Active;
      changed = !changed;
    }
  }
}

void mouseDragged() {
  for (int i = 0; i < theTarget.Xclicks.size(); i++) {
    if (dist(mouseX, mouseY, theTarget.Xclicks.get(i), theTarget.Yclicks.get(i)) < 20) {
      theTarget.Xclicks.set(i, mouseX);
      theTarget.Yclicks.set(i, mouseY);
    }
  }
}

class Target {
  FloatList Xclicks = new FloatList();
  FloatList Yclicks = new FloatList();

  Target() {
  }

  void display() {
    stroke(#03FF00);
    fill(#03FF00, 50);

    for (int i = 0; i < Yclicks.size(); i++) {
      ellipse(Xclicks.get(i), Yclicks.get(i), 20, 20);
    }

    beginShape();
    vertex(Xclicks.get(0), Yclicks.get(0));
    vertex(Xclicks.get(1), Yclicks.get(1));
    vertex(Xclicks.get(2), Yclicks.get(2));
    vertex(Xclicks.get(3), Yclicks.get(3));
    endShape(CLOSE);
  }

  void writeToCsv() {
    output = createWriter("data/target.csv");
    output.println(Xclicks.get(0));
    output.println(Xclicks.get(1));
    output.println(Xclicks.get(2));
    output.println(Xclicks.get(3));
    output.println(Yclicks.get(0));
    output.println(Yclicks.get(1));
    output.println(Yclicks.get(2));
    output.println(Yclicks.get(3));
    //exit(); // Stops the program
  }
}

void loadData(String url) {
  Table myTable = loadTable(url);
  theTarget.Xclicks.set(0, myTable.getInt(0, 0));
  theTarget.Xclicks.set(1, myTable.getInt(1, 0));
  theTarget.Xclicks.set(2, myTable.getInt(2, 0));
  theTarget.Xclicks.set(3, myTable.getInt(3, 0));
  theTarget.Yclicks.set(0, myTable.getInt(4, 0));
  theTarget.Yclicks.set(1, myTable.getInt(5, 0));
  theTarget.Yclicks.set(2, myTable.getInt(6, 0));
  theTarget.Yclicks.set(3, myTable.getInt(7, 0));
}

void keyPressed() {
  if (key == 'S') {
  }
}

