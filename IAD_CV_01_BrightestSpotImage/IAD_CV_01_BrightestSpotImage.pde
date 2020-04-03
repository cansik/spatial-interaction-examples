// Photo by mohammad alizade on Unsplash
// (https://unsplash.com/photos/S5uV7ro4UPY)

PImage img;

void setup() {
  size(640, 896, FX2D);

  img = loadImage("mohammad-alizade-S5uV7ro4UPY-unsplash.jpg");
  noLoop();
}

void draw() {
  background(0);

  image(img, 0, 0);

  // find brightest spot
  int maxX = 0;
  int maxY = 0;
  float maxBrightness = 0;

  // loop over all pixels
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {

      // extract pixel and brightness
      color pixel = img.get(x, y);
      float b = brightness(pixel);

      if (b > maxBrightness) {
        maxBrightness = b;
        maxX = x;
        maxY = y;
      }
    }
  }

  // mark point
  stroke(100, 255, 80);
  noFill();
  circle(maxX, maxY, 50);
}
