public abstract class BackgroundMotion implements IMotionObject
{
  public abstract void initialize();
}

public class StrobeBackGround extends BackgroundMotion
{
  private final int FRASH_COUNT = 5;
  private final float FRASH_INTERVAL = 1f / 16f;
  private final Ease FRASH_EASE = Ease.OUT_QUINT;
  
  public void initialize()
  {
    
  }
  
  public boolean draw(float time)
  {
    if(time < 0 || time > 1) return true;
    if(time > FRASH_INTERVAL * FRASH_COUNT)
    {
      time = (time - FRASH_INTERVAL * FRASH_COUNT) / (1 - FRASH_INTERVAL * FRASH_COUNT);
    }
    else
    {
      time = (time / FRASH_INTERVAL) % 1;
    }
    background(255 * (1 - FRASH_EASE.evaluate(time)));
    return true;
  }
}

public class DiamondsBackGround extends BackgroundMotion
{
  private int count = 1;
  
  private final float DISTANCE_MAX = 600;
  private final float OUTLINE_MAX = 20;
  private final float SCALE_MAX = 250;
  private final Ease SCALE_EASE = Ease.OUT_EXPOHARD;
  
  public void initialize()
  {
    count = (int)random(1, 5 + 1);
  }
  
  public boolean draw(float time)
  {
    if(time < 0) time = 0;
    else if(time > 1) time = 1;
    else time = SCALE_EASE.evaluate(time);
    push();
    strokeWeight((1 - time) * OUTLINE_MAX);
    stroke(255);
    noFill();
    for(int i = 0; i < count; i++)
    {
      push();
      float offset = count == 1 ? 0 : (i / (count - 1f) * DISTANCE_MAX - DISTANCE_MAX / 2f);
      translate(offset + width / 2, height / 2);
      rotate(QUARTER_PI);
      rect(0, 0, time * SCALE_MAX, time * SCALE_MAX);
      pop();
    }
    pop();
    return true;
  }
}

public class CirclesBackGround extends BackgroundMotion
{
  private float[] positionsX = new float[16];
  private float[] positionsY = new float[16];
  
  private final int COUNT = 16;
  private final float DELAY = 1f / 32f;
  private final float OUTLINE_MAX = 20;
  private final float SCALE_MAX = 100;
  private final Ease SCALE_EASE = Ease.OUT_EXPO;
  
  public void initialize()
  {
    if(positionsX == null) positionsX = new float[COUNT];
    if(positionsY == null) positionsY = new float[COUNT];
    for(int i = 0; i < COUNT; i++)
    {
      positionsX[i] = random(0, width);
      positionsY[i] = random(0, height);
    }
  }
  
  public boolean draw(float time)
  {
    //if(time < 0) time = 0;
    //else if(time > 1) time = 1;
    //else time = SCALE_EASE.evaluate(time);
    push();
    stroke(255);
    noFill();
    float scaledTime = time / (1 - DELAY * COUNT);
    for(int i = 0; i < COUNT; i++)
    {
      push();
      translate(positionsX[i], positionsY[i]);
      float loopTime = scaledTime - i * DELAY;
      if(loopTime < 0) loopTime = 0;
      else if(loopTime > 1) loopTime = 1;
      else loopTime = SCALE_EASE.evaluate(loopTime);
      strokeWeight((1 - loopTime) * OUTLINE_MAX);
      circle(0, 0, loopTime * SCALE_MAX);
      pop();
    }
    pop();
    return true;
  }
}
