public class BackgroundsHolder
{
  private BackgroundMotion[] backgrounds = 
  {
    new StrobeBackGround(),
    new DiamondsBackGround(),
    new CirclesBackGround(),
  };
  private int currentIndex = -1;
  private float startTime;
  
  public void draw(float time)
  {
    if(currentIndex < 0 || currentIndex >= backgrounds.length) return;
    backgrounds[currentIndex].draw(time - startTime);
  }
  
  public void setRandom(float time)
  {
    if(currentIndex < 0) currentIndex = (int)random(backgrounds.length);
    else currentIndex = (currentIndex + (int)random(1, backgrounds.length)) % backgrounds.length;
    startTime = time;
    backgrounds[currentIndex].initialize();
  }
}
