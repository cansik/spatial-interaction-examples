import processing.video.*;
import gab.opencv.*;

Capture cam;
OpenCV opencv;

void setup() {
  size(640, 480, FX2D);

  cam = new Capture(this, "pipeline:autovideosrc");
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
  
  image(cam, 0, 0);
  
  noFill();
  stroke(255, 0, 255);
  circle(location.x, location.y, 15);
}
