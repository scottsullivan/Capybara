class Trigger {
  String timeString;
  Date time; 
  float timeFraction;

  String router;
  int location;

  //  PVector lonLat = new PVector();
  //  float alt;
  //
  PVector pos = new PVector();
  PVector tpos = new PVector();

  void init() {
    //4/14/2013 11:49:10
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MM/dd/yyyy kk:mm:ss");
    try {
      time = sdf.parse(timeString);
    } 
    catch(Exception e) {
      println("error parsing date" + e);
    }
  }

  void update() {
    pos.lerp(tpos, 0.1);
  }

  void render() {
    noStroke();
    fill(255, 50);
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    ellipse(0, 0, 5, 5);
    popMatrix();
  }
}

