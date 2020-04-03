import processing.video.*;
import gab.opencv.*;

Capture cam;
OpenCV opencv;

PImage last = null;

void setup() {
  size(640, 480);

  String[] inputDevices = Capture.list();
  cam = new Capture(this, 640, 480, inputDevices[0]);
  cam.start();

  opencv = new OpenCV(this, 640, 480);
  
  background(0);
}

void draw() {
  //background(0);

  if (cam.available())
    cam.read();

  opencv.loadImage(cam);
  opencv.threshold(240);

  opencv.dilate();
  opencv.erode();

  // image(opencv.getSnapshot(), 0, 0);

  noFill();
  stroke(255, 0, 0);
  strokeWeight(3);
  for (Contour contour : opencv.findContours()) {
    if (contour.area() > 100.0) {
        int x = (int)contour.getBoundingBox().getCenterX();
        int y = (int)contour.getBoundingBox().getCenterY();
        
        //contour.draw();
        circle(x, y, 10);
    }
  }
}
