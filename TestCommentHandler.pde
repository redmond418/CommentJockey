import org.openqa.selenium.WebElement;

public class TestCommentHandler implements ICommentHandler
{
  final private String[] TEST_COMMENTS = 
  {
    "88888888888888", 
    "8888888", 
    "wwwwwwwwwww",
    "草",
    "SUGEEEEE",
    "うぽつ",
    "age",
    "やったぜ",
    "バナナのナス、バナナス"
  };
  final private int FIRST_COMMENT_COUNT = 2;
  final private int ADD_COMMENT_COUNT_MIN = 1;
  final private int ADD_COMMENT_COUNT_MAX = 3;
  
  private List<String> comments = new ArrayList<String>();
  
  public boolean getIsFinished() { return true; }
  
  public List<String> getComments()
  {
    addComments((int)random(ADD_COMMENT_COUNT_MIN, ADD_COMMENT_COUNT_MAX + 1));
    return comments;
  }
  
  public void initialize()
  {
    addComments(FIRST_COMMENT_COUNT);
  }
  public void startThread() {}
  public void quit() {}
  
  private void addComments(int count)
  {
    for(int i = 0; i < count; i++)
    {
      comments.add(0, TEST_COMMENTS[(int)random(TEST_COMMENTS.length)]);
    }
  }
}
