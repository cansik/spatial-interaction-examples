import processing.video.*;
import gab.opencv.*;
import org.opencv.core.*;

Capture cam;
OpenCV opencv;

void setup() {
  size(500, 500, FX2D);

  String[] inputDevices = Capture.list();
  cam = new Capture(this, 640, 480, inputDevices[0]);
  cam.start();

  opencv = new OpenCV(this, 640, 480);
}

void draw() {
  background(0);

  if (cam.available())
    cam.read();

  opencv.loadImage(cam);

  opencv.threshold((int)map(mouseX, 0, width, 0, 255));

  image(opencv.getSnapshot(), 0, 0);
}
