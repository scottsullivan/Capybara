boolean isSomeoneThere(int currentSensorReading, int triggerThreshold) {
  return currentSensorReading <= triggerThreshold;
}

void updateCounterDrawing(int moveCount, int sensorOut, int moveX, int moveY, String name) {
  fill(255);
  rect(moveX, moveY, 210, 100);
  fill(#e6e7e8);
  rect(moveX, moveY + 35, 124, 30);
  fill(#58595b);
  textFont(font, 15);
  text(name, moveX + 8, moveY + 55);

  fill(#808285);
  text("count", moveX + 149, moveY + 38);

  fill(#58595b);
  textFont(font, 30);
  text(moveCount, moveX + 149, moveY + 68);
}

void updateSensorOutput(int moveX, int moveY, int sensorOut) {
  fill(255);
  rect(moveX + 210, moveY, 90, 100);

  textFont(font, 15);
  fill(#808285);
  text("reading", moveX + 222, moveY + 38);

  fill(#58595b);
  textFont(font, 30);
  text(sensorOut, moveX + 222, moveY + 68);
}

