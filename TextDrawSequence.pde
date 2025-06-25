public interface IDrawSequence
{
  public boolean draw(float time, int index, float scale);
  public int getLoopCount();
}

public class TextDrawSequence implements IDrawSequence
{
  private String text;
  private int textLength;
  
  final int TEXT_SIZE = 64;
  
  public TextDrawSequence(String text)
  {
    this.text = text;
    textLength = text.length();
  }
  
  //描画に成功したかどうか返ってくる
  public boolean draw(float time, int index, float scale)
  {
    if(time < 0 || time > 1 || index < 0 || index >= text.length()) return false;
    textSize(scale * TEXT_SIZE);
    text(text.charAt(index), 0, 0);
    return true;
  }
  
  public int getLoopCount()
  {
    return textLength;
  }
}
