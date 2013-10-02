void testingControls() {
  cp5.addSlider("blobMinWidth")
    .setValue(20)
      .setSize(150, 20)
        .setPosition(width-150, 70)
          .setRange(0, 200);
  cp5.addSlider("blobMinHeight")
    .setValue(50)
      .setSize(150, 20)
        .setPosition(width-150, 100)
          .setRange(0, 400);

  cp5.addSlider("thresh")
    .setValue(30)
      .setSize(150, 20)
        .setPosition(width-150, 130)
          .setRange(10, 70);
}

void resetButton() {
  fill(150);
  rect(width-150, 160, 150, 40);
  fill(255);
  textAlign(CENTER);
  text("RESET VALUES", width-75, 185);
}

