// leafe color ranges (mainly for dark leafes)
PVector minHSB = new PVector(77, 69, 20);
PVector maxHSB = new PVector(255, 255, 255);

PImage plantImage;

void setup() {
  size(640, 360, FX2D);
  colorMode(HSB, 255, 255, 255);

  // image by https://unsplash.com/@sakulich
  plantImage = loadImage("sergei-akulich--heLWtuAN3c-unsplash.jpg");
}

void draw() {
  background(0);

  PImage mask = extractHueColor(plantImage, minHSB, maxHSB);

  blendMode(BLEND);
  image(plantImage, 0, 0);
  
  blendMode(SCREEN);
  image(mask, 0, 0);
}

PImage extractHueColor(PImage image, PVector minHSB, PVector maxHSB) {
  // extract hue color range
  PImage mask = new PImage(image.width, image.height, RGB);

  image.loadPixels();
  for (int i = 0; i < image.pixels.length; i++) {
    color p = image.pixels[i];

    float h = hue(p);
    float s = saturation(p);
    float b = brightness(p);

    // check if pixel is relevant
    boolean relevant = isBetween(h, minHSB.x, maxHSB.x)
      && isBetween(s, minHSB.y, maxHSB.y)
      && isBetween(b, minHSB.z, maxHSB.z);

    // mark pixel white / black
    mask.pixels[i] = relevant ? color(255) : color(0);
  }
  mask.updatePixels();

  return mask;
}

boolean isBetween(float value, float lower, float upper) {
  return value > lower && value < upper;
}
