public Shaders shaders = new Shaders();

public class Shaders
{
  private PShader loopOutlineShader;
  public PShader getLoopOutlineShader()
  {
    if(loopOutlineShader == null) loopOutlineShader = loadShader("OutlineShader.frag");
    return loopOutlineShader;
  }
  private PShader alphaInverseShader;
  public PShader getAlphaInverseShader()
  {
    if(alphaInverseShader == null) alphaInverseShader = loadShader("AlphaInverseShader.frag");
    return alphaInverseShader;
  }
  private PShader gradientShader;
  public PShader getGradientShader()
  {
    if(gradientShader == null) gradientShader = loadShader("GradientShader.frag");
    return gradientShader;
  }
  private PShader stripeShader;
  public PShader getStripeShader()
  {
    if(stripeShader == null) stripeShader = loadShader("StripeShader.frag");
    return stripeShader;
  }
}
