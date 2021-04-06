import gab.opencv.*;
import processing.video.*;

OpenCV opencv;
Capture cam;

int lowerb = 60;
int upperb = 80;

void setup() {
  size(640, 480);

  // map 360 hue to 255 range
  lowerb = round(map(lowerb, 0, 360, 0, 255));
  upperb = round(map(upperb, 0, 360, 0, 255));

  cam = new Capture(this, "pipeline:autovideosrc");
  opencv = new OpenCV(this, 640, 480);
  cam.start();
  
  background(0);
}

void draw() {
  if (cam.available())
    cam.read();

  opencv.useColor(HSB);
  opencv.loadImage(cam);

  opencv.setGray(opencv.getH().clone());
  opencv.inRange(lowerb, upperb);

  // run contour detection
  noStroke();
  fill(255, 0, 0, 100);
  for (Contour contour : opencv.findContours()) {
    // filter by size
    if (contour.area() > 8000) {
      contour.draw();
    }
  }

  color pixel = cam.get(mouseX, mouseY);
  println("Hue: " + hue(pixel));
}
