public interface ILoopContext
{
  int getLoopCount();
  ILoopMatrixProcessor getLoopMatrixProcessor();
  ILoopTimeProcessor getLoopTimeProcessor();
}

public class OnceLoopContext implements ILoopContext
{
  private ILoopMatrixProcessor loopMatrixProcessor;
  private ILoopTimeProcessor loopTimeProcessor;
  
  public OnceLoopContext()
  {
    loopMatrixProcessor = new SimpleLoopMatrixProcessor();
    loopTimeProcessor = new SimpleLoopTimeProcessor();
  }
  
  public int getLoopCount() { return 1; }
  
  public ILoopMatrixProcessor getLoopMatrixProcessor() { return loopMatrixProcessor; }
  
  public ILoopTimeProcessor getLoopTimeProcessor() { return loopTimeProcessor; }
}

public class LoopContext implements ILoopContext
{
  private int loopCount;
  private ILoopMatrixProcessor loopMatrixProcessor;
  private ILoopTimeProcessor loopTimeProcessor;
  
  public LoopContext(int loopCount, ILoopMatrixProcessor loopMatrixProcessor, ILoopTimeProcessor loopTimeProcessor)
  {
    //loopMatrixProcessor = new SimpleLoopMatrixProcessor();
    //loopTimeProcessor = new SimpleLoopTimeProcessor();
    this.loopCount = loopCount;
    this.loopMatrixProcessor = loopMatrixProcessor;
    this.loopTimeProcessor = loopTimeProcessor;
  }
  
  public int getLoopCount() { return loopCount; }
  
  public ILoopMatrixProcessor getLoopMatrixProcessor() { return loopMatrixProcessor; }
  
  public ILoopTimeProcessor getLoopTimeProcessor() { return loopTimeProcessor; }
}
