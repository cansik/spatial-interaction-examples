import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by cansik on 18/04/16.
 */
public class LoopRingBuffer {
    private float[] buffer;
    int pos = 0;

    public LoopRingBuffer(int size)
    {
        buffer = new float[size];
    }

    public LoopRingBuffer(float[] values)
    {
        this(values.length);
        put(values);
    }

    public LoopRingBuffer(LoopRingBuffer lrb, int length)
    {
        this(length);
        float[] data = lrb.getBuffer();
        for(int i = 0; i < length; i++)
            put(data[i]);
    }

    public int getPosition() {
        return pos;
    }

    public void put(float value)
    {
        buffer[pos] = value;
        pos = (pos + 1) % buffer.length;
    }

    public void put(float[] values)
    {
        for(int i = 0; i < values.length; i++)
        {
            put(values[i]);
        }
    }

    public float get(int index)
    {
        return buffer[index];
    }

    public float[] getBuffer()
    {
        return buffer.clone();
    }
    
    public float[] getBuffer(int start, int size)
    {
        float[] part = new float[size];
        
        for(int i = 0; i < size; i++)
        {
          int p = Math.floorMod(start + i, buffer.length);
          part[i] = buffer[p];
        }
        
        return part;
    }
    
    public int size()
    {
        return buffer.length;
    }


    /***
     * Returns latest endpoints
     * @param length
     * @return
     */
    public float[] getLatest(int length) {
        assert  (length < size());

        float[] result = new float[length];

        for (int i = 0; i < length; i++)
        {
            int p = (buffer.length + pos - i) % buffer.length;
            result[result.length-1-i] = buffer[p];
        }

        return result;
    }

    public void saveBuffer(String fileName)
    {
        StringBuilder s = new StringBuilder();
        float[] b = getBuffer();
        for(int i = 0; i < pos; i++)
        {
            s.append(i);
            s.append(",");
            s.append(b[i]);
            s.append("\n");
        }

        try {
            Files.write(Paths.get(fileName), s.toString().getBytes());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void loadBuffer(String fileName)
    {
        List<String> input = new ArrayList<String>();

        try {
            input.addAll(Files.readAllLines(Paths.get(fileName)));
        } catch (IOException e) {
            e.printStackTrace();
        }

        // add into buffer
        for(String s : input)
        {
            float f = Float.parseFloat(s.split(",")[1]);
            put(f);
        }
    }
}