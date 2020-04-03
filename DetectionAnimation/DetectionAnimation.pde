JSONArray data;
PImage image;

void setup() {
  size(1920, 1080, FX2D);

  image = loadImage("image.jpg");
  data = loadJSONArray("detections.json");
}

void draw() {
  background(0);

  image(image, 0, 0);

  for (int i = 0; i < data.size(); i++) {
    if (i > frameCount % data.size()) {
      continue;
    }

    JSONObject imageData = data.getJSONObject(i);
    JSONArray detections = imageData.getJSONArray("detections");

    for (int j = 0; j < detections.size(); j++) {
      JSONObject detection = detections.getJSONObject(j);

      float confidence = detection.getFloat("confidence");
      if (confidence < 0.4)
        continue;

      int x = detection.getInt("x");
      int y = detection.getInt("y");
      int w = detection.getInt("w");
      int h = detection.getInt("h");

      if (w > 300)
        continue;

      noStroke();
      fill(0, 255, 255, 20);

      ellipseMode(CORNER);
      circle(x, y, w);
    }
  }
}
