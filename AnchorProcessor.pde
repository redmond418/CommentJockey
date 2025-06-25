public interface IAnchorProcessor
{
  void processAnchor();
}

public class CenterAnchorProcessor implements IAnchorProcessor
{
  private float centerX;
  private float centerY;
  
  public CenterAnchorProcessor(float centerX, float centerY)
  {
    this.centerX = centerX;
    this.centerY = centerY;
  }
  
  public void processAnchor()
  {
    translate(centerX, centerY);
  }
}

public class ShearYAnchorProcessor implements IAnchorProcessor
{
  private float angle;
  
  public ShearYAnchorProcessor(float degree)
  {
    angle = degree * TWO_PI / 360f;
  }
  
  public void processAnchor()
  {
    shearY(angle);
  }
}

public class RotationAnchorProcessor implements IAnchorProcessor
{
  private float angle;
  
  public RotationAnchorProcessor(float degree)
  {
    angle = degree * TWO_PI / 360f;
  }
  
  public void processAnchor()
  {
    rotate(angle);
  }
}

public class ScaleAnchorProcessor implements IAnchorProcessor
{
  private float scaleX;
  private float scaleY;
  
  public ScaleAnchorProcessor(float scale)
  {
    this.scaleX = scale;
    this.scaleY = scale;
  }
  
  public ScaleAnchorProcessor(float scaleX, float scaleY)
  {
    this.scaleX = scaleX;
    this.scaleY = scaleY;
  }
  
  public void processAnchor()
  {
    scale(scaleX, scaleY);
  }
}
