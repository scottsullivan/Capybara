void testingControls() {
  cp5.addSlider("blobMinWidth")
    .setValue(20)
      .setSize(150, 20)
        .setPosition(width-150, 70)
          .setRange(0, 200)
            .setLabel("MINIMUM BLOB WIDTH")
              .getCaptionLabel()
                .align(ControlP5.RIGHT, ControlP5.LEFT_OUTSIDE)
                  .setPaddingX(0);
  cp5.addSlider("blobMinHeight")
    .setValue(50)
      .setSize(150, 20)
        .setPosition(width-150, 100)
          .setRange(0, 400)
            .setLabel("MINIMUM BLOB HEIGHT")
              .getCaptionLabel()
                .align(ControlP5.RIGHT, ControlP5.LEFT_OUTSIDE)
                  .setPaddingX(0);

  cp5.addSlider("thresh")
    .setValue(35)
      .setSize(150, 20)
        .setPosition(width-150, 130)
          .setRange(10, 70)
            .setLabel("MOVEMENT THRESHOLD")
              .getCaptionLabel()
                .align(ControlP5.RIGHT, ControlP5.LEFT_OUTSIDE)
                  .setPaddingX(0);

  cp5.addSlider("hueThresh")
    .setValue(20)
      .setSize(150, 20)
        .setPosition(width-150, 160)
          .setRange(0, 200)
            .setLabel("HUE THRESHOLD")
              .getCaptionLabel()
                .align(ControlP5.RIGHT, ControlP5.LEFT_OUTSIDE)
                  .setPaddingX(0);
  cp5.addSlider("saturationThresh")
    .setValue(0)
      .setSize(150, 20)
        .setPosition(width-150, 190)
          .setRange(0, 200)
            .setLabel("SATURATION THRESHOLD")
              .getCaptionLabel()
                .align(ControlP5.RIGHT, ControlP5.LEFT_OUTSIDE)
                  .setPaddingX(0);

  cp5.addSlider("brightnessThresh")
    .setValue(0)
      .setSize(150, 20)
        .setPosition(width-150, 220)
          .setRange(0, 200)
            .setLabel("BRIGHTNESS THRESHOLD")
              .getCaptionLabel()
                .align(ControlP5.RIGHT, ControlP5.LEFT_OUTSIDE)
                  .setPaddingX(0);

  cp5.addSlider("RGBthreshold")
    .setValue(30)
      .setSize(150, 20)
        .setPosition(width-150, 250)
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

