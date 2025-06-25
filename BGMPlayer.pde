import processing.sound.*;

public class BGMPlayer
{
  private SoundFile soundFile;
  private float bpm = 0;
  private int sampleRate = 0;
  
  public SoundFile getSoundFile() { return soundFile; }
  public boolean isPlaying() { return soundFile != null && soundFile.isPlaying(); }
  public float getBar() { return soundFile == null ? 0 : soundFile.positionFrame() * bpm / 240f / sampleRate; }
  public float getBeat() { return soundFile == null ? 0 : (soundFile.positionFrame() * bpm / 60f / sampleRate) % 4f; }
  public float getBpm() { return bpm; }
  
  public BGMPlayer(PApplet applet, String soundFileName, float bpm)
  {
    soundFile = new SoundFile(applet, soundFileName);
    this.bpm = bpm;
    sampleRate = soundFile.sampleRate();
  }
  
  public void play()
  {
    soundFile.loop();
  }
}
