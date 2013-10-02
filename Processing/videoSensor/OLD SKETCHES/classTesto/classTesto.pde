TrackedBlob notablob;

void setup() {
size(200, 200);
notablob = new TrackedBlob(0, 0);
}

void draw() {

}

void mousePressed() {
  notablob.updatePosition(mouseX, mouseY);
}

void keyPressed() {
println("X: " + notablob.ypos[notablob.ypos.length - 1]);
println("Y: " + notablob.xpos[notablob.xpos.length - 1]);
println(notablob.xpos.length);

}
