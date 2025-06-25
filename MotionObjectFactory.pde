public interface IMotionObjectFactory
{
  public IMotionObject createMotionObject();
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

public abstract class SequenceMotionObjectFactory implements IMotionObjectFactory
{
  protected abstract void setRandomSeed();
  protected abstract void setDrawSequence(SequenceMotionObject sequenceMotionObject);
  protected abstract void addAnchorProcessor(SequenceMotionObject sequenceMotionObject);
  protected abstract void setLoopContext(SequenceMotionObject sequenceMotionObject);
  protected abstract void addSequenceMatrixProcessor(SequenceMotionObject sequenceMotionObject);
  protected abstract void setSequenceTimeProcessor(SequenceMotionObject sequenceMotionObject);
  protected abstract void setDrawContext(SequenceMotionObject sequenceMotionObject);
  
  public IMotionObject createMotionObject()
  {
    SequenceMotionObject motionObj = new SequenceMotionObject();
    int seed = (int)random(Integer.MIN_VALUE, Integer.MAX_VALUE);
    addAnchorProcessor(motionObj);
    setRandomSeed();
    setDrawSequence(motionObj);
    setLoopContext(motionObj);
    addSequenceMatrixProcessor(motionObj);
    setSequenceTimeProcessor(motionObj);
    setDrawContext(motionObj);
    randomSeed(seed);
    return motionObj;
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

public class NormalTextMotionObjectFactory extends SequenceMotionObjectFactory
{
  private String text;
  private int textLength;
  private IDrawContext drawContext;
  private boolean isRandomSeedValid = false;
  private int randomSeed;
  
  private final float ANCHOR_MARGIN = 30f;
  private final float ANCHOR_MAX_ANGLE = 45f;
  private final float ANCHOR_MAX_SHEAR = 45f;
  
  public NormalTextMotionObjectFactory() {}
  
  public NormalTextMotionObjectFactory(IDrawContext drawContext)
  {
    this.drawContext = drawContext;
    this.isRandomSeedValid = false;
  }
  
  public NormalTextMotionObjectFactory(IDrawContext drawContext, boolean isRandomSeedValid)
  {
    this.drawContext = drawContext;
    this.isRandomSeedValid = isRandomSeedValid;
  }
  
  public void setText(String text)
  {
    this.text = text;
    textLength = text.length();
    if(isRandomSeedValid)
    {
      randomSeed = RandomSeed.fromString(text);
    }
  }
  
  public void setDrawContext(IDrawContext drawContext)
  {
    this.drawContext = drawContext;
  }
  
  protected void setRandomSeed()
  {
    if(!isRandomSeedValid) return;
    randomSeed(randomSeed);
  }
  
  protected void setDrawSequence(SequenceMotionObject sequenceMotionObject)
  {
    sequenceMotionObject.drawSequence = new TextDrawSequence(text);
  }
  
  protected void addAnchorProcessor(SequenceMotionObject sequenceMotionObject)
  {
    sequenceMotionObject.anchorProcessors.add(new CenterAnchorProcessor(random(ANCHOR_MARGIN * textLength, width - ANCHOR_MARGIN * textLength), random(ANCHOR_MARGIN * textLength, height - ANCHOR_MARGIN * textLength)));
    
    float random = random(100);
    random -= 50f;
    if(random < 0) sequenceMotionObject.anchorProcessors.add(new RotationAnchorProcessor(random(-ANCHOR_MAX_ANGLE, ANCHOR_MAX_ANGLE)));
    else           sequenceMotionObject.anchorProcessors.add(new ShearYAnchorProcessor(random(-ANCHOR_MAX_SHEAR, ANCHOR_MAX_SHEAR)));
    
    //sequenceMotionObject.anchorProcessors.add(new ScaleAnchorProcessor(1f / textLength + 0.5f));
  }
  
  protected void setLoopContext(SequenceMotionObject sequenceMotionObject)
  {
    if(textLength >= 18)
    {
      sequenceMotionObject.loopContext = new OnceLoopContext();
      return;
    }
    
    float random0 = random(100f);
    random0 -= 70f;
    if(random0 < 0) sequenceMotionObject.loopContext = new OnceLoopContext();
    else
    {
      //2^n分音符でとりあえず
      int loopCount = (1 << (int)random(2, 5)) + 1;
      
      ILoopMatrixProcessor loopMatrixProcessor;
      float scale = min(random(0.8f, 1.3f), 1f);
      float random1 = random(100f);
      random1 -= 50f;
      if(random1 < 0) 
      {
        float angle = random(PI * 1f / 6f, PI * 5 / 6f);
        if(random(-1, 1) < 0)angle *= -1;
        float magnitude = random(10f, 20f);
        loopMatrixProcessor = new OffsetLoopMatrixProcessor(cos(angle) * magnitude, sin(angle) * magnitude, scale);
      }
      else
      {
        float pivotX = random(200, 400);
        if(random(-1, 1) < 0) pivotX *= -1;
        float pivotY = random(-300, 300);
        float degree = random(2f, 10f);
        loopMatrixProcessor = new PivotRotationLoopMatrixProcessor(pivotX, pivotY, degree, scale);
      }
      
      ILoopTimeProcessor loopTimeProcessor;
      float random2 = random(100f);
      random2 -= 101f;
      if(random2 < 0)
      {
        loopTimeProcessor = new DelayedLoopTimeProcessor(0.25f / (loopCount - 1));
      }
      else
      {
        loopTimeProcessor = null;
      }
      
      sequenceMotionObject.loopContext = new LoopContext(loopCount, loopMatrixProcessor, loopTimeProcessor);
    }
  }
  
  protected void addSequenceMatrixProcessor(SequenceMotionObject sequenceMotionObject)
  {
    if(!(sequenceMotionObject.loopContext instanceof OnceLoopContext) && random(100) < 30f)
    {
      sequenceMotionObject.sequenceMatrixProcessors.add(new SimpleTextSequenceMatrixProcessor(text));
      return;
    }
    
    float random0 = random(100);
    if(0 > (random0 -= 33f))
    {
      sequenceMotionObject.sequenceMatrixProcessors.add(new ConvergenceTextSequenceMatrixProcessor(text));
    }
    else if(0 > (random0 -= 33f))
    {
      sequenceMotionObject.sequenceMatrixProcessors.add(new AlternatingTextSequenceMatrixProcessor(text));
    }
    else if(0 > (random0 -= 17f))
    {
      sequenceMotionObject.sequenceMatrixProcessors.add(new ExtendTextSequenceMatrixProcessor(text));
    }
    else// if(0 > (random0 -= 17f))
    {
      sequenceMotionObject.sequenceMatrixProcessors.add(new ExtendFromFirstTextSequenceMatrixProcessor(text));
    }
    
    float random1 = random(100);
    if(0 > (random1 -= 25f))
    {
      sequenceMotionObject.sequenceMatrixProcessors.add(new ScaleBackTextSequenceMatrixProcessor(3f));
    }
    else if(0 > (random1 -= 25f))
    {
      sequenceMotionObject.sequenceMatrixProcessors.add(new ScaleXYBackTextSequenceMatrixProcessor(0.05f, 5f));
    }
    
    float random2 = random(100);
    if(0 > (random2 -= 25f))
    {
      float angle = random(PI / 6f);
      sequenceMotionObject.sequenceMatrixProcessors.add(new RotationTextSequenceMatrixProcessor(textLength, -angle, angle));
    }
    else if(0 > (random2 -= 25f))
    {
      float angle = random(PI / 4f);
      sequenceMotionObject.sequenceMatrixProcessors.add(new RotationBackTextSequenceMatrixProcessor(textLength, -angle, angle));
    }
  }
  
  protected void setSequenceTimeProcessor(SequenceMotionObject sequenceMotionObject)
  {
    float random = random(100);
    if(0 > (random -= 33f))
    {
      sequenceMotionObject.sequenceTimeProcessor = new SimpleSequenceTimeProcessor();
      return;
    }
    else if(0 > (random -= 33f))
    {
      sequenceMotionObject.sequenceTimeProcessor = new DelayedSequenceTimeProcessor(1f / ((1 << (int)random(3, 6)) + 1));
    }
    else
    {
      sequenceMotionObject.sequenceTimeProcessor = new RandomDelayedSequenceTimeProcessor(textLength, 1f / ((1 << (int)random(3, 6)) + 1));
    }
  }
  
  protected void setDrawContext(SequenceMotionObject sequenceMotionObject)
  {
    if(!(sequenceMotionObject.loopContext instanceof OnceLoopContext))
    {
      sequenceMotionObject.drawContext = new LoopShaderDrawContext(#ffffff, shaders.getLoopOutlineShader());
      return;
    }
    
    float random = random(100);
    if(0 > (random -= 60f) && drawContext != null)
    {
      sequenceMotionObject.drawContext = drawContext;
    }
    else if(0 > (random -= 13f))
    {
      sequenceMotionObject.drawContext = new FadeShaderDrawContext(#ffffff, shaders.getAlphaInverseShader());
    }
    else if(0 > (random -= 13f))
    {
      sequenceMotionObject.drawContext = new FadeShaderDrawContext(#ffffff, shaders.getGradientShader());
    }
    else
    {
      sequenceMotionObject.drawContext = new PropertyShaderDrawContext(#ffffff, shaders.getStripeShader(), Ease.IN_EXPO);
    }
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

public abstract class SingleMotionObjectFactory implements IMotionObjectFactory
{
  protected abstract void setRandomSeed();
  protected abstract void setDrawSingle(SingleMotionObject sequenceMotionObject);
  protected abstract void addAnchorProcessor(SingleMotionObject sequenceMotionObject);
  protected abstract void setLoopContext(SingleMotionObject sequenceMotionObject);
  protected abstract void setDrawContext(SingleMotionObject sequenceMotionObject);
  
  public IMotionObject createMotionObject()
  {
    SingleMotionObject motionObj = new SingleMotionObject();
    int seed = (int)random(Integer.MIN_VALUE, Integer.MAX_VALUE);
    addAnchorProcessor(motionObj);
    setRandomSeed();
    setDrawSingle(motionObj);
    setLoopContext(motionObj);
    setDrawContext(motionObj);
    randomSeed(seed);
    return motionObj;
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

public class ShapeMotionObjectFactory extends SingleMotionObjectFactory
{
  private PShape shape;
  private IDrawContext drawContext;
  private boolean isRandomSeedValid = false;
  private int randomSeed;
  
  private final float ANCHOR_MARGIN = 80f;
  private final float ANCHOR_MAX_ANGLE = 45f;
  private final float ANCHOR_MAX_SHEAR = 45f;
  
  public ShapeMotionObjectFactory() {}
  
  public ShapeMotionObjectFactory(IDrawContext drawContext)
  {
    this.drawContext = drawContext;
    this.isRandomSeedValid = false;
  }
  
  public ShapeMotionObjectFactory(IDrawContext drawContext, int randomSeed)
  {
    this.drawContext = drawContext;
    this.isRandomSeedValid = true;
    this.randomSeed = randomSeed;
  }
  
  public void setShape(PShape shape)
  {
    this.shape = shape;
  }
  
  public void setDrawContext(IDrawContext drawContext)
  {
    this.drawContext = drawContext;
  }
  
  protected void setRandomSeed()
  {
    if(!isRandomSeedValid) return;
    randomSeed(randomSeed);
  }
  
  protected void setDrawSingle(SingleMotionObject sequenceMotionObject)
  {
    sequenceMotionObject.drawSingle = new ShapeDrawSingle(shape);
  }
  
  protected void addAnchorProcessor(SingleMotionObject sequenceMotionObject)
  {
    sequenceMotionObject.anchorProcessors.add(new CenterAnchorProcessor(random(ANCHOR_MARGIN, width - ANCHOR_MARGIN), random(ANCHOR_MARGIN, height - ANCHOR_MARGIN)));
    
    float random = random(100);
    random -= 50f;
    if(random < 0) sequenceMotionObject.anchorProcessors.add(new RotationAnchorProcessor(random(-ANCHOR_MAX_ANGLE, ANCHOR_MAX_ANGLE)));
    else           sequenceMotionObject.anchorProcessors.add(new ShearYAnchorProcessor(random(-ANCHOR_MAX_SHEAR, ANCHOR_MAX_SHEAR)));
    
    sequenceMotionObject.anchorProcessors.add(new ScaleAnchorProcessor(random(0.5f, 1f)));
  }
  
  protected void setLoopContext(SingleMotionObject sequenceMotionObject)
  {
    float random0 = random(100f);
    random0 -= 50f;
    if(random0 < 0) sequenceMotionObject.loopContext = new OnceLoopContext();
    else
    {
      //2^n分音符でとりあえず
      int loopCount = (1 << (int)random(2, 5)) + 1;
      
      ILoopMatrixProcessor loopMatrixProcessor;
      float scale = min(random(0.8f, 1.3f), 1f);
      float random1 = random(100f);
      random1 -= 50f;
      if(random1 < 0) 
      {
        float angle = random(PI * 1f / 6f, PI * 5 / 6f);
        if(random(-1, 1) < 0)angle *= -1;
        float magnitude = random(10f, 20f);
        loopMatrixProcessor = new OffsetLoopMatrixProcessor(cos(angle) * magnitude, sin(angle) * magnitude, scale);
      }
      else
      {
        float pivotX = random(200, 400);
        if(random(-1, 1) < 0) pivotX *= -1;
        float pivotY = random(-300, 300);
        float degree = random(2f, 10f);
        loopMatrixProcessor = new PivotRotationLoopMatrixProcessor(pivotX, pivotY, degree, scale);
      }
      
      ILoopTimeProcessor loopTimeProcessor;
      float random2 = random(100f);
      random2 -= 101f;
      if(random2 < 0)
      {
        loopTimeProcessor = new DelayedLoopTimeProcessor(0.25f / (loopCount - 1));
      }
      else
      {
        loopTimeProcessor = null;
      }
      
      sequenceMotionObject.loopContext = new LoopContext(loopCount, loopMatrixProcessor, loopTimeProcessor);
    }
  }
  
  protected void setDrawContext(SingleMotionObject sequenceMotionObject)
  {
    float random = random(100);
    random -= 101f;
    if(drawContext != null && random < 0)
    {
      sequenceMotionObject.drawContext = drawContext;
    }
    else
    {
      
    }
  }
}
