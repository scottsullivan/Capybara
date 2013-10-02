class TrackedBlob {
  int x;
  int y;
  int t;
  int[] xpos = new int [1];
  int[] ypos = new int [1];
  int[] time = new int [1];

  TrackedBlob(int x_, int y_) {
    x = x_;
    y = y_;
    xpos[0] = x_;
    ypos[0] = y_;
    time[0] = 0;
  }

  void updatePosition(int inX, int inY) {
    xpos = (int[]) append(xpos, inX);
    ypos = (int[]) append(ypos, inY);
    stroke(0, 50);
    println(xpos.length);
    line(xpos[xpos.length - 2], ypos[ypos.length - 2], xpos[xpos.length - 1], ypos[ypos.length - 1]);
    fill(0, 20);
    noStroke();
    ellipse(xpos[xpos.length - 1], ypos[ypos.length - 1], thresh * 2, thresh * 2);
  }
}
