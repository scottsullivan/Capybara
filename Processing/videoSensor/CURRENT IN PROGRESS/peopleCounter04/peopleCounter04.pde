// - - - - - - - - - - - - - - - - - - - - - - - 
// PEOPLE COUNTER v03 06-10-13
// USING AN ARRAY LIST INSTEAD OF AN ARRAY OF OBJECTS
// ADDING INTERFACE
// BY SCOTT SULLIVAN / GOINVO.COM
// - - - - - - - - - - - - - - - - - - - - - - -

// FEATURES TO ADD

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
import ipcapture.*;
import blobDetection.*;
import processing.video.*;

// - - - - - - - - - - - - - - - - - - - - - - - 
// GLOBAL VARIABLES
// - - - - - - - - - - - - - - - - - - - - - - - 
IPCapture video; // Variable for capture device
PImage backgroundImage, motionImage, img;// Previous Frame and motionImage and img
float threshold = 40; // How different must a pixel be to be a "motion" pixel
BlobDetection theBlobDetection; //instance of blob detection
ArrayList<TrackedBlob> objectList;
int thresh = 60; // movement distance of tracked object threshold
int blobMinWidth = 10;
int blobMinHeight = 100;
int cameIn = 0;
int wentOut = 0;

// - - interface specific
boolean button1Active = false;
Target theTarget = new Target();
//PrintWriter output;


// - - - - - - - - - - - - - - - - - - - - - - - 
// SETUP
// - - - - - - - - - - - - - - - - - - - - - - - 
void setup() {
  size(640, 480, P2D);
  video = new IPCapture(this);
  video.start("http://184.57.19.12:8090/videostream.cgi", "Erik", "Erik");

  objectList = new ArrayList <TrackedBlob>(); // Create an empty ArrayList
  // - - Create an empty image the same size as the video
  backgroundImage = createImage(width, height, RGB);
  motionImage = createImage(width, height, RGB);

  // - - for the blob detection library
  img = new PImage(160, 120); 
  theBlobDetection = new BlobDetection(img.width, img.height);
  theBlobDetection.setPosDiscrimination(true);
  theBlobDetection.setThreshold(0.4f); // will detect bright areas whose luminosity > 0.4f;

  // - - target interface
  loadData("target.csv");
}


// - - - - - - - - - - - - - - - - - - - - - - - 
// DRAW LOOP
// - - - - - - - - - - - - - - - - - - - - - - - 
void draw() {
  if (!button1Active) {
    fullDraw();
    drawSetupButton();
  }
  if (button1Active) {
    button1Screen();
  }
}

void mousePressed() {
  backgroundImage.copy(video, 0, 0, width, height, 0, 0, width, height);
  backgroundImage.updatePixels();

  // - - target interface
  if (inButton(width-100, 0, 100, 40) && !button1Active) {
    button1Active = !button1Active;
  } 
  else {
    if (inButton(width-100, 0, 100, 40) && button1Active) {
      theTarget.writeToCsv();
      button1Active = !button1Active;
    }
  }

  if (inButton(width-100, 45, 100, 40) && button1Active) {
    loadData("target.csv");
    button1Active = !button1Active;
  }

  if (inButton(width-125, height-40, 125, 40) && button1Active) {
    loadData("default.csv");
  }
}

void mouseDragged() {
  for (int i = 0; i < theTarget.Xclicks.size(); i++) {
    if (dist(mouseX, mouseY, theTarget.Xclicks.get(i), theTarget.Yclicks.get(i)) < 30 && button1Active) {
      theTarget.Xclicks.set(i, mouseX);
      theTarget.Yclicks.set(i, mouseY);
    }
  }
}

boolean inButton(int buttonX, int buttonY, int buttonW, int buttonH) {
  return mouseX > buttonX && mouseX < buttonX + buttonW && mouseY > buttonY && mouseY < buttonY + buttonH;
}

