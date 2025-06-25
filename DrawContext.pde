public interface IDrawContext
{
  void apply(float time, int index, int loopIndex);
}

public class LoopShaderDrawContext implements IDrawContext
{
  private color fillColor;
  private PShader loopShader;
  
  public LoopShaderDrawContext(color fillColor, PShader shader)
  {
    this.fillColor = fillColor;
    loopShader = shader;
  }
  
  public void apply(float time, int index, int loopIndex)
  {
    fill(fillColor);
    if(loopIndex > 0 && loopShader != null)
    {
      shader(loopShader);
    }
  }
}

public class FadeDrawContext implements IDrawContext
{
  private color fillColor;
  
  private final float FADE_DURATION = 0.25f;
  private final Ease FADE_EASE = Ease.IN_OUT_CUBIC;
  
  public FadeDrawContext(color fillColor)
  {
    this.fillColor = fillColor;
  }
  
  public void apply(float time, int index, int loopIndex)
  {
    if(time > 1 || time < 0) return;
    float alphaMultiplier = time < 1f - FADE_DURATION ? 1f : FADE_EASE.evaluate((1f - (time + FADE_DURATION - 1f) / FADE_DURATION));
    color alphaMultiplied = (fillColor & 0x00FFFFFF) + ((byte)(((fillColor >> 24) & 0xFF) * alphaMultiplier) << 24);
    fill(alphaMultiplied);
  }
}

public class FadeShaderDrawContext implements IDrawContext
{
  private color fillColor;
  private PShader shader;
  
  private final float FADE_DURATION = 0.25f;
  private final Ease FADE_EASE = Ease.IN_OUT_CUBIC;
  
  public FadeShaderDrawContext(color fillColor, PShader shader)
  {
    this.fillColor = fillColor;
    this.shader = shader;
  }
  
  public void apply(float time, int index, int loopIndex)
  {
    if(time > 1 || time < 0) return;
    float alphaMultiplier = time < 1f - FADE_DURATION ? 1f : FADE_EASE.evaluate((1f - (time + FADE_DURATION - 1f) / FADE_DURATION));
    color alphaMultiplied = (fillColor & 0x00FFFFFF) + ((byte)(((fillColor >> 24) & 0xFF) * alphaMultiplier) << 24);
    fill(alphaMultiplied);
    shader(shader);
  }
}

public class PropertyShaderDrawContext implements IDrawContext
{
  private color fillColor;
  private PShader shader;
  private Ease ease;
  
  public PropertyShaderDrawContext(color fillColor, PShader shader, Ease ease)
  {
    this.fillColor = fillColor;
    this.shader = shader;
    this.ease = ease;
  }
  
  public void apply(float time, int index, int loopIndex)
  {
    if(time > 1 || time < 0) return;
    fill(fillColor);
    shader.set("time", ease.evaluate(time));
    shader.set("resolution", getOriginWidth(), getOriginHeight());
    shader(shader);
  }
}

public class FadeTintDrawContext implements IDrawContext
{
  private final float FADE_DURATION = 0.25f;
  private final Ease FADE_EASE = Ease.IN_OUT_CUBIC;
  
  public void apply(float time, int index, int loopIndex)
  {
    if(time > 1 || time < 0) return;
    float alphaMultiplier = time < 1f - FADE_DURATION ? 1f : FADE_EASE.evaluate((1f - (time + FADE_DURATION - 1f) / FADE_DURATION));
    //color alphaMultiplied = (fillColor & 0x00FFFFFF) + ((byte)(((fillColor >> 24) & 0xFF) * alphaMultiplier) << 24);
    tint(255, 255 * alphaMultiplier);
  }
}
