import ch.bildspur.vision.result.*;
import ch.bildspur.vision.*;
import ch.bildspur.vision.util.*;

import ch.bildspur.vision.*;
import ch.bildspur.vision.result.*;

import java.util.List;

import processing.video.Capture;

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress dest;

Capture cam;

DeepVision vision = new DeepVision(this);
CascadeClassifierNetwork faceNetwork;
FacemarkLBFNetwork facemark;

ResultList<ObjectDetectionResult> detections;
ResultList<FacialLandmarkResult> markedFaces;

int keyPointCount = 68;
int noseIndex = 30;

float[] distances = new float[keyPointCount];

public void setup() {
  size(640, 480, FX2D);
  colorMode(HSB, 360, 100, 100);

  println("creating networks...");
  faceNetwork = vision.createCascadeFrontalFace();
  facemark = vision.createFacemarkLBF();

  println("loading models...");
  faceNetwork.setup();
  facemark.setup();

  println("setup camera...");
  String[] cams = Capture.list();
  cam = new Capture(this, cams[0]);
  cam.start();

  println("setup osc...");
  oscP5 = new OscP5(this, 9000);
  dest = new NetAddress("127.0.0.1", 6448);
}

public void draw() {
  if (cam.available()) {
    cam.read();
  } else {
    return;
  }

  background(55);

  image(cam, 0, 0);
  detections = faceNetwork.run(cam);

  markedFaces = facemark.runByDetections(cam, detections);
  displayDetection();

  // generate distances
  for (int i = 0; i < detections.size(); i++) {
    generateDistances(detections.get(i), markedFaces.get(i));
    sendDistances();
  }

  surface.setTitle("Sleep Detector - FPS: " + Math.round(frameRate));
}

void generateDistances(ObjectDetectionResult face, FacialLandmarkResult landmarks) {
  float faceSize = face.getWidth() * face.getHeight();

  KeyPointResult nosePoint = landmarks.getKeyPoints().get(noseIndex);
  PVector noseVector = new PVector(nosePoint.getX(), nosePoint.getY());

  for (int i = 0; i < landmarks.getKeyPoints().size(); i++) {
    KeyPointResult kp = landmarks.getKeyPoints().get(i);
    PVector v = new PVector(kp.getX(), kp.getY());

    float distance = v.dist(noseVector) / faceSize;
    distances[i] = distance;
  }
}

void sendDistances() {
  OscMessage msg = new OscMessage("/wek/inputs");
  for (float distance : distances) {
    msg.add(distance);
  }
  oscP5.send(msg, dest);
}

void displayDetection() {
  for (int i = 0; i < detections.size(); i++) {
    ObjectDetectionResult face = detections.get(i);
    FacialLandmarkResult landmarks = markedFaces.get(i);

    noFill();
    strokeWeight(2f);
    stroke(200, 80, 100);
    rect(face.getX(), face.getY(), face.getWidth(), face.getHeight());

    noStroke();
    fill(100, 80, 100);
    for (int j = 0; j < landmarks.getKeyPoints().size(); j++) {
      KeyPointResult kp = landmarks.getKeyPoints().get(j);

      fill(100, 80, 200);
      ellipse(kp.getX(), kp.getY(), 5, 5);
    }
  }
}
