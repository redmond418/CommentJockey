public interface ILoopTimeProcessor
{
  float getProcessedTime(float time, int loopIndex, int loopCount);
}

public class SimpleLoopTimeProcessor implements ILoopTimeProcessor
{
  public float getProcessedTime(float time, int loopIndex, int loopCount)
  {
    return time;
  }
}

public class DelayedLoopTimeProcessor implements ILoopTimeProcessor
{
  private float delay;
  
  public DelayedLoopTimeProcessor(float delay)
  {
    this.delay = delay;
  }
  
  //public DelayedLoopTimeProcessor(int delayDivide)
  //{
  //  delay = delayDivide == 1 ? 0 : 1f / (delayDivide - 1);
  //}
  
  public float getProcessedTime(float time, int loopIndex, int loopCount)
  {
    return time - delay * loopIndex;
  }
}
