// - - - sketch to explore array lists

// This is a code fragment that shows how to use an ArrayList.
// It won't compile because it's missing the Ball class.

// Declaring the ArrayList, note the use of the syntax "" to indicate
// our intention to fill this ArrayList with Ball objects
ArrayList<Ball> balls;
float gravity = 0.1;

void setup() {
  size(600, 300);
  balls = new ArrayList<Ball>();  // Create an empty ArrayList
  //balls.add(new Ball(width/2, 0, 20));  // Start by adding one element
}

void draw() {
  background(255);

  // With an array, we say balls.length. With an ArrayList,
  // we say balls.size(). The length of an ArrayList is dynamic.
  // Notice how we are looping through the ArrayList backwards.
  // This is because we are deleting elements from the list.
  //for (int i = 0; i < balls.size()-1; i++) { // attempt at forward looping through the list (didn't work)
  for (int i = balls.size()-1; i >= 0; i--) {
    Ball ball = balls.get(i);
    ball.gravity();
    ball.move();
    ball.display();
    if (ball.finished()) {
      // Items can be deleted with remove().
      balls.remove(i);
      println("Removed" + " list length " + balls.size());
    }
  }
}

void mousePressed() {
  // A new ball object is added to the ArrayList, by default to the end.
  balls.add(new Ball(mouseX, mouseY, 20));
}

