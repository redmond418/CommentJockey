import org.openqa.selenium.chrome.ChromeDriver;

private final String URL = "https://www.commentscreen.com/comments?id=BWGNhpln77G8bzCutraE";
private final String CSS_SELECTOR_COMMENT = ".gQKzFR";
private final String CSS_SELECTOR_EMOJI = "body > img";
private final String CSS_EMOJI_ATTRIBUTE_ID = "id";
private final String CSS_EMOJI_ATTRIBUTE_SOURCE = "src";

ChromeDriver driver;
CommentPicker commentPicker;
EmojiPicker emojiPicker;
BGMPlayer bgm;
int currentBar = 0;
int currentBeat = 0;
float barTime = 0;
NormalTextMotionObjectFactory basicCommentFactory;
ShapeMotionObjectFactory emojiFactory;
MotionObjectsHolder motionObjects = new MotionObjectsHolder();
BackgroundsHolder backgrounds = new BackgroundsHolder();
int backgroundChangeCount = 0;
PFont defaultFont;
boolean isForcePickMode = false;

void setup()
{
  fullScreen(P2D, 2);
  //size(800, 450, P2D);
  background(255);
  driver = new ChromeDriver();
  driver.get(URL);
  commentPicker = new CommentPicker(new ThreadCommentHandler(driver, CSS_SELECTOR_COMMENT), text -> addMotionObject(text));
  //commentPicker = new CommentPicker(new TestCommentHandler(), text -> addMotionObject(text));  //テスト用
  commentPicker.initialize();
  emojiPicker = new EmojiPicker(new ThreadEmojiCommentHandler(driver, CSS_SELECTOR_EMOJI, CSS_EMOJI_ATTRIBUTE_ID, CSS_EMOJI_ATTRIBUTE_SOURCE), 
    shape -> addMotionObject(shape));
  emojiPicker.initialize();
  bgm = new BGMPlayer(this, "Unreality - D'elf - Isochronous - Dubstep -Free download-.mp3", 140);
  textAlign(CENTER, CENTER);
  rectMode(CENTER);
  ellipseMode(CENTER);
  shapeMode(CENTER);
  imageMode(CENTER);
  
  defaultFont = createFont("MPLUS1-ExtraBold.ttf", 128);
  textFont(defaultFont);
  
  basicCommentFactory = new NormalTextMotionObjectFactory(new LoopShaderDrawContext(#ffffff, shaders.getLoopOutlineShader()), true);
  emojiFactory = new ShapeMotionObjectFactory(new FadeTintDrawContext());
  
  motionObjects.addMotionObject(new AudioSpectrumMotionObject(this, bgm.soundFile), 0);
}

void mousePressed()
{
  startBgm();
}

void keyPressed()
{
  if(key == 'z')
  {
    isForcePickMode = !isForcePickMode;
    println("force picking: " + isForcePickMode);
  }
  else if(key == ' ')
  {
    motionObjects.addMotionObject(new LogoMotionObject(), barTime);
  }
}

void startBgm()
{
  if(!bgm.isPlaying()) 
  {
    bgm.play();
    commentPicker.startAcquisition();
  }
}

void draw()
{
  //フルスクリーン時とそうでない時で見た目が変わらないように無理やり歪める
  scale(getWidthRatio(), getHeightRatio());
  
  barTime = bgm.getBar();
  if((int)(barTime * 2) != currentBar)
  {
    currentBar = (int)(barTime * 2);
    if(barTime >= 9f)
    {
      if(9.5f > barTime)
      {
        commentPicker.forcePickComments(10);
      }
      
      if(isForcePickMode) commentPicker.forcePickComments(3);
      else commentPicker.checkNewComments();  //デフォルト
      commentPicker.startAcquisition();
      emojiPicker.checkNewEmoji();
      emojiPicker.startAcquisition();
    }
  }
  int beat = (int)bgm.getBeat();
  if(beat != currentBeat)
  {
    currentBeat = beat;
    if(backgroundChangeCount > 0)
    {
      backgroundChangeCount--;
      backgrounds.setRandom(barTime);
    }
  }
  background(0);
  backgrounds.draw(barTime);
  motionObjects.drawAndRecord(barTime);
}

void addMotionObject(String text)
{
  basicCommentFactory.setText(text);
  motionObjects.addMotionObject(basicCommentFactory.createMotionObject(), barTime);
  if(backgroundChangeCount < 4) backgroundChangeCount++;
}

void addMotionObject(PShape shape)
{
  emojiFactory.setShape(shape);
  motionObjects.addMotionObject(emojiFactory.createMotionObject(), barTime);
}

void dispose()
{
  super.dispose();
  commentPicker.quit();
  if(driver != null) driver.quit();
}
