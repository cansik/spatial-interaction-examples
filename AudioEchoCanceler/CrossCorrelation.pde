
float maxValLastCorrleation = 0;

public float execCorrelation(float[] x1, float[] x2)
{
  // define the size of the resulting correlation field
  int corrSize = 2*x1.length;
  // create correlation vector
  float[] out = new float[corrSize];
  // shift variable
  int shift = x1.length;
  float val;
  int maxIndex = 0;
  float maxVal = 0;

  // we have push the signal from the left to the right
  for (int i=0; i<corrSize; i++)
  {
    val = 0;
    // multiply sample by sample and sum up
    for (int k=0; k<x1.length; k++)
    {
      // x2 has reached his end - abort
      if ((k+shift) > (x2.length -1))
      {
        break;
      }

      // x2 has not started yet - continue
      if ((k+shift) < 0)
      {
        continue;
      }

      // multiply sample with sample and sum up
      val += x1[k] * x2[k+shift];
      //System.out.print("x1["+k+"] * x2["+(k+tmp_tau)+"] + ");
    }
    //System.out.println();
    // save the sample
    out[i] = val;
    shift--;
    // save highest correlation index
    if (out[i] > maxVal)
    {
      maxVal = out[i];
      maxIndex = i;
    }
  }
  
  maxValLastCorrleation = maxVal;

  // set the delay
  return maxIndex - x1.length;
}