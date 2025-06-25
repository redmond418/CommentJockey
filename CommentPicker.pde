import org.openqa.selenium.WebElement;
import java.util.function.Consumer;
import org.openqa.selenium.StaleElementReferenceException;

//ICommentHandlerの出力から新規コメントを取り出す(途中で要素数が減ることは考慮に入れない)
public class CommentPicker
{
  public ICommentHandler handler;
  public Consumer<String> pickEvent;
  private int previousCommentsCount = 0;
  private boolean waiting = false;
  private int forcePickIndex = 0;
  
  public CommentPicker(ICommentHandler handler, Consumer<String> pickEvent)
  {
    this.handler = handler;
    this.pickEvent = pickEvent;
  }
  
  public void initialize()
  {
    handler.initialize();
  }
  
  public void startAcquisition()
  {
    handler.startThread();
    waiting = true;
  }
  
  public void checkNewComments()
  {
    if(!waiting || !handler.getIsFinished()) return;
    List<String> list = handler.getComments();
    int getCount = list.size() - previousCommentsCount;
    for(int i = 0; i < getCount; i++)
    {
      String text = list.get(i);
      if(text == null || text == "") continue;
      if(pickEvent != null) pickEvent.accept(text);
    }
    previousCommentsCount = list.size();
    if(getCount > 0) forcePickIndex = 0;
    waiting = false;
  }
  
  public void forcePickComments(int count)
  {
    List<String> list = handler.getComments();
    if(list == null || list.size() == 0) return;
    int listSize = list.size();
    if(previousCommentsCount != listSize)
    {
      previousCommentsCount = listSize;
      forcePickIndex = 0;
    }
    for(int i = 0; i < count; i++)
    {
      String text = list.get(forcePickIndex);
      if(text == null || text == "") 
      {
        forcePickIndex = 0;
        text = list.get(forcePickIndex);
        if(text == null || text == "") continue;
      }
      if(pickEvent != null) pickEvent.accept(text);
      forcePickIndex++;
      if(forcePickIndex >= listSize) forcePickIndex = 0;
    }
    println();
  }
  
  public void quit()
  {
    handler.quit();
  }
}

//ICommentHandlerの出力から新規絵文字を取り出す(途中で要素数が減ることも考慮に入れる)
public class EmojiPicker
{
  public ICommentHandler handler;
  public Consumer<PShape> pickEvent;
  private HashMap<String, PShape> emojiMap = new HashMap<String, PShape>();
  private boolean waiting = false;
  
  public EmojiPicker(ICommentHandler handler, Consumer<PShape> pickEvent)
  {
    this.handler = handler;
    this.pickEvent = pickEvent;
  }
  
  public void initialize()
  {
    handler.initialize();
  }
  
  public void startAcquisition()
  {
    handler.startThread();
    waiting = true;
  }
  
  public void checkNewEmoji()
  {
    if(!waiting || !handler.getIsFinished()) 
    {
      return;
    }
    List<String> list = handler.getComments();
    for(String source : list)
    {
      PShape emojiShape;
      if(emojiMap.containsKey(source))
      {
        emojiShape = emojiMap.get(source);
      }
      else
      {
        emojiShape = loadShape(source);
        emojiShape.disableStyle();
        emojiMap.put(source, emojiShape);
      }
      if(pickEvent != null) pickEvent.accept(emojiShape);
    }
    waiting = false;
  }
  
  public void quit()
  {
    handler.quit();
  }
}
