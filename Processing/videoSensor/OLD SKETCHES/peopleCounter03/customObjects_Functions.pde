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

    //println(xpos.length);
    println(mSecond[mSecond.length -1]);
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
      for (int i = 1; i < objectArray.length; i++) { //loop through the object array
        if (dist(b.xMin*width, b.yMin*height, objectArray[i].xpos[objectArray[i].xpos.length - 1], objectArray[i].ypos[objectArray[i].xpos.length - 1]) < thresh) {
          objectArray[i].updatePosition(b.xMin*width, b.yMin*height, millis(), year() + ":" + month() + ":" + day() + ":" + hour() + ":" + minute() + ":" + second());
          isItOld = true;
        }
      }
      if (!isItOld && realBlob(b)) {
        TrackedBlob newBlob = new TrackedBlob(b.xMin*width, b.yMin*height, millis(), year() + ":" + month() + ":" + day() + ":" + hour() + ":" + minute() + ":" + second());
        objectArray = (TrackedBlob[]) append(objectArray, newBlob);
        println("new object detected, number: " + objectArray.length);
      }
    }
  }
}

//the problem is that because the boolean is true for one, it won't recognize new blobs


// - - person-blob verification boolean
boolean realBlob(Blob realB) {
  return (realB.w*width > blobMinSize) && (realB.w*height > blobMinSize);
}

