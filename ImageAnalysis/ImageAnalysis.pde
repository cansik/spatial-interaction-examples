import ch.bildspur.vision.*;
import ch.bildspur.vision.network.*;
import ch.bildspur.vision.result.*;
import java.util.List;

DeepVision vision = new DeepVision(this);
YOLONetwork network;
List<ObjectDetectionResult> detections;

PImage image;
String[] images;
int currentImageIndex = 0;

JSONArray data = new JSONArray();

void setup() {
  size(1152, 648, FX2D);
  colorMode(HSB, 360, 100, 100);

  images = listFileNames(sketchPath("frames"));
  images = sort(images);

  println("creating network...");
  network = vision.createYOLOv3();

  println("loading model...");
  network.setup();
  network.setConfidenceThreshold(0.2);
}

void draw() {
  background(0);

  if (frameCount < 100) {
    return;
  }

  scale(0.6);

  String path = images[currentImageIndex];

  if (!path.endsWith(".jpg"))
  {
    currentImageIndex++;
    return;
  }

  println(path);
  image = loadImage("frames/" + (path));
  image(image, 0, 0);

  // detecting
  detections = network.run(image);

  // display
  for (ObjectDetectionResult detection : detections) {
    noFill();
    strokeWeight(3f);
    stroke(round(360.0f * (float) detection.getClassId() / network.getLabels().size()), 75, 100);
    rect(detection.getX(), detection.getY(), detection.getWidth(), detection.getHeight());

    textSize(15);
    text(detection.getClassName() + " " + nf(detection.getConfidence(), 0, 2), detection.getX(), detection.getY());
  }

  // add data
  JSONObject imgObj = new JSONObject();
  imgObj.setString("file", path);

  JSONArray detectionData = new JSONArray();

  for (ObjectDetectionResult detection : detections) {
    JSONObject obj = new JSONObject();
    obj.setInt("id", detection.getClassId());
    obj.setString("name", detection.getClassName());
    obj.setFloat("confidence", detection.getConfidence());
    obj.setInt("x", detection.getX());
    obj.setInt("y", detection.getY());
    obj.setInt("w", detection.getWidth());
    obj.setInt("h", detection.getHeight());
    detectionData.append(obj);
  }

  imgObj.setJSONArray("detections", detectionData);
  data.append(imgObj);

  float progress = (float)currentImageIndex / images.length * 100.0;
  surface.setTitle("Image #" + currentImageIndex + " " + round(progress) + "% FPS: " + nf(frameRate, 0, 2));
  currentImageIndex++;

  if (currentImageIndex >= images.length) {
    saveJSONArray(data, "detections.json");
    exit();
  }
}

String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } else {
    // If it's not a directory
    return null;
  }
}
