public class MotionObjectsHolder
{
  List<MotionObjectInfo> motions = new ArrayList<MotionObjectInfo>();
  
  public void addMotionObject(IMotionObject motionObject, float time)
  {
    motions.add(new MotionObjectInfo(motionObject, time));
  }
  
  public void drawAndRecord(float time)
  {
    for(var motion : motions)
    {
      boolean drawResponse = motion.motionObject.draw(time - motion.startTime);
      if(!drawResponse && motion.endTime == 0) motion.endTime = time;
    }
    for(int i = motions.size() - 1; i >= 0; i--)
    {
      float endTime = motions.get(i).endTime;
      if(endTime != 0 && time - endTime > 4) 
      {
        motions.remove(i);
      }
    }
  }
  
  public class MotionObjectInfo
  {
    public IMotionObject motionObject;
    public float startTime;
    public float endTime;
    
    public MotionObjectInfo(IMotionObject motionObject, float startTime, float endTime)
    {
      this.motionObject = motionObject;
      this.startTime = startTime;
      this.endTime = endTime;
    }
    
    public MotionObjectInfo(IMotionObject motionObject, float startTime)
    {
      this(motionObject, startTime, 0);
    }
  }
}
