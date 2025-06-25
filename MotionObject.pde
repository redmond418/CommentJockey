public interface IMotionObject
{
  //描画に成功したかどうか返ってくる
  boolean draw(float time);
}

public class SequenceMotionObject implements IMotionObject
{
  public IDrawSequence drawSequence;
  public List<IAnchorProcessor> anchorProcessors = new ArrayList<IAnchorProcessor>();
  public List<ISequenceMatrixProcessor> sequenceMatrixProcessors = new ArrayList<ISequenceMatrixProcessor>();
  public ISequenceTimeProcessor sequenceTimeProcessor;
  public IDrawContext drawContext;
  public ILoopContext loopContext;
  
  public boolean draw(float time)
  {
    push();
    boolean drawSuccess = false;
    int loopCount = loopContext.getLoopCount();
    for(IAnchorProcessor processor : anchorProcessors)
    {
      processor.processAnchor();
    }
    for(int i = loopCount - 1; i >= 0; i--)
    {
      push();
      float loopTime = loopContext.getLoopTimeProcessor().getProcessedTime(time, i, loopCount);
      loopContext.getLoopMatrixProcessor().processMatrix(time, i, loopCount);
      for(int j = 0; j < drawSequence.getLoopCount(); j++)
      {
        push();
        float elementTime = sequenceTimeProcessor.getProcessedTime(loopTime, j);
        float scale = 1f;
        for(ISequenceMatrixProcessor processor : sequenceMatrixProcessors)
        {
          processor.processMatrix(elementTime, j);
          scale = processor.processScale(elementTime, scale);
        }
        drawContext.apply(elementTime, j, i);
        var drawResponce = drawSequence.draw(elementTime, j, scale);
        if(drawResponce && !drawSuccess) drawSuccess = true;
        pop();
        resetShader();
      }
      pop();
    }
    pop();
    return drawSuccess;
  }
}

public class SingleMotionObject implements IMotionObject
{
  public IDrawSingle drawSingle;
  public List<IAnchorProcessor> anchorProcessors = new ArrayList<IAnchorProcessor>();
  public IDrawContext drawContext;
  public ILoopContext loopContext;
  
  public boolean draw(float time)
  {
    push();
    boolean drawSuccess = false;
    int loopCount = loopContext.getLoopCount();
    for(IAnchorProcessor processor : anchorProcessors)
    {
      processor.processAnchor();
    }
    for(int i = 0; i < loopCount; i++)
    {
      push();
      float loopTime = loopContext.getLoopTimeProcessor().getProcessedTime(time, i, loopCount);
      loopContext.getLoopMatrixProcessor().processMatrix(time, i, loopCount);
      drawContext.apply(loopTime, 0, i);
      var drawResponce = drawSingle.draw(loopTime, 1);
      if(drawResponce && !drawSuccess) drawSuccess = true;
      pop();
      resetShader();
    }
    pop();
    return drawSuccess;
  }
}

public class AudioSpectrumMotionObject implements IMotionObject
{
  private FFT fft;
  private float[] spectrum;
  
  private final int FFT_BANDS = 64;
  private final float DEFAULT_RADIUS = 150f;
  
  private final float MOTION_POINT_0 = 8.0f;
  private final Ease  MOTION_0_EASE  = Ease.IN_OUT_QUART;
  private final float MOTION_POINT_1 = 8.85f;
  private final float MOTION_POINT_1_RADIUS = 170f;
  private final Ease  MOTION_1_EASE  = Ease.IN_CUBIC;
  private final Ease  MOTION_1_ROTAION_EASE = Ease.OUT_QUART;
  private final float MOTION_POINT_2 = 9.0f;
  private final Ease  MOTION_2_EASE = Ease.OUT_EXPO;
  private final float MOTION_POINT_3 = 10.0f;
  
  public AudioSpectrumMotionObject(PApplet applet, SoundFile bgmFile)
  {
    fft = new FFT(applet, FFT_BANDS);
    spectrum = new float[FFT_BANDS];
    fft.input(bgmFile);
  }
  
  public boolean draw(float time)
  {
    //println(time);
    push();
    stroke(255);
    strokeWeight(5);
    strokeCap(ROUND);
    fft.analyze(spectrum);
    float radius = DEFAULT_RADIUS;
    float angleOffset = 0;
    
    if(MOTION_POINT_0 <= time && time < MOTION_POINT_1)
    {
      float t = norm(time, MOTION_POINT_0, MOTION_POINT_1);
      radius = lerp(DEFAULT_RADIUS, MOTION_POINT_1_RADIUS, MOTION_0_EASE.evaluate(t));
    }
    else if(MOTION_POINT_1 <= time && time < MOTION_POINT_2)
    {
      float t = norm(time, MOTION_POINT_1, MOTION_POINT_2);
      radius = lerp(MOTION_POINT_1_RADIUS, 0, MOTION_1_EASE.evaluate(t));
    }
    else if(MOTION_POINT_2 <= time && time < MOTION_POINT_3)
    {
      float t = norm(time, MOTION_POINT_2, MOTION_POINT_3);
      radius = lerp(0, DEFAULT_RADIUS, MOTION_2_EASE.evaluate(t));
    }
    if(MOTION_POINT_0 <= time && time < MOTION_POINT_2)
    {
      float t = norm(time, MOTION_POINT_0, MOTION_POINT_2);
      angleOffset = lerp(0, 1f, MOTION_1_ROTAION_EASE.evaluate(t));
    }
    
    for(int i = 0; i < FFT_BANDS; i++)
    {
      push();
      float angle = TWO_PI * ((float)i / FFT_BANDS + angleOffset);
      float size = spectrum[i] * 200;
      if(size > 50) size = size / 4f + 37.5f;
      float x = sin(angle);
      float y = cos(angle);
      translate(width / 2, height / 2);
      line(x * (radius - size), y * (radius - size), x * (radius + size), y * (radius + size));
      pop();
    }
    pop();
    return true;
  }
}
