class Ai 
{
  private boolean awake = true;
  
  public BodyInterface body;
  public VisionInterface eyes;
  public HearingInterface ears;
  public SpeakingInterface mouth;
  
  public LightingInterface lights;
  
  public Clock clock;
  
  Ai() 
  {
    lights = new HueLighting();
    lights.add(new HueLight("Bedside Lamp", 1));
    lights.add(new HueLight("Standing Lamp", 2));
    clock = new Clock();
  }
  
  Ai(VisionInterface _eyes)
  {
    this.setEyes(_eyes);
  }
  
  Ai(VisionInterface _eyes, HearingInterface _ears)
  {
    this.setEyes(_eyes);
    this.setEars(_ears);
  }
  
  Ai(VisionInterface _eyes, HearingInterface _ears, SpeakingInterface _mouth)
  {
    this.setEyes(_eyes);
    this.setEars(_ears);
    this.setMouth(_mouth);
  }
  
  public void setBody(BodyInterface _body)
  {
    body = _body;
  }
  
  public void setEyes(VisionInterface _eyes)
  {
    eyes = _eyes;
  }
  
  public void setEars(HearingInterface _ears)
  {
    ears = _ears;
  }
  
  public void setMouth(SpeakingInterface _mouth)
  {
    mouth = _mouth;
  }

  public boolean isAwake()
  {
    return this.awake;
  }
  
  public void sleep()
  {
    this.body.sleep();
    this.awake = false;
  }
  
  public void wake()
  {
    this.body.wake();
    this.awake = true;
  }
}
