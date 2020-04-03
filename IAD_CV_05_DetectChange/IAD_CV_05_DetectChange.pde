import processing.video.*;
import gab.opencv.*;
import org.opencv.core.*;

Capture cam;
OpenCV opencv;

PImage last = null;

void setup() {
  size(640, 480);

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
  
  if(last != null) {
    opencv.diff(last);
    opencv.threshold(40);
  }
  
  last = cam.copy();
  
  float count = Core.countNonZero(opencv.getGray());
  float difference = count / (cam.width * cam.height) * 100;
  
  if(difference > 10.0) {
    println(millis() + "WARNING!");
  }

  image(opencv.getSnapshot(), 0, 0);
  
  fill(0, 255, 255);
  text("Difference: " + difference, 20, 20);
}
