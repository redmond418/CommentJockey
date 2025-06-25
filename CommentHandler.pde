import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import java.util.List;

public interface ICommentHandler
{
  public boolean getIsFinished();
  public List<String> getComments();
  public void initialize();
  public void startThread();
  public void quit();
}

public class ThreadCommentHandler implements ICommentHandler
{
  private WebDriver driver;
  private CssElementTextGetThread thread;
  private List<String> texts = new ArrayList<String>();
  private String cssSelector;
  //private List<String> comments = new ArrayList<String>();
  
  public ThreadCommentHandler(WebDriver driver, String cssSelector)
  {
    this.driver = driver;
    this.cssSelector = cssSelector;
  }
  
  public void initialize()
  {
    //driver = new ChromeDriver();
    //driver.get(URL);
    //println("loaded");
  }
  
  public void startThread()
  {
    if(thread != null && !thread.isFinished) 
    {
      //println("still running");
      return;
    }
    thread = new CssElementTextGetThread(cssSelector, driver, texts);
    thread.start();
  }
  
  public void quit()
  {
    driver.quit();
    println("quit");
  }
  
  public boolean getIsFinished() { return thread == null || thread.getIsFinished(); }
  public List<String> getComments()
  {
    if(thread == null || thread.texts == null) return null;
    return thread.texts;
  }
}

public class CssElementTextGetThread extends Thread
{
  public List<String> texts;
  public String cssSelector;
  public WebDriver driver;
  
  private boolean isFinished;
  
  public boolean getIsFinished() { return isFinished; }
  
  public CssElementTextGetThread(String cssSelector, WebDriver driver)
  {
    this.cssSelector = cssSelector;
    this.driver = driver;
    texts = new ArrayList<String>();
  }
  
  public CssElementTextGetThread(String cssSelector, WebDriver driver, List<String> texts)
  {
    this.cssSelector = cssSelector;
    this.driver = driver;
    this.texts = texts;
  }
  
  public void run()
  {
    isFinished = false;
    List<WebElement> elements = driver.findElements(By.cssSelector(cssSelector));
    texts.clear();
    for(WebElement element : elements)
    {
      texts.add(element.getText());
    }
    isFinished = true;
    //println("count: " + elements.size());
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------

public class ThreadEmojiCommentHandler implements ICommentHandler
{
  private WebDriver driver;
  private CssElementNewAttributeGetThread thread;
  private List<String> ids = new ArrayList<String>();
  private List<String> newAttributes = new ArrayList<String>();
  private String cssSelector;
  private String cssId;
  private String cssAttribute;
  //private List<String> comments = new ArrayList<String>();
  
  public ThreadEmojiCommentHandler(WebDriver driver, String cssSelector, String cssId, String cssAttribute)
  {
    this.driver = driver;
    this.cssSelector = cssSelector;
    this.cssId = cssId;
    this.cssAttribute = cssAttribute;
  }
  
  public void initialize()
  {
    //driver = new ChromeDriver();
    //driver.get(URL);
    //println("loaded");
  }
  
  public void startThread()
  {
    if(thread != null && !thread.isFinished) 
    {
      //println("still running");
      return;
    }
    thread = new CssElementNewAttributeGetThread(cssSelector, cssId, cssAttribute, driver, ids, newAttributes);
    thread.start();
  }
  
  public void quit()
  {
    driver.quit();
    println("quit");
  }
  
  public boolean getIsFinished() { return thread == null || thread.getIsFinished(); }
  public List<String> getComments()
  {
    if(thread == null || thread.newAttributes == null) return null;
    return thread.newAttributes;
  }
}

public class CssElementNewAttributeGetThread extends Thread
{
  public List<String> newAttributes;
  public List<String> ids;
  public WebDriver driver;
  
  private String cssSelector;
  private String cssId;
  private String cssAttribute;
  private boolean isFinished;
  
  public boolean getIsFinished() { return isFinished; }
  
  public CssElementNewAttributeGetThread(String cssSelector, String cssId, String cssAttribute, WebDriver driver)
  {
    this.cssSelector = cssSelector;
    this.cssId = cssId;
    this.cssAttribute = cssAttribute;
    this.driver = driver;
    newAttributes = new ArrayList<String>();
    ids = new ArrayList<String>();
  }
  
  public CssElementNewAttributeGetThread(String cssSelector, String cssId, String cssAttribute, WebDriver driver, List<String> ids, List<String> newAttributes)
  {
    this.cssSelector = cssSelector;
    this.cssId = cssId;
    this.cssAttribute = cssAttribute;
    this.driver = driver;
    this.newAttributes = newAttributes;
    this.ids = ids;
  }
  
  public void run()
  {
    isFinished = false;
    List<WebElement> elements = driver.findElements(By.cssSelector(cssSelector));
    int listSize = elements.size();
    int containsFrag = 0b0000;
    newAttributes.clear();
    for(int i = 0; i < listSize && i < 32; i++)
    {
      WebElement element = elements.get(i);
      try
      {
        String id = element.getAttribute(cssId);
        if(ids.contains(id))
        {
          int index = ids.indexOf(id);
          containsFrag += 1 << index;
        }
        else
        {
          ids.add(id);
          containsFrag += 1 << (ids.size() - 1);
          
          String attribute = element.getAttribute(cssAttribute);
          newAttributes.add(attribute);
        }
      }
      catch(StaleElementReferenceException e)
      {
        //println("stale element");
      }
    }
    int digit = ids.size();
    if(digit > 32) digit = 32;
    for(int i = digit - 1; i >= 0; i--)
    {
      if((containsFrag & (1 << i)) == 0)
      {
        ids.remove(i);
      }
    }
    isFinished = true;
    //println("count: " + elements.size());
  }
}
