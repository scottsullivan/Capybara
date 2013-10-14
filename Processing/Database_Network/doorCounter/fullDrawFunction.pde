// - - All of the primary video handling.

void fullDraw() {
  frame.setTitle(int(frameRate) + " fps " + millis() + " milliseconds");

  if (video.isAvailable()) {
    video.read();
  }

  loadPixels();
  video.loadPixels();
  backgroundImage.loadPixels();

  int activePixels = 0;
  // - - Begin loop to walk through every pixel
  for (int x = leftLimit; x < video.width; x ++ ) {
    for (int y = topLimit; y < video.height; y ++ ) {
      int loc = x + y*video.width; // Step 1, what is the 1D pixel location
      color fgColor = video.pixels[loc]; // Step 2, what is the foreground color

      // - - Step 3, what is the background color
      color bgColor = backgroundImage.pixels[loc];

      // - - Step 4, compare the foreground and background color
      float h1 = hue(fgColor);
      float s1 = saturation(fgColor);
      float br1 = brightness(fgColor);

      float h2 = hue(bgColor);
      float s2 = saturation(bgColor);
      float br2 = brightness(bgColor);

      float r1 = red(fgColor);
      float g1 = green(fgColor);
      float b1 = blue(fgColor);
      float r2 = red(bgColor);
      float g2 = green(bgColor);
      float b2 = blue(bgColor);
      float diff = dist(r1, g1, b1, r2, g2, b2);

      // - - Step 5, Is the foreground color different from the background color display white

      if (diff > RGBthreshold && abs(h1-h2) > hueThresh && abs(s1-s2) > saturationThresh && abs(br1-br2) > brightnessThresh) {
        pixels[loc] = color(255);
        activePixels++;
      } 
      else {
        // If not, display black
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
  evaluateOldBlobs();

  evaluateInactivity(activePixels);

  drawBlobsAndEdges(true);

  // - - Drawing the green box and blue boxes
  theTarget.lightDisplay();
  theTopLeft.lightDisplay();

  // - - Drawing the numbers for the testing mode
  fill(255);
  textAlign(LEFT);
  text("ENTERED: " + cameIn, 20, 30);
  text("EXITED: " + wentOut, 20, 45);
  text("CURRENT OCCUPANCY: " + (cameIn - wentOut), 20, 60);
  text("LENGTH OF ARRAY LIST: " + objectList.size(), 20, 75);
  text("ACTIVE PIXELS: " + activePixels, 20, 90);

  drawSetupButton();
  resetButton();
  saveSliders();

  // - - Notifies of new background
  if (notifier) {
    noStroke();
    fill(255, 0, 0);
    rect(0, height-20, 200, 20);
    textAlign(CENTER);
    fill(255);
    text("NEW BACKGROUND", 100, height-5);
  }
}

