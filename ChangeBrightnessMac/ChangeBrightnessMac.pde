void setup() {
  size(500, 500, FX2D);
  frameRate(1);
}

void draw() {
  background(0);

  fill(255);
  rect(width / 2, 0, width / 2, height);

  if (mouseX > width / 2)
    darker();
  else
    brighter();
}

void brighter() {
  exec("osascript", "-e", "tell application \"System Events\"", "-e", "key code 145", "-e", " end tell");
}

void darker() {
  exec("osascript", "-e", "tell application \"System Events\"", "-e", "key code 144", "-e", " end tell");
}
