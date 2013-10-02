// - - - - - - - - - - - - - - - - - - - - - - - 
// PEOPLE COUNTER v03 06-10-13
// WEBCAM VERSION
// BY SCOTT SULLIVAN / GOINVO.COM
// - - - - - - - - - - - - - - - - - - - - - - -

// FEATURES TO ADD

// - - FOR COUNTING
// logic to remove 'timed out' objects from Object Array
// logic to evaluate in and out
// add 'in zone' to identifiy the "hot area" where arrays start or end
// put Object Array in to a class?
// make easier names for the float positions

// - - CAMERA FRAME
// figure out an input for massive fluctuations in the brightness
// and figure out how to adjust the brightness so it's always the same "level"

// - - BACKGROUND DELETION
// figure out how to automatically delete the background when there's no activity
// maybe a second boolen to evaluate the number of "minor" blobs.. 
// zero people blobs and zero minor blobs that arent big enough to be people
// then update the background image

// - - - - - - - - - - - - - - - - - - - - - - - 
// LIBRARIES
// - - - - - - - - - - - - - - - - - - - - - - - 
import blobDetection.*;
import processing.video.*;


// - - - - - - - - - - - - - - - - - - - - - - - 
// GLOBAL VARIABLES
// - - - - - - - - - - - - - - - - - - - - - - - 
Capture video; // Variable for capture device
PImage backgroundImage, motionImage, img;// Previous Frame and motionImage and img
float threshold = 40; // How different must a pixel be to be a "motion" pixel
BlobDetection theBlobDetection; //instance of blob detection
TrackedBlob[] objectArray = new TrackedBlob[1]; //tracked blob array
int thresh = 20;
int blobMinSize = 100;


// - - - - - - - - - - - - - - - - - - - - - - - 
// SETUP
// - - - - - - - - - - - - - - - - - - - - - - - 
void setup() {
  size(640, 480);
  video = new Capture(this, width, height, 30);
  video.start();

  // - - Create an empty image the same size as the video
  backgroundImage = createImage(width, height, RGB);
  motionImage = createImage(width, height, RGB);

  // - - for the blob detection library
  img = new PImage(160, 120); 
  theBlobDetection = new BlobDetection(img.width, img.height);
  theBlobDetection.setPosDiscrimination(true);
  theBlobDetection.setThreshold(0.4f); // will detect bright areas whose luminosity > 0.2f;

  objectArray[0] = new TrackedBlob(0, 0, 0, "default");

  loadPixels();
}


// - - - - - - - - - - - - - - - - - - - - - - - 
// DRAW LOOP
// - - - - - - - - - - - - - - - - - - - - - - - 
void draw() {
  frame.setTitle(int(frameRate) + " fps");

  if (video.available()) {
    video.read();
  }

  loadPixels();
  video.loadPixels();
  backgroundImage.loadPixels();

  // - - Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {
      int loc = x + y*video.width; // Step 1, what is the 1D pixel location
      color fgColor = video.pixels[loc]; // Step 2, what is the foreground color

      // - - Step 3, what is the background color
      color bgColor = backgroundImage.pixels[loc];

      // - - Step 4, compare the foreground and background color
      float r1 = red(fgColor);
      float g1 = green(fgColor);
      float b1 = blue(fgColor);
      float r2 = red(bgColor);
      float g2 = green(bgColor);
      float b2 = blue(bgColor);
      float diff = dist(r1, g1, b1, r2, g2, b2);

      // - - Step 5, Is the foreground color different from the background color
      if (diff > threshold) {
        // If so, display the foreground color
        pixels[loc] = color(255);
      } 
      else {
        // If not, display green
        pixels[loc] = color(0); // We could choose to replace the background pixels with something other than the color green!
      }
    }
  }
  updatePixels();

  PImage motionImage = get(); //loads displayed pixels in to motionImage PImage
  img.copy(motionImage, 0, 0, video.width, video.height, 0, 0, img.width, img.height);

  fastblur(img, 2);
  theBlobDetection.computeBlobs(img.pixels);

  runRealBlobs(theBlobDetection);

  drawBlobsAndEdges(true);
}

void mousePressed() {
  backgroundImage.copy(video, 0, 0, width, height, 0, 0, width, height);
  backgroundImage.updatePixels();
}

