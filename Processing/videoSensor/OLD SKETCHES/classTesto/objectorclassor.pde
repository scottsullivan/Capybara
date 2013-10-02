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
    xpos[0] = 0;
    ypos[0] = 0;
    time[0] = 0;
  }

  void updatePosition(int inX, int inY) {
    xpos = (int[]) append(xpos, inX);
    ypos = (int[]) append(ypos, inY);
  }
}
