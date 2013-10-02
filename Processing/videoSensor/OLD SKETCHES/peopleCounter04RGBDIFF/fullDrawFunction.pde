void fullDraw() {
  frame.setTitle(int(frameRate) + " fps " + millis() + " milliseconds");

  if (video.isAvailable()) {
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
  evaluateOldBlobs();

  drawBlobsAndEdges(true);
  fill(255);
  textAlign(LEFT);
  text("ENTERED: " + cameIn, 20, 30);
  text("EXITED: " + wentOut, 20, 45);
  text("CURRENT CAPACITY: " + (cameIn - wentOut), 20, 60);
  text("LENGTH OF ARRAY LIST: " + objectList.size(), 20, 75);
  
  theTarget.lightDisplay();
}

