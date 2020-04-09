class InputOutputBind implements AudioSignal, AudioListener
{
  final int bufferSizeSeconds = 10;
  final float audioDelayToFilterInSeconds = 5.0;
  final int compareBufferSize = 4096;
  final float filterStrength = 0.75f;
  final float crossValueThreshold = 0.2f;

  private float[] leftChannel;
  private float[] rightChannel;

  private LoopRingBuffer longBuffer;

  public boolean filter = false;

  public LoopRingBuffer getBuffer()
  {
    return longBuffer;
  }

  InputOutputBind(int sample)
  {
    leftChannel = new float[sample];
    rightChannel= new float[sample];
    longBuffer = new LoopRingBuffer(SAMPLE_RATE * bufferSizeSeconds);
  }
  // This part is implementing AudioSignal interface, see Minim reference
  void generate(float[] samp)
  {
    if (filter)
    {
      // get buffer part of last buffer
      int pos = longBuffer.getPosition() - (int)(audioDelayToFilterInSeconds * SAMPLE_RATE) - (compareBufferSize / 2);
      float[] compareBuffer = longBuffer.getBuffer(pos, compareBufferSize);

      float[] calculatedBuffer = echoFilter(leftChannel, compareBuffer);
      arraycopy(calculatedBuffer, samp);
      longBuffer.put(calculatedBuffer);
    } else
    {
      arraycopy(leftChannel, samp);
    }
  }
  void generate(float[] left, float[] right)
  {
    arraycopy(leftChannel, left);
    arraycopy(rightChannel, right);
  }
  // This part is implementing AudioListener interface, see Minim reference
  synchronized void samples(float[] samp)
  {
    arraycopy(samp, leftChannel);
  }
  synchronized void samples(float[] sampL, float[] sampR)
  {
    arraycopy(sampL, leftChannel);
    arraycopy(sampR, rightChannel);
  }

  float[] echoFilter(float[] signal, float[] lastSignal)
  {
    float maxAmp = 0.8f;
    float[] outBuffer = new float[signal.length];

    float correlation = execCorrelation(signal, lastSignal);
    println("MaxVal: " + maxValLastCorrleation);

    for (int i = 0; i < signal.length; i++)
    {
      if (maxValLastCorrleation > crossValueThreshold)
      {
        outBuffer[i] = min(maxAmp, max(-maxAmp, (signal[i] - getValue(lastSignal, i-(int)correlation) * filterStrength)));
      }
      else
      {
        outBuffer[i] = signal[i];
      }
    }

    return outBuffer;
  }

  float getValue(float[] signal, int index)
  {
    if (index >= 0 && index < signal.length)
      return signal[index];

    return 0;
  }
} 