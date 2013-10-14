// A Bubble class

class Bubble {
  float x,y;
  float diameter;
  String name;
  
  boolean over = false;
  
  // Create  the Bubble
  Bubble(float x_, float diameter_) {
    x = x_;
  }
  
  // Display the Bubble
  void display() {
    stroke(0);
    strokeWeight(2);
    noFill();
    ellipse(x,height/2,diameter,diameter);
  }
}
