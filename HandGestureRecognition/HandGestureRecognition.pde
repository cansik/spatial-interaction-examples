import ch.bildspur.vision.*;
import ch.bildspur.vision.result.*;

import processing.video.Capture;

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress dest;

Capture cam;
PImage hand;
String classificationResult = "-";

DeepVision vision = new DeepVision(this);
SSDMobileNetwork network;
ResultList<ObjectDetectionResult> detections;

public void setup() {
  size(640, 480, FX2D);
  colorMode(HSB, 255);

  println("creating network...");
  network = vision.createHandDetector();

  println("loading model...");
  network.setup();
  network.setConfidenceThreshold(0.5);

  println("setup camera...");
  String[] cams = Capture.list();
  cam = new Capture(this, cams[1]);
  cam.start();

  println("prepare hand image...");
  hand = new PImage(16, 16);

  println("setup osc...");
  oscP5 = new OscP5(this, 12000);
  dest = new NetAddress("127.0.0.1", 6448);
}

public void draw() {
  background(55);

  // check if there is camera input
  if (cam.available()) {
    cam.read();
  }

  // otherwise skip
  if (cam.width == 0) {
    text("loading cam...", width / 2, height / 2);
    return;
  }

  // display input
  image(cam, 0, 0);

  // detect all hands
  detections = network.run(cam);

  // if hand detected convert it to bw and send to wekinator
  if (!detections.isEmpty()) {
    createInputImage(detections.get(0));

    // send image to wekinator
    sendInputImage();
  } else {
    classificationResult = "";
  }

  noFill();
  strokeWeight(2f);

  // display all detected hands on the screen
  // green is the one we choose
  int i = 0;
  for (ObjectDetectionResult detection : detections) {
    stroke(220, 220, 255, 100);

    if (i == 0)
      stroke(100, 220, 255);

    rect(detection.getX(), detection.getY(), detection.getWidth(), detection.getHeight());
    i++;
  }

  image(hand, 0, 0, hand.width * 3, hand.height * 3);

  textSize(20);
  textAlign(CENTER, TOP);
  text(classificationResult, width / 2, 20);

  surface.setTitle("Hand Detection Test - FPS: " + Math.round(frameRate));
}

void createInputImage(ObjectDetectionResult det) {
  // extract ROI
  hand.copy(cam, 
    det.getX(), det.getY(), det.getWidth(), det.getHeight(), 
    0, 0, hand.width, hand.height);

  // extract skin color
  // iterate over each pixel and check if it falls into the following range:
  // (https://stackoverflow.com/questions/8753833/exact-skin-color-hsv-range/42885200)
  PVector minHSB = new PVector(0, 10, 60);
  PVector maxHSB = new PVector(20, 150, 255);

  hand.loadPixels();
  for (int i = 0; i < hand.pixels.length; i++) {
    color p = hand.pixels[i];

    float h = hue(p);
    float s = saturation(p);
    float b = brightness(p);

    // check if pixel is relevant
    boolean relevant = isBetween(h, minHSB.x, maxHSB.x)
      && isBetween(s, minHSB.y, maxHSB.y)
      && isBetween(b, minHSB.z, maxHSB.z);

    // mark pixel white / black
    hand.pixels[i] = relevant ? color(255) : color(0);
  }
  hand.updatePixels();
}

boolean isBetween(float value, float lower, float upper) {
  return value > lower && value < upper;
}

void sendInputImage() {
  OscMessage msg = new OscMessage("/wek/inputs");
  for (int i = 0; i < hand.pixels.length; i++) {
    color p = hand.pixels[i];
    float s = brightness(p) / 255.0;
    msg.add(s);
  }
  oscP5.send(msg, dest);
}

void oscEvent(OscMessage msg) {
  // if wekinator sends us data back, we evalute it
  if (msg.checkAddrPattern("/wek/outputs")) {
    float normalProb = msg.get(0).floatValue();
    float thumbProb = msg.get(1).floatValue();

    float maxProb = max(normalProb, thumbProb);
    boolean isThumb = thumbProb > normalProb;

    if (maxProb > 0.8) {
      classificationResult = isThumb ? "thumb up" : "normal";
    } else {
      classificationResult = "";
    }
  }
}
