import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public interface ISequenceTimeProcessor
{
  float getProcessedTime(float time, int index);
}

public class SimpleSequenceTimeProcessor implements ISequenceTimeProcessor
{
  public float getProcessedTime(float time, int index)
  {
    return time;
  }
}

public class DelayedSequenceTimeProcessor implements ISequenceTimeProcessor
{
  private float delay;
  
  public DelayedSequenceTimeProcessor(float delay)
  {
    this.delay = delay;
  }
  
  public float getProcessedTime(float time, int index)
  {
    return time - delay * index;
  }
}

public class RandomDelayedSequenceTimeProcessor implements ISequenceTimeProcessor
{
  private IntList indices = new IntList();
  private float delay;
  
  public RandomDelayedSequenceTimeProcessor(int length, float delay)
  {
    this.delay = delay;
    for(int i = 0; i < length; i++)
    {
      indices.append(i);
    }
    indices.shuffle();
  }
  
  public float getProcessedTime(float time, int index)
  {
    return time - delay * indices.get(index);
  }
}
