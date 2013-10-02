void testingControls() {
  cp5.addSlider("blobMinWidth")
    .setValue(blobMinWidth)
      .setSize(150, 20)
        .setPosition(5, 70 + 40)
          .setRange(0, 200)
            .setLabel("MINIMUM BLOB WIDTH")
              .getCaptionLabel()
                .align(ControlP5.RIGHT, ControlP5.LEFT_OUTSIDE)
                  .setPaddingX(0);
  cp5.addSlider("blobMinHeight")
    .setValue(blobMinHeight)
      .setSize(150, 20)
        .setPosition(5, 100 + 40)
          .setRange(0, 200)
            .setLabel("MINIMUM BLOB HEIGHT")
              .getCaptionLabel()
                .align(ControlP5.RIGHT, ControlP5.LEFT_OUTSIDE)
                  .setPaddingX(0);

  cp5.addSlider("thresh")
    .setValue(thresh)
      .setSize(150, 20)
        .setPosition(5, 130 + 40)
          .setRange(10, 70)
            .setLabel("MOVEMENT THRESHOLD")
              .getCaptionLabel()
                .align(ControlP5.RIGHT, ControlP5.LEFT_OUTSIDE)
                  .setPaddingX(0);

  cp5.addSlider("hueThresh")
    .setValue(hueThresh)
      .setSize(150, 20)
        .setPosition(5, 160 + 40)
          .setRange(0, 200)
            .setLabel("HUE THRESHOLD")
              .getCaptionLabel()
                .align(ControlP5.RIGHT, ControlP5.LEFT_OUTSIDE)
                  .setPaddingX(0);
  cp5.addSlider("saturationThresh")
    .setValue(saturationThresh)
      .setSize(150, 20)
        .setPosition(5, 190 + 40)
          .setRange(0, 200)
            .setLabel("SATURATION THRESHOLD")
              .getCaptionLabel()
                .align(ControlP5.RIGHT, ControlP5.LEFT_OUTSIDE)
                  .setPaddingX(0);

  cp5.addSlider("brightnessThresh")
    .setValue(brightnessThresh)
      .setSize(150, 20)
        .setPosition(5, 220 + 40)
          .setRange(0, 200)
            .setLabel("BRIGHTNESS THRESHOLD")
              .getCaptionLabel()
                .align(ControlP5.RIGHT, ControlP5.LEFT_OUTSIDE)
                  .setPaddingX(0);

  cp5.addSlider("RGBthreshold")
    .setValue(RGBthreshold)
      .setSize(150, 20)
        .setPosition(5, 250 + 40)
          .setRange(0, 200)
            .setLabel("RGB THRESHOLD")
              .getCaptionLabel()
                .align(ControlP5.RIGHT, ControlP5.LEFT_OUTSIDE)
                  .setPaddingX(0);
}

void resetButton() {
  fill(150);
  rect(width-150, height-40, 150, 40);
  fill(255);
  textAlign(CENTER);
  text("RESET COUNTS", width-75, height-15);
}

void saveSliders() {
  fill(150);
  rect(5, height-150, 150, 40);
  fill(255);
  textAlign(CENTER);
  text("SAVE VALUES", 77, height-125);
}
