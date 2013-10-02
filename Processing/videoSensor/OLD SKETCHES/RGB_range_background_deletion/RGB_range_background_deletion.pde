/*
background recongnition based on the difference between the min and max values of
 each pixel's R, G, and B values together..
 each Pixel's R, G, and B balues get put in to their own int list and the min and max values of that list
 are used in a dist function (below)
 float test = dist(0, min, 0, max);
 if the dist is above a certain threshold, it's a new color.. hopefully this will stabalize light fluctuations.
 */

// Click the mouse to memorize a current background image
import processing.video.*;

// Variable for capture device
Capture video;

// Saved background
PImage backgroundImage;

// How different must a pixel be to be a foreground pixel
float threshold = 5;

FloatList backgroundList = new FloatList();
FloatList currentList = new FloatList();

void setup() {
  size(320, 240);
  video = new Capture(this, width, height, 30);
  // Create an empty image the same size as the video
  backgroundImage = createImage(video.width, video.height, RGB);
  video.start();
}

void draw() {
  // Capture video
  if (video.available()) {
    video.read();
  }

  // We are looking at the video's pixels, the memorized backgroundImage's pixels, as well as accessing the display pixels. 
  // So we must loadPixels() for all!
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
      currentList.set(0, red(fgColor));
      currentList.set(1, green(fgColor));
      currentList.set(2, blue(fgColor));
      
      backgroundList.set(0, red(bgColor));
      backgroundList.set(1, green(bgColor));
      backgroundList.set(2, blue(bgColor));
      
      float currentDiff = dist(0, currentList.max(), 0, currentList.min());
      float backgroundDiff = dist(0, backgroundList.max(), 0, backgroundList.min());

      float diff = dist(0, currentDiff, 0, backgroundDiff);

      // Step 5, Is the foreground color different from the background color
      if (diff > threshold) {
        // If so, display the foreground color
        pixels[loc] = fgColor;
      } 
      else {
        // If not, display green
        pixels[loc] = color(0, 255, 0); // We could choose to replace the background pixels with something other than the color green!
      }
    }
  }
  updatePixels();
}

void mousePressed() {
  // Copying the current frame of video into the backgroundImage object
  // Note copy takes 5 arguments:
  // The source image
  // x,y,width, and height of region to be copied from the source
  // x,y,width, and height of copy destination
  backgroundImage.copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height);
  backgroundImage.updatePixels();
}

