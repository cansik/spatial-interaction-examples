import gab.opencv.*;
import processing.video.*;

OpenCV opencv;
Capture cam;

int lowerb = 46;
int upperb = 59;

void setup() {
  size(640, 480, FX2D);
  
  // map 360 hue to 255 range
  lowerb = round(map(lowerb, 0, 360, 0, 255));
  upperb = round(map(upperb, 0, 360, 0, 255));

  cam = new Capture(this, "pipeline:autovideosrc");
  opencv = new OpenCV(this, 640, 480);
  opencv.useColor(HSB);
  
   cam.start();
}

void draw() {
  background(0);

  if(cam.available())
    cam.read();
  
  opencv.loadImage(cam);
  
  opencv.setGray(opencv.getH().clone());
  opencv.inRange(lowerb, upperb);
  
  blendMode(BLEND);
  image(cam, 0, 0);
  
  blendMode(MULTIPLY);
  image(opencv.getOutput(), 0, 0);
}
