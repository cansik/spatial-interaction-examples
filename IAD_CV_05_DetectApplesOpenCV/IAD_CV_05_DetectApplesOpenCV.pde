import gab.opencv.*;
import org.opencv.core.Core;

OpenCV opencv;
PImage image;

int lowerb = 46;
int upperb = 59;

void setup() {
  size(640, 480, FX2D);
  
  // map 360 hue to 255 range
  lowerb = round(map(lowerb, 0, 360, 0, 255));
  upperb = round(map(upperb, 0, 360, 0, 255));

  image = loadImage("apples.jpg");
  opencv = new OpenCV(this, image.width, image.height);
  opencv.useColor(HSB);
}

void draw() {
  background(0);

  opencv.loadImage(image);
  opencv.setGray(opencv.getH().clone());
  opencv.inRange(lowerb, upperb);
  
  blendMode(BLEND);
  image(image, 0, 0);
  
  blendMode(MULTIPLY);
  image(opencv.getOutput(), 0, 0);
}
