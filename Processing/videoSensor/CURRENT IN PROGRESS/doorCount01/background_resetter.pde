void evaluateInactivity(int activePixels_) {
// if active pixels is above threshold for more than 500MS and the length of the array list is 0 for 500ms, then reset the background

  // pixel activity (if high)
  if (activePixels_ < activePixelThresh) {
    wasCalm = true;
    pixelsActive = false;
    overPixelTime = millis() + 100000;
  }

  if (activePixels_ > activePixelThresh && wasCalm) {
    wasCalm = false;
    overPixelTime = millis();
  }

  if (overPixelTime < millis() - 400) {
    pixelsActive = true;
  }

  // blob activity (if none)
  if (objectList.size() > 0) {
    wasActive = true;
    blobInactive = false;
    blobInactiveTime = millis() + 100000;
  }

  if (objectList.size() == 0 && wasActive) {
    wasActive = false;
    blobInactiveTime = millis();
  }

  if (blobInactiveTime < millis() - 400) {
    blobInactive = true;
  }

  //if pixels are active and blobs are inactive, reset background
  if (pixelsActive && blobInactive) {
    backgroundImage.copy(video, 0, 0, width, height, 0, 0, width, height);
    backgroundImage.updatePixels();

    notifier = true;
    notifierTimer = millis();
  }

  if (notifierTimer < millis() - 500 && notifierTimer > millis() - 1000) {
    notifier = false;
  }
}
