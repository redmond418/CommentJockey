public interface ILoopMatrixProcessor
{
  void processMatrix(float time, int loopIndex, int loopCount);
}

public class SimpleLoopMatrixProcessor implements ILoopMatrixProcessor
{
  public void processMatrix(float time, int loopIndex, int loopCount) {}
}

public class OffsetLoopMatrixProcessor implements ILoopMatrixProcessor
{
  private float offsetX;
  private float offsetY;
  private float scalingMultiplier;
  
  public OffsetLoopMatrixProcessor(float offsetX, float offsetY, float scalingMultiplier)
  {
    this.offsetX = offsetX;
    this.offsetY = offsetY;
    this.scalingMultiplier = scalingMultiplier;
  }
  
  public void processMatrix(float time, int loopIndex, int loopCount)
  {
    translate(offsetX * loopIndex, offsetY * loopIndex);
    float powerScale = pow(scalingMultiplier, loopIndex);
    scale(powerScale);
  }
}

public class PivotRotationLoopMatrixProcessor implements ILoopMatrixProcessor
{
  private float pivotX;
  private float pivotY;
  private float rotation;
  private float scalingMultiplier;
  
  public PivotRotationLoopMatrixProcessor(float pivotX, float pivotY, float rotationDegree, float scalingMultiplier)
  {
    this.pivotX = pivotX;
    this.pivotY = pivotY;
    this.rotation = rotationDegree * TWO_PI / 360f;
    this.scalingMultiplier = scalingMultiplier;
  }
  
  public void processMatrix(float time, int loopIndex, int loopCount)
  {
    translate(pivotX, pivotY);
    float powerScale = pow(scalingMultiplier, loopIndex);
    scale(powerScale);
    rotate(rotation * loopIndex);
    translate(-pivotX / powerScale, -pivotY / powerScale);
  }
}
