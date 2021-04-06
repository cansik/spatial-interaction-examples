import processing.video.*;
import gab.opencv.*;

Capture cam;
OpenCV opencv;

PImage last = null;

void setup() {
  size(640, 480);

  cam = new Capture(this, "pipeline:autovideosrc");
  cam.start();

  opencv = new OpenCV(this, 640, 480);
}

void draw() {
  background(0);

  if (cam.available())
    cam.read();

  opencv.loadImage(cam);
  opencv.threshold(240);

  blendMode(BLEND);
  image(cam, 0, 0);

  noFill();
  stroke(255, 0, 0);
  strokeWeight(3);
  for (Contour contour : opencv.findContours()) {
    contour.draw();
  }
}
