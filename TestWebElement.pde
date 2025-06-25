import org.openqa.selenium.*;

//文字情報だけ持ってる
public class TestWebElement implements WebElement
{
  private String text;
  
  public TestWebElement(String text)
  {
    this.text = text;
  }

  @Override
  public String getText() {
    return text;
  }
  
  
  
  @Override
  public void click() {
    throw new UnsupportedOperationException();
  }

  @Override
  public void submit() {
    throw new UnsupportedOperationException();
  }

  @Override
  public void sendKeys(CharSequence... keysToSend) {
    throw new UnsupportedOperationException();
  }

  @Override
  public void clear() {
    throw new UnsupportedOperationException();
  }

  @Override
  public String getTagName() {
    throw new UnsupportedOperationException();
  }

  @Override
  public String getAttribute(String name) {
    throw new UnsupportedOperationException();
  }

  @Override
  public boolean isSelected() {
    throw new UnsupportedOperationException();
  }

  @Override
  public boolean isEnabled() {
    throw new UnsupportedOperationException();
  }

  @Override
  public List<WebElement> findElements(By by) {
    throw new UnsupportedOperationException();
  }

  @Override
  public WebElement findElement(By by) {
    throw new UnsupportedOperationException();
  }

  @Override
  public boolean isDisplayed() {
    throw new UnsupportedOperationException();
  }

  @Override
  public Point getLocation() {
    throw new UnsupportedOperationException();
  }

  @Override
  public Dimension getSize() {
    throw new UnsupportedOperationException();
  }

  @Override
  public Rectangle getRect() {
    throw new UnsupportedOperationException();
  }

  @Override
  public String getCssValue(String propertyName) {
    throw new UnsupportedOperationException();
  }

  @Override
  public <X> X getScreenshotAs(OutputType<X> outputType) throws WebDriverException {
    throw new UnsupportedOperationException();
  }
}
