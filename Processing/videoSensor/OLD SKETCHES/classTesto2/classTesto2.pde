TrackedBlob notablob;
TrackedBlob[] objectArray = new TrackedBlob[1];
int thresh = 25;

void setup() {
  size(800, 500);
  background(255);
  notablob = new TrackedBlob(0, 0);
}

void draw() {
  frame.setTitle(int(frameRate) + " fps");
}

void mousePressed() {
  //objectArray[objectArray.length - 1].updatePosition(mouseX, mouseY);

  for (int i = 1; i < objectArray.length; i++) {
    if (dist(mouseX, mouseY, objectArray[i].xpos[objectArray[i].xpos.length - 1], objectArray[i].ypos[objectArray[i].xpos.length - 1]) < thresh) {
      objectArray[i].updatePosition(mouseX, mouseY);
    } 
  }
}

void keyPressed() {
  if (key == 'n') {
    TrackedBlob b = new TrackedBlob(mouseX, mouseY);
    objectArray = (TrackedBlob[]) append(objectArray, b);
    println(objectArray.length);
  }

  if (key == 'p') {
    println("X: " + notablob.ypos[notablob.ypos.length - 1]);
    println("Y: " + notablob.xpos[notablob.xpos.length - 1]);
    println(notablob.xpos.length);
  }

  if (key == 'r') {
    println(objectArray[objectArray.length - 1].ypos);
  }
}

