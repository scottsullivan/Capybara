void drawSetupButton() {
  noStroke();
  fill(150);
  rect(width-100, 0, 100, 40);
  fill(255);
  textAlign(CENTER);
  text("SETUP", width-50, 25);

  fill(150);
  rect(width-210, 0, 100, 40);
  fill(255);
  textAlign(CENTER);
  text("NEW BKGND", width-160, 25);
}

void drawTargetButtons() {
  noStroke();
  fill(150);
  rect(width-100, 0, 100, 40);
  fill(255);
  textAlign(CENTER);
  text("SAVE", width-50, 25);

  fill(150);
  rect(width-100, 45, 100, 40);
  fill(255);
  textAlign(CENTER);
  text("DON'T SAVE", width-50, 70);

  fill(#FF0000);
  rect(width-125, height-40, 125, 40);
  fill(255);
  textAlign(CENTER);
  text("RESTORE DEFAULT", width-62, height-15);
}

void button1Screen() {
  frame.setTitle(int(frameRate) + " fps " + millis() + " milliseconds");

  if (video.available()) {
    video.read();
  }

  loadPixels();
  video.loadPixels();

  // - - Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {
      int loc = x + y*video.width; // Step 1, what is the 1D pixel location
      color fgColor = video.pixels[loc]; // Step 2, what is the foreground color
      pixels[loc] = fgColor;
    }
  }

  updatePixels();
  theTarget.display();
  theTopLeft.display();
  fill(150, 200);
  noStroke();

  drawTargetButtons();
}

class Target {
  FloatList Xclicks = new FloatList();
  FloatList Yclicks = new FloatList();

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

  void lightDisplay() {
    stroke(#03FF00, 100);
    fill(#03FF00, 50);

    beginShape();
    vertex(Xclicks.get(0), Yclicks.get(0));
    vertex(Xclicks.get(1), Yclicks.get(1));
    vertex(Xclicks.get(2), Yclicks.get(2));
    vertex(Xclicks.get(3), Yclicks.get(3));
    endShape(CLOSE);
  }

  void writeToCsv() {
    PrintWriter output;
    output = createWriter("data/target.csv");
    output.println(Xclicks.get(0));
    output.println(Xclicks.get(1));
    output.println(Xclicks.get(2));
    output.println(Xclicks.get(3));
    output.println(Yclicks.get(0));
    output.println(Yclicks.get(1));
    output.println(Yclicks.get(2));
    output.println(Yclicks.get(3));
    output.flush();
    output.close();
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

// - - - - - - - - - - - - -

class TopLeft {
  void display() {
    noStroke();
    fill(#747474, 100);
    rect(0, 0, leftLimit, height);
    rect(0, 0, width, topLimit);
    stroke(#747474);
    line(leftLimit, 0, leftLimit, height);
    line(0, topLimit, width, topLimit);
  }

  void lightDisplay() {
    noStroke();
    fill(#000000);
    rect(0, 0, leftLimit, height);
    rect(0, 0, width, topLimit);
  }

  void writeToCsv() {
    PrintWriter output;
    output = createWriter("data/topleft.csv");
    output.println(leftLimit);
    output.println(topLimit);
    output.flush();
    output.close();
  }
}

void loadTLData(String url) {
  Table myTable = loadTable(url);
  leftLimit = myTable.getInt(0, 0);
  topLimit = myTable.getInt(1, 0);
}

void loadSliderData(String url) {
  Table myTable = loadTable(url);
  RGBthreshold = myTable.getInt(0, 0);
  hueThresh = myTable.getInt(1, 0);
  saturationThresh = myTable.getInt(2, 0);
  brightnessThresh = myTable.getInt(3, 0);
  blobMinWidth = myTable.getInt(4, 0);
  blobMinHeight = myTable.getInt(5, 0);
  thresh = myTable.getInt(6, 0);
}

void writeSliderValues() {
  PrintWriter output;
  output = createWriter("data/sliders.csv");
  output.println(RGBthreshold);
  output.println(hueThresh);
  output.println(saturationThresh);
  output.println(brightnessThresh);
  output.println(blobMinWidth);
  output.println(blobMinHeight);
  output.println(thresh);
  output.flush();
  output.close();
}

