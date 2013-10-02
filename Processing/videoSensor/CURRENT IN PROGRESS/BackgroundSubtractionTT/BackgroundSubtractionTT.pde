import gab.opencv.*;
import processing.video.*;

Movie video;
OpenCV opencv;

ArrayList<Contour> contours;
ArrayList<Contour> polygons;

void setup() {
  size(640, 480, P2D);
  frameRate(20);
  video = new Movie(this, "TTtestvideo04.mov");
  opencv = new OpenCV(this, 640, 480);

  opencv.startBackgroundSubtraction(5, 3, 0.5);

  video.loop();
  video.play();

  contours = opencv.findContours();
}

void draw() {
  image(video, 0, 0);  
  opencv.loadImage(video);

  opencv.updateBackground();

  opencv.dilate();
  opencv.erode();
  
  contours = opencv.findContours();

  for (Contour contour : contours) {
    stroke(0, 255, 0);
    //contour.draw();

    stroke(255, 0, 0);
    beginShape();
    for (PVector point : contour.getPolygonApproximation().getPoints()) {
      vertex(point.x, point.y);
    }
    endShape();
  }


  //  noFill();
  //  stroke(255, 0, 0);
  //  strokeWeight(3);
  //  for (Contour contour : opencv.findContours()) {
  //    contour.draw();
  //
  //      stroke(0, 0, 255);
  //    beginShape();
  //    for (PVector point : contour.getPolygonApproximation().getPoints()) {
  //      vertex(point.x, point.y);
  //    }
  //    endShape();
  //  }
}

void movieEvent(Movie m) {
  m.read();
}

