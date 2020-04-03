import processing.video.*;
import gab.opencv.*;

Capture cam;
OpenCV opencv;

void setup() {
  size(640, 480, FX2D);

  String[] inputDevices = Capture.list();
  cam = new Capture(this, 640, 480, inputDevices[0]);
  opencv = new OpenCV(this, 640, 480);
  
  cam.start();
}

void draw() {
  background(0);
  
  if(cam.available())
    cam.read();
  
  opencv.loadImage(cam);
  opencv.blur(10);
  PVector location = opencv.max();
  
  image(opencv.getSnapshot(), 0, 0);
  
  noFill();
  strokeWeight(5.0);
  stroke(100, 255, 80);
  circle(location.x, location.y, 10);
}
