public class LogoMotionObject implements IMotionObject
{
  private PImage image;
  
  private final float LIFELIME = 2f;
  private final float FADE_DURATION = 0.25f;
  private final Ease FADE_EASE = Ease.IN_OUT_CUBIC;
  private final float SCALE_START = 2f;
  private final Ease SCALE_EASE = Ease.OUT_EXPOHARD;
  
  public LogoMotionObject()
  {
    image = loadImage("Logo.png");
  }
  
  public boolean draw(float time)
  {
    time /= LIFELIME;
    if(time > 1) return false;
    push();
    translate(width / 2, height / 2);
    scale(0.5f);
    float alphaMultiplier = time < 1f - FADE_DURATION ? 1f : FADE_EASE.evaluate((1f - (time + FADE_DURATION - 1f) / FADE_DURATION));
    tint(255, 255 * alphaMultiplier);
    float scale = lerp(SCALE_START, 1f, SCALE_EASE.evaluate(time));
    scale(scale);
    //blendMode(DIFFERENCE);
    image(image, 0, 0);
    pop();
    return true;
  }
  
  //private void pointVertices(Vertex[] vertices){
  //  beginShape();
  //  for(int i = 0; i < vertices.length; i++){
  //    //if(i == 0) vertices[i].point();
  //    //else vertices[i].point(vertices[i - 1].getPos2());
  //  }
  //  endShape();
  //}
}

//public class Vertex{
//  private float posX;
//  private float posY;
//  private float handlePosBehindX;
//  private float handlePosBehindY;
//  private float handlePosFrontX;
//  private float handlePosFrontY;
  
//  //直線のコーナーとしての使用
//  public Vertex(float x, float y){
//    this.posX = x;
//    this.posY = y;
//  }
  
//  //角のないカーブとしての使用
//  public Vertex(float x, float y, float xBehind, float yBehind){
//    this.posX = x;
//    this.posY = y;
//    this.handlePosBehindX = xBehind;
//    this.handlePosBehindY = yBehind;
//    this.handlePosFrontX = -xBehind;
//    this.handlePosFrontY = -yBehind;
//  }
  
//  //角のあるカーブとしての使用
//  public Vertex(float x, float y, float xBehind, float yBehind, float xFront, float yFront){
//    this.posX = x;
//    this.posY = y;
//    this.handlePosBehindX = xBehind;
//    this.handlePosBehindY = yBehind;
//    this.handlePosFrontX = xFront;
//    this.handlePosFrontY = yFront;
//  }
  
//  public void point(){
//    vertex(posX, posY);
//  }
  
//  public void point(PVector pos2){
//    bezierVertex(pos2.x, pos2.y, 
//      posX + handlePosBehindX, posY + handlePosBehindY, 
//      posX, posY);
//  }
  
//  //public PVector getPos2(){
//  //  return PVector.add(pos, handlePosFront);
//  //}
//  public float getPos2X()
//  {
//    return posX + handlePosFrontX;
//  }
  
//  public float getPos2Y()
//  {
//    return posY + handlePosFrontY;
//  }
//}
