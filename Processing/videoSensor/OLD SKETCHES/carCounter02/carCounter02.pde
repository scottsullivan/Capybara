import ipcapture.*;
import blobDetection.*;
import processing.video.*;

// Variable for capture device
IPCapture video;
// Previous Frame and motionImage and img
PImage backgroundImage, motionImage, img;
// How different must a pixel be to be a "motion" pixel
float threshold = 40;

//tracked blob array
TrackedBlob[] trackedBlobs = new TrackedBlob[0];
int[] comparer = new int [2];

BlobDetection theBlobDetection;

void setup() {
  size(640, 480, P2D);
  video = new IPCapture(this);
  video.start("http://10.0.1.50/videostream.cgi", "Erik", "Erik");

  // Create an empty image the same size as the video
  backgroundImage = createImage(width, height, RGB);
  motionImage = createImage(width, height, RGB);
  video.start();

  //-----bd
  img = new PImage(160, 120); 
  theBlobDetection = new BlobDetection(img.width, img.height);
  theBlobDetection.setPosDiscrimination(true);
  theBlobDetection.setThreshold(0.4f); // will detect bright areas whose luminosity > 0.2f;

  //comparer
  for (int i = 0; i < comparer.length; i++) {
    comparer[i] = 0;
  }
}

void draw() {
  frame.setTitle(int(frameRate) + " fps / " + frameCount + " frames");
  loadPixels();
  video.loadPixels();
  backgroundImage.loadPixels();

  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {
      int loc = x + y*video.width; // Step 1, what is the 1D pixel location
      color fgColor = video.pixels[loc]; // Step 2, what is the foreground color

      // Step 3, what is the background color
      color bgColor = backgroundImage.pixels[loc];

      // Step 4, compare the foreground and background color
      float r1 = red(fgColor);
      float g1 = green(fgColor);
      float b1 = blue(fgColor);
      float r2 = red(bgColor);
      float g2 = green(bgColor);
      float b2 = blue(bgColor);
      float diff = dist(r1, g1, b1, r2, g2, b2);

      // Step 5, Is the foreground color different from the background color
      if (diff > threshold) {
        // If so, display the foreground color
        pixels[loc] = color(255);
      } else {
        // If not, display green
        pixels[loc] = color(0); // We could choose to replace the background pixels with something other than the color green!
      }
    }
  }
  updatePixels();

  //motionImage.updatePixels();
  PImage motionImage = get();
  img.copy(motionImage, 0, 0, video.width, video.height, 0, 0, img.width, img.height);

  fastblur(img, 2);
  theBlobDetection.computeBlobs(img.pixels);

  int realBlobs = realBlobNumber(theBlobDetection);
  int changeSignal = blobMonitor(realBlobs);
  runRealBlobs(theBlobDetection, changeSignal);

  //println("real blobs " + realBlobs);

  drawBlobsAndEdges(true);
  
   fill(255);
  noStroke();
  rect(0, 0, width, 50);
  fill(255, 0, 0);
  textSize(20);
  textAlign(LEFT);
  text("tracked blobs array length: " + trackedBlobs.length, 10, 20);
  text("current number of tracked blobs: " + realBlobs, 10, 45);
  // Capture video
  if (video.isAvailable()) {
    video.read();
  }
  noFill();
}

void mousePressed() {
  backgroundImage.copy(video, 0, 0, width, height, 0, 0, width, height);
  backgroundImage.updatePixels();
}

