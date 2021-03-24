import processing.video.*;

Capture cam;

void setup() {
  size(640, 480, FX2D);

  // initialize camera
  cam = new Capture(this, "pipeline:autovideosrc");
  cam.start();

  background(0);
}

void draw() {
  if (cam.available()) {
    cam.read();
  } else {
    return;
  }

  cam.filter(BLUR, 1);
  //image(cam, 0, 0);

  // find brightest spot
  int maxX = 0;
  int maxY = 0;
  float maxBrightness = 0;

  // loop over all pixels
  for (int x = 0; x < cam.width; x++) {
    for (int y = 0; y <cam.height; y++) {

      // extract pixel and brightness
      color pixel = cam.get(x, y);
      float b = brightness(pixel);

      if (b > maxBrightness) {
        maxBrightness = b;
        maxX = x;
        maxY = y;
      }
    }
  }

  // mark point (if brightness is enough)
  if (maxBrightness > 240) {
    fill(255);
    noStroke();
    circle(maxX, maxY, 10);
  }

  surface.setTitle("Max Brightness: " + nfp(maxBrightness, 0, 2));
}

void keyPressed() {
  background(0);
}
