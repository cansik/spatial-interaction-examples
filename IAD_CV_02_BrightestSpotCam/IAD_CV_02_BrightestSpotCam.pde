import processing.video.*;

Capture cam;

void setup() {
  size(640, 480, FX2D);

  String[] inputDevices = Capture.list();
  println(inputDevices);
  cam = new Capture(this, inputDevices[0]);
  
  cam.start();
}

void draw() {
  background(0);

  if (cam.available())
    cam.read();

  image(cam, 0, 0);

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

  // mark point
  stroke(50, 255, 50);
  noFill();
  circle(maxX, maxY, 50);
}
