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
// maybe a second boolen to evaluate the number of "minor" blobs.. 
// zero people blobs and zero minor blobs that arent big enough to be people
// then update the background image

// - - - - - - - - - - - - - - - - - - - - - - - 
// LIBRARIES
// - - - - - - - - - - - - - - - - - - - - - - - 
//import ipcapture.*;
import blobDetection.*;
import processing.video.*;
import controlP5.*;

// - - - - - - - - - - - - - - - - - - - - - - - 
// GLOBAL VARIABLES
// - - - - - - - - - - - - - - - - - - - - - - - 
//IPCapture video; // Variable for capture device

//for saving stuff 
SensorDataStore store;
SensorDataWebAdapter web;
CsvDataWriter csv;

Movie video;
ControlP5 cp5;

DoorSensor doorSensor = new DoorSensor(12); // make a new door sensor the it's index of 12 (look at the xbee sensors to make sure they don't conflict)

PImage backgroundImage, motionImage, img;// Previous Frame and motionImage and img
BlobDetection theBlobDetection; //instance of blob detection
ArrayList<TrackedBlob> objectList;
int thresh = 35; // movement distance of tracked object threshold
int blobMinWidth = 20;
int blobMinHeight = 50;
int cameIn = 0;
int wentOut = 0;
boolean showTestControls = true;

int leftLimit; //ignore all activity to the left of this point
int topLimit;

float RGBthreshold = 20;
float hueThresh = 15;
float saturationThresh = 15;
float brightnessThresh = 20;
float activePixelThresh = 1500;

// - - interface specific
boolean button1Active = false;
Target theTarget = new Target();
TopLeft theTopLeft = new TopLeft();

//PrintWriter output;
boolean wasCalm = false;
boolean pixelsActive = false;
float overPixelTime = 0;

boolean wasActive = false;
boolean blobInactive = false;
float blobInactiveTime = 0;

boolean notifier = false;
float notifierTimer = 0;


// - - - - - - - - - - - - - - - - - - - - - - - 
// SETUP
// - - - - - - - - - - - - - - - - - - - - - - - 
void setup() {
  size(640, 480);
  //frameRate(19);
  video = new Movie(this, "tt8.mov");
  video.loop();
  //  video = new IPCapture(this);
  //  video.start("http://10.0.1.52/videostream.cgi", "Erik", "Erik");

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
  loadTLData("topleft.csv");
  loadSliderData("sliders.csv");

  // - - CP5 for testing
  cp5 = new ControlP5(this);
  testingControls();
  
  store = new SensorDataStore();
  web = new SensorDataWebAdapter("http://mysterious-plains-9032.herokuapp.com", "522e2c99708615956a000002", "p3fxbdUx6EmXKue9dgf8");
  csv = new CsvDataWriter("cameralog/","log.csv",true);
  store.addAdapter(web);
  store.addAdapter(csv);
  store.monitorSensors(doorSensor);
}


// - - - - - - - - - - - - - - - - - - - - - - - 
// DRAW LOOP
// - - - - - - - - - - - - - - - - - - - - - - - 
void draw() {
  if (!button1Active) {
    fullDraw();
    drawSetupButton();
    resetButton();
    saveSliders();
  }
  if (button1Active) {
    button1Screen();
  }
}

// - - - - - - - - - - - - - - - - - - - - - - - 
// UNIVERSAL INTERACTIVE EVENTS
// - - - - - - - - - - - - - - - - - - - - - - - 

boolean inButton(int buttonX, int buttonY, int buttonW, int buttonH) {
  return mouseX > buttonX && mouseX < buttonX + buttonW && mouseY > buttonY && mouseY < buttonY + buttonH;
}

void mousePressed() {
  // - - target interface

  //setup and save button
  if (inButton(width-100, 0, 100, 40) && !button1Active) {
    button1Active = !button1Active;
  } 
  else {
    if (inButton(width-100, 0, 100, 40) && button1Active) {
      theTarget.writeToCsv();
      theTopLeft.writeToCsv();
      button1Active = !button1Active;
    }
  }

  //don't save target button
  if (inButton(width-100, 45, 100, 40) && button1Active) {
    loadData("target.csv");
    loadTLData("topleft.csv");
    button1Active = !button1Active;
  }

  //restore default target button
  if (inButton(width-125, height-40, 125, 40) && button1Active) {
    loadData("default.csv");
    loadTLData("topleftDefault.csv");
  }

  //reset counts button
  if (inButton(width-150, height-40, 150, 40) && showTestControls) {
    cameIn = 0;
    wentOut = 0;
    objectList.clear();
  }

  //manual set background button
  if (inButton(width-210, 0, 100, 40) && !button1Active) {
    backgroundImage.copy(video, 0, 0, width, height, 0, 0, width, height);
    backgroundImage.updatePixels();
  }

  //save slider data
  if (inButton(5, height-150, 150, 40) && !button1Active) {
    writeSliderValues();
  }
}

void mouseDragged() {
  for (int i = 0; i < theTarget.Xclicks.size(); i++) {
    if (dist(mouseX, mouseY, theTarget.Xclicks.get(i), theTarget.Yclicks.get(i)) < 30 && button1Active) {
      theTarget.Xclicks.set(i, mouseX);
      theTarget.Yclicks.set(i, mouseY);
    }
  }

  if (dist(mouseX, mouseY, leftLimit, mouseY) < 30 && button1Active) {
    leftLimit = mouseX;
    fill(0);
    textAlign(CENTER);
    text(leftLimit, mouseX - 18, mouseY);
  }

  if (dist(mouseX, mouseY, mouseX, topLimit) < 30 && button1Active) {
    topLimit = mouseY;
    fill(0);
    textAlign(CENTER);
    text(topLimit, mouseX, mouseY - 10);
  }
}

void keyPressed() {
  if (key == 't') { 
    showTestControls = !showTestControls;
    testingControls();
  }
}


