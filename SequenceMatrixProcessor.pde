public interface ISequenceMatrixProcessor
{
  void processMatrix(float time, int index);
  float processScale(float time, float scale);
}

public final float TEXT_SIZE_RATIO = 0.5f;

public float[] getTextOffsets(String text)
{
  int length = text.length();
  float[] offsets = new float[text.length()];
  float center = length / 2f;
  float centerWidth = length % 2 == 0 ? 0 : textWidth(text.charAt(length / 2)) / 2f;
  float leftOffset = -centerWidth * TEXT_SIZE_RATIO;
  for(int i = (int)(center - 0.6f); i >= 0; i--)
  {
    float charWidth = textWidth(text.charAt(i)) * TEXT_SIZE_RATIO;
    offsets[i] = leftOffset - charWidth / 2f;
    leftOffset -= charWidth;
  }
  float rightOffset = centerWidth * TEXT_SIZE_RATIO;
  for(int i = (int)(center + 0.6f); i < length; i++)
  {
    float charWidth = textWidth(text.charAt(i)) * TEXT_SIZE_RATIO;
    offsets[i] = rightOffset + charWidth / 2f;
    rightOffset += charWidth;
  }
  //printArray(offsets);
  return offsets;
}

public class SimpleTextSequenceMatrixProcessor implements ISequenceMatrixProcessor
{
  protected float[] offsets;
  
  public SimpleTextSequenceMatrixProcessor(String text)
  {
    offsets = getTextOffsets(text);
  }
  
  public void processMatrix(float time, int index)
  {
    if(index < 0 || index >= offsets.length) return;
    translate(offsets[index], 0);
  }
  
  public float processScale(float time, float scale)
  {
    return scale;
  }
}

public class AlternatingTextSequenceMatrixProcessor extends SimpleTextSequenceMatrixProcessor
{
  private final float START_OFFSET_Y = 120f;
  private final Ease MOVE_EASE = Ease.OUT_EXPOHARD;
  
  public AlternatingTextSequenceMatrixProcessor(String text)
  {
    super(text);
  }
  
  @Override
  public void processMatrix(float time, int index)
  {
    if(index < 0 || index >= offsets.length) return;
    translate(offsets[index], START_OFFSET_Y * (1f - MOVE_EASE.evaluate(time)) * (index % 2 == 0 ? 1 : -1));
  }
}

public class ConvergenceTextSequenceMatrixProcessor extends SimpleTextSequenceMatrixProcessor
{
  private final float START_OFFSET_LENGTH = 100f;
  private final Ease MOVE_EASE = Ease.OUT_EXPOHARD;
  private float[] angles;
  
  public ConvergenceTextSequenceMatrixProcessor(String text)
  {
    super(text);
    angles = new float[text.length()];
    for(int i = 0; i < angles.length; i++)
    {
      angles[i] = random(TWO_PI);
    }
  }
  
  @Override
  public void processMatrix(float time, int index)
  {
    if(index < 0 || index >= offsets.length) return;
    float t = (1f - MOVE_EASE.evaluate(time));
    translate(offsets[index] + START_OFFSET_LENGTH * cos(angles[index]) * t, START_OFFSET_LENGTH * sin(angles[index]) * t);
  }
}

public class ExtendTextSequenceMatrixProcessor extends SimpleTextSequenceMatrixProcessor
{
  private final Ease MOVE_EASE = Ease.OUT_EXPOHARD;
  
  public ExtendTextSequenceMatrixProcessor(String text)
  {
    super(text);
  }
  
  @Override
  public void processMatrix(float time, int index)
  {
    if(index < 0 || index >= offsets.length) return;
    translate(offsets[index] * MOVE_EASE.evaluate(time), 0);
  }
}

public class ExtendFromFirstTextSequenceMatrixProcessor extends SimpleTextSequenceMatrixProcessor
{
  private final Ease MOVE_EASE = Ease.OUT_EXPOHARD;
  
  public ExtendFromFirstTextSequenceMatrixProcessor(String text)
  {
    super(text);
  }
  
  @Override
  public void processMatrix(float time, int index)
  {
    if(index < 0 || index >= offsets.length) return;
    translate(lerp(offsets[0], offsets[index], MOVE_EASE.evaluate(time)), 0);
  }
}

public class ScaleBackTextSequenceMatrixProcessor implements ISequenceMatrixProcessor
{
  private float scale;
  
  private final Ease SCALE_EASE = Ease.OUT_EXPOHARD;
  
  public ScaleBackTextSequenceMatrixProcessor(float scale)
  {
    this.scale = scale;
  }
  
  public void processMatrix(float time, int index)
  {
    //do nothing
  }
  
  public float processScale(float time, float scale)
  {
    float t = SCALE_EASE.evaluate(time);
    return scale * lerp(this.scale, 1, t);
  }
}

public class ScaleXYBackTextSequenceMatrixProcessor implements ISequenceMatrixProcessor
{
  private float scaleX;
  private float scaleY;
  
  private final Ease SCALE_EASE = Ease.OUT_EXPOHARD;
  
  public ScaleXYBackTextSequenceMatrixProcessor(float scaleX, float scaleY)
  {
    this.scaleX = scaleX;
    this.scaleY = scaleY;
  }
  
  public void processMatrix(float time, int index)
  {
    float t = SCALE_EASE.evaluate(time);
    scale(lerp(scaleX, 1, t), lerp(scaleY, 1, t));
  }
  
  public float processScale(float time, float scale)
  {
    return scale;
  }
}

public class RotationTextSequenceMatrixProcessor implements ISequenceMatrixProcessor
{
  private float[] angles;
  
  private final Ease ROTATE_EASE = Ease.OUT_QUINT;
  
  public RotationTextSequenceMatrixProcessor(int length, float minAngle, float maxAngle)
  {
    angles = new float[length];
    for(int i = 0; i < length; i++)
    {
      angles[i] = random(minAngle, maxAngle);
    }
  }
  
  public void processMatrix(float time, int index)
  {
    if(index < 0 || index >= angles.length) return;
    float t = ROTATE_EASE.evaluate(time);
    rotate(angles[index] * (1f - t));
  }
  
  public float processScale(float time, float scale)
  {
    return scale;
  }
}

public class RotationBackTextSequenceMatrixProcessor implements ISequenceMatrixProcessor
{
  private float[] angles;
  
  private final Ease ROTATE_EASE = Ease.OUT_QUINT;
  
  public RotationBackTextSequenceMatrixProcessor(int length, float minAngle, float maxAngle)
  {
    angles = new float[length];
    for(int i = 0; i < length; i++)
    {
      angles[i] = random(minAngle, maxAngle);
    }
  }
  
  public void processMatrix(float time, int index)
  {
    if(index < 0 || index >= angles.length) return;
    float t = ROTATE_EASE.evaluate(time);
    rotate(angles[index] * t);
  }
  
  public float processScale(float time, float scale)
  {
    return scale;
  }
}
