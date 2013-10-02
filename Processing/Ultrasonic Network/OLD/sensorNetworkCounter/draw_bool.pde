boolean isSomeoneThere(int currentSensorReading) {
  return currentSensorReading <= triggerThreshold;
}

void updateCounterDrawing(int moveCount, int sensorOut, int moveX, int moveY, String name) {
  fill(255); 
  rect(moveX, moveY, 300, 300);
  fill(204, 204, 204);
  rect(moveX, moveY + 275, 300, 25);
  fill(#FF8664);
  ellipse(moveX + 150, moveY + 150, (moveCount), (moveCount));
  fill(#1C1C1C);
  text(name, moveX + 7, moveY + 291); 
  text(moveCount, moveX + 70, moveY + 291);
}

