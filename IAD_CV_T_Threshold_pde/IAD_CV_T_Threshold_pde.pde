import processing.video.*;
import gab.opencv.*;
import org.opencv.core.*;

Capture cam;
OpenCV opencv;

void setup() {
  size(500, 500, FX2D);

  cam = new Capture(this, "pipeline:autovideosrc");
  cam.start();

  opencv = new OpenCV(this, 640, 480);
}

void draw() {
  background(0);

  if (cam.available())
    cam.read();

  opencv.loadImage(cam);

  int tval = (int)map(mouseX, 0, width, 0, 255);
  opencv.threshold(tval);

  image(opencv.getSnapshot(), 0, 0);
  
  surface.setTitle("Threshold: " + tval);
}
