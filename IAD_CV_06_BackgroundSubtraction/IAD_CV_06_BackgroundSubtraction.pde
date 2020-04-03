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
  opencv.startBackgroundSubtraction(5, 3, 0.5);
}

void draw() {
  background(0);

  if (cam.available())
    cam.read();

  blendMode(BLEND);
  image(cam, 0, 0);
  opencv.loadImage(cam);

  opencv.updateBackground();

  opencv.dilate();
  opencv.erode();

  blendMode(MULTIPLY);
  image(opencv.getSnapshot(), 0, 0);
}
