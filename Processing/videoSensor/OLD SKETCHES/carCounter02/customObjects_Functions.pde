
//-------------blob holding array
//Class BlobList {
//
//  BlobDetection theBlobDetection;
//
//  TrackedBlob[] trackedBlobs = new TrackedBlob[0];
//
//  void updateBlobs() {
//    // get the current valid blobs from the BlobDetection
//    // for each current blob, check if that blob matches one of the TrackedBlobs.
//    // update the trackedBlobs positions annd stuff.
//  }
//}


//---------------verified blob custom tracking
class TrackedBlob {
  int x;
  int y;
  int t;
  float[] xpos = new float [1];
  float[] ypos = new float [1];
  int[] time = new int [1];

  TrackedBlob(int x_, int y_, int t_) {
    x = x_;
    y = y_;
    t = t_;
    xpos[1] = 0;
    ypos[1] = 0;
    time[1] = 0;
  }

  void updatePosition(float inX, float inY, int inT) {
    xpos.append(inX);
    ypos.append(inY);
    time.append(inT);
  }
}


//------------------blob verification boolean
boolean realBlob(Blob realB) {
  return (realB.w*width > 65) && (realB.w*height > 65);
}

//-----------------------real blob integer
int realBlobNumber(BlobDetection bd) { //bd is the local instance of the blob detection
  Blob b; //declaring a blob (empty here)
  int realCount = 0; //declaring counter
  for (int n=0 ; n<bd.getBlobNb() ; n++) //cycling through the total number of detected blobs
  {
    b=bd.getBlob(n); //b is the current blob being evaluated in the for loop
    if (b!=null && realBlob(b)) //if it exists and if it's validated as a 'real blob'
    {     
      realCount++; //increase the count of the total number of blobs
    }
  }
  return realCount; //spit out that number
}

int blobMonitor(int blobCount) {
  int signalNumber = 0;
  comparer[1] = comparer[0];
  comparer[0] = blobCount;

  if (comparer[0] > comparer[1]) {
    println("INCRESASE!  total: " + blobCount);
    signalNumber = 3;
  }
  if (comparer[0] == comparer[1]) {
    signalNumber = 2;
  }
  if (comparer[0] < comparer[1]) {
    println("DECREASE! total: " + blobCount);
    signalNumber = 1;
  }

  return signalNumber;
}

//----------------------------run real blobs through for loop
void runRealBlobs(BlobDetection bd, int signal) { //bd is the local instance of the blob detection
  Blob b; //declaring a blob (empty here)
  for (int n=0 ; n<bd.getBlobNb() ; n++) //cycling through the total number of detected blobs
  {
    b=bd.getBlob(n); //b is the current blob being evaluated in the for loop
    if (b!=null && realBlob(b) && signal == 3) //if it exists and if it's validated as a 'real blob'
    {
      TrackedBlob bloob = new TrackedBlob(b.xMin*width, b.yMin*height, b.w*width, b.w*height);
      trackedBlobs = (TrackedBlob[]) append(trackedBlobs, bloob);
      println("tracked blobs array length = " + trackedBlobs.length);
    }
  }
}

//------------------------------reset the background image
//if (realBlobs < 1) {
//  backgroundImage.copy(video, 0, 0, width, height, 0, 0, width, height);
//  backgroundImage.updatePixels();
//}

