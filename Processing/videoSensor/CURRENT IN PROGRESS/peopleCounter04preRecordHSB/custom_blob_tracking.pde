
// - - tracked blob object
class TrackedBlob {
  float x;
  float y;
  int t;
  float[] xpos = new float [1];
  float[] ypos = new float [1];
  int[] mSecond = new int [1];
  String[] time = new String [1];

  TrackedBlob(float x_, float y_, int s_, String t_) {
    x = x_;
    y = y_;
    xpos[0] = x_;
    ypos[0] = y_;
    mSecond[0] = s_;
    time[0] = t_;
  }

  void updatePosition(float inX, float inY, int inS, String inT) {
    xpos = (float[]) append(xpos, inX);
    ypos = (float[]) append(ypos, inY);
    mSecond = (int[]) append(mSecond, inS);
    time = (String[]) append(time, inT);

    fill(255, 0, 0);
    noStroke();
    ellipse(xpos[xpos.length - 1], ypos[ypos.length - 1], thresh * 2, thresh * 2);
  }
}

// - - new blob or old blob?
void runRealBlobs(BlobDetection bd) { //bd is the local instance of the blob detection
  boolean isItOld = false;
  Blob b; //declaring a blob (empty here)
  for (int n = 0; n < bd.getBlobNb(); n++) {//cycling through the total number of detected blobs
    b = bd.getBlob(n); //b is the current blob being evaluated in the for loop
    if (b != null && realBlob(b)) { //if it exists and if it's validated as a 'real blob'
      isItOld = false;
      for (int i = objectList.size()-1; i >= 0; i--) { //loop through the object list backwards
        //if the blob's top left corner is close (withing the thresh) the position of that is added to the arrays in the blob class.
        TrackedBlob blob = objectList.get(i); // blob is now the object that we're looking at in the loop
        if (dist(b.xMin*width + (b.w*width/2), b.yMin*height, blob.xpos[blob.xpos.length - 1], blob.ypos[blob.ypos.length - 1]) < thresh) {
          blob.updatePosition(b.xMin*width + (b.w*width/2), b.yMin*height, millis(), year() + ":" + month() + ":" + day() + ":" + hour() + ":" + minute() + ":" + second());
          isItOld = true;
        }
      }
      if (!isItOld && realBlob(b)) { // if it's not an old blob and it's a verified blob.
        objectList.add(new TrackedBlob(b.xMin*width + (b.w*width/2), b.yMin*height, millis(), year() + ":" + month() + ":" + day() + ":" + hour() + ":" + minute() + ":" + second()));
      }
    }
  }
}

void evaluateOldBlobs() { //bd is the local instance of the blob detection
  for (int i = objectList.size()-1; i >= 0; i--) { //loop through the object list backwards
    TrackedBlob blob = objectList.get(i); // blob is now the object that we're looking at in the loop
    if (blob.mSecond[blob.mSecond.length-1] < millis() - 1000) {
      if (withinTarget(blob.xpos[0], blob.ypos[0]) && !withinTarget(blob.xpos[blob.xpos.length-1], blob.ypos[blob.ypos.length-1])) {
        cameIn++;
        objectList.remove(i);
      }
      if (!withinTarget(blob.xpos[0], blob.ypos[0]) && withinTarget(blob.xpos[blob.xpos.length-1], blob.ypos[blob.ypos.length-1])) {
        wentOut++;
        objectList.remove(i);
      }
      if (!withinTarget(blob.xpos[0], blob.ypos[0]) && !withinTarget(blob.xpos[blob.xpos.length-1], blob.ypos[blob.ypos.length-1])) {
        objectList.remove(i);
      }
      if (withinTarget(blob.xpos[0], blob.ypos[0]) && withinTarget(blob.xpos[blob.xpos.length-1], blob.ypos[blob.ypos.length-1])) {
        objectList.remove(i);
      }
    }
  }
}

// - - person-blob verification boolean
boolean realBlob(Blob realB) {
  // realBlob is true if the width and the height of the blob are both above the minimum blob size
  return (realB.w*width > blobMinWidth) && (realB.w*height > blobMinHeight)/* && (realB.w*width < blobMinWidth*5) && (realB.w*height < blobMinHeight*5)*/ && realB.yMin*height > theTarget.Yclicks.min();
}

boolean withinTarget(float evalX, float evalY) {
  return evalX <= theTarget.Xclicks.max() && evalX >= theTarget.Xclicks.min() && evalY <= theTarget.Yclicks.max() && evalY >= theTarget.Yclicks.min();
}

