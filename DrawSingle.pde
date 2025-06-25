public interface IDrawSingle
{
  public boolean draw(float time, float scale);
}

public class ShapeDrawSingle implements IDrawSingle
{
  private PGraphics graphics;
  private PShape shape;
  private float widthRatio;
  
  private final float SCALE_MULTIPLIER = 150f;
  
  public ShapeDrawSingle(PShape shape)
  {
    this.shape = shape;
    widthRatio = shape.width / shape.height;
    graphics = createGraphics((int)(SCALE_MULTIPLIER * 1.2f), (int)(SCALE_MULTIPLIER * 1.2f));
  }
  
  public boolean draw(float time, float scale)
  {
    if(time < 0 || time > 1) return false;
    graphics.beginDraw();
    graphics.shapeMode(CENTER);
    if(widthRatio < 1) graphics.shape(shape, graphics.width / 2, graphics.height / 2, SCALE_MULTIPLIER * widthRatio, SCALE_MULTIPLIER);
    else graphics.shape(shape, graphics.width / 2, graphics.height / 2, SCALE_MULTIPLIER, SCALE_MULTIPLIER / widthRatio);
    graphics.endDraw();
    scale(scale);
    image(graphics, 0, 0);
    return true;
  }
}
