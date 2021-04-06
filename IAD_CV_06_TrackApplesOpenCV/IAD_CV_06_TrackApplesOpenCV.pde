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
}

void draw() {
  background(0);

  if (cam.available())
    cam.read();

  opencv.useColor(HSB);
  opencv.loadImage(cam);

  opencv.setGray(opencv.getH().clone());
  opencv.inRange(lowerb, upperb);

  blendMode(BLEND);
  image(cam, 0, 0);

  //blendMode(MULTIPLY);
  //image(opencv.getOutput(), 0, 0);

  // run contour detection
  strokeWeight(3);
  stroke(255, 0, 0);
  fill(255, 0, 0, 100);
  for (Contour contour : opencv.findContours()) {
    // filter by size
    if (contour.area() > 5000) {
      contour.draw();
    }
  }

  color pixel = cam.get(mouseX, mouseY);
  println("Hue: " + hue(pixel));
}
