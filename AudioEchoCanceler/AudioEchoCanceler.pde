import ddf.minim.*;

Minim minim;
AudioInput in;
AudioOutput out;
InputOutputBind signal;

int SAMPLE_RATE = 44100;

PGraphics bufferCanvas;

boolean firstDraw = true;

void setup()
{
  size(512, 200, P3D);
  frameRate(30);

  minim = new Minim(this);

  int buffer = 1024;
  out = minim.getLineOut(Minim.MONO, buffer);
  in = minim.getLineIn(Minim.MONO, buffer);

  println("Input: " + in.getFormat());
  println("Output: " + out.getFormat());

  SAMPLE_RATE = (int)in.getFormat().getSampleRate();

  signal = new InputOutputBind(1024);
  //add listener to gather incoming data
  in.addListener(signal);
  // adds the signal to the output
  out.addSignal(signal);

  bufferCanvas = createGraphics(width, 100, P2D);
}

void draw()
{
  background(0);
  stroke(255);

  if (firstDraw)
  {
    bufferCanvas.beginDraw();
    //bufferCanvas.background(0, 255, 0);
    bufferCanvas.noFill();
    bufferCanvas.stroke(255);
    bufferCanvas.rect(0, 0, bufferCanvas.width - 1, bufferCanvas.height - 1);
    bufferCanvas.endDraw();
    firstDraw = false;
  }

  // draw the waveforms so we can see what we are monitoring
  for (int i = 0; i < in.bufferSize() - 1; i++)
  {
    line( i, 50 + in.left.get(i)*50, i+1, 50 + in.left.get(i+1)*50 );
    //line( i, 150 + in.right.get(i)*50, i+1, 150 + in.right.get(i+1)*50 );
  }

  // draw canvas
  bufferCanvas.beginDraw();

  // draw long buffer
  LoopRingBuffer lrp = signal.getBuffer();
  float l = width / float((lrp.size() - 1));

  float pos = l * lrp.pos;
  float now = lrp.get(Math.floorMod(lrp.pos - 1, lrp.size()));
  float next = lrp.get(lrp.pos % lrp.size());

  //println("Now: " + now + "\tNext: " + next);

  float shift = bufferCanvas.height / 2f;
  float amp = bufferCanvas.height;
  float indexHight = 5;
  
  // clear
  bufferCanvas.noStroke();
  bufferCanvas.fill(0);
  bufferCanvas.rect(pos, 1, l * 1024, bufferCanvas.height - 2);
  bufferCanvas.rect(0, 1, bufferCanvas.width, indexHight);
  
  bufferCanvas.stroke(0, 255, 0);
  bufferCanvas.noFill();
  bufferCanvas.line(pos, (amp * now) + shift, pos + l, (amp * next) + shift);
  
  // draw current index
  bufferCanvas.stroke(255, 255, 0);
  bufferCanvas.line(pos, 1, pos, indexHight);
  
  // draw filtering index
  bufferCanvas.stroke(255, 0, 255);
  int xsample = (int)(signal.audioDelayToFilterInSeconds * SAMPLE_RATE);
  int xpos = Math.floorMod(lrp.getPosition() - xsample, lrp.size());
  bufferCanvas.line(xpos * l, 1, xpos * l, indexHight);
  bufferCanvas.endDraw();

  image(bufferCanvas, 0, 100);

  String filterState = signal.filter ? "enabled" : "disabled";
  text("FPS: " + frameRate, width - 100, 15);
  text("Audio Echo Canceling is currently " + filterState + ".", 5, 15 );
}

void keyPressed()
{
  if (key == 'f')
    signal.filter = !signal.filter;
}