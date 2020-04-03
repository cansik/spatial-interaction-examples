import processing.video.Capture;

// captures a new video frame every n seconds
int captureInterval = 10;
int resolutionX = 1920;
int resolutionY = 1080;

Capture cam;
boolean proposeCapture = false;
int captureCount = 0;
int lastCaptureTime = 0;

void setup() {
  size(420, 420, FX2D);

  println("setup camera...");
  String[] cams = Capture.list();
  cam = new Capture(this, resolutionX, resolutionY, cams[0]);
  cam.start();
}

void draw() {
  background(#222f3e);

  // capture code
  if (proposeCapture) {

    if (cam.available()) {
      cam.read();

      cam.save("frames/capture-" + nf(captureCount, 5, 0) + ".jpg");

      captureCount++;
      lastCaptureTime = millis();
      proposeCapture = false;

      println(millis() + ": captured #" + captureCount);
    }
  }

  // determine if capture is needed
  int timeSinceLastCapture = millis() - lastCaptureTime;
  int intervalTime = captureInterval * 1000;
  int deltaTimeSeconds = (intervalTime - timeSinceLastCapture);

  if (timeSinceLastCapture >= intervalTime) {
    proposeCapture = true;
  }

  // display time
  textAlign(CENTER, CENTER);
  textSize(30);
  fill(#c8d6e5);
  text("Next Capture\n"
    + (deltaTimeSeconds / 1000 + 1) + " s", 
    width / 2, 
    height / 9 * 3);

  // draw progress bar
  stroke(#2e86de);
  noFill();
  circle(width / 2, height / 9 * 6, 100);

  float progress = TWO_PI - ((float)deltaTimeSeconds / intervalTime) * TWO_PI;

  noStroke();
  fill(#54a0ff);
  arc(width / 2, height / 9 * 6, 100, 100, 0, progress, PIE);
}

void keyPressed() {
  proposeCapture = true;
}
