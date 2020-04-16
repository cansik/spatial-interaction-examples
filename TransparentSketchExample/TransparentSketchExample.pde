import processing.awt.PSurfaceAWT;
import processing.awt.PSurfaceAWT.SmoothCanvas;
import javax.swing.JFrame;

void setup() {
  fullScreen();
  setTransparent(0.1);
}

void draw() {
  background(0, 0);
  fill(255);
  circle(mouseX, mouseY, 50);
}

void setTransparent(float opacity) {
  PSurfaceAWT awtSurface = (PSurfaceAWT) surface;
  SmoothCanvas smoothCanvas = (SmoothCanvas) awtSurface.getNative();
  JFrame jframe = (JFrame)smoothCanvas.getFrame();
  jframe.dispose();
  jframe.setUndecorated(true);
  jframe.setOpacity(opacity);
  jframe.setVisible(true);
}
