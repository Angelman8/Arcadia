public interface BodyInterface
{
  public boolean isAwake();
  public void sleep();
  public void wake();
  public void render();
}

public interface HearingInterface
{
  public void listen();
  public void render();
  
  public String parse();
}

public interface VisionInterface
{
  public void look();
  public void render();
  
  public int[] getUsers();
  public boolean foundUser();
  public boolean lostUser();
  public boolean lostAllUsers();
}

public interface SpeakingInterface
{
  public void speak();
  public void render();
}

public interface LightingInterface
{
  public void add(LightInterface light);
  public void remove(int id);
  public void on();
  public void on(int id);
  public void off();
  public void off(int id);
  public void brightness(int brightness);
  public void brightness(int id, int brightness);
}

public interface LightInterface
{
  public void toggle();
  public void on();
  public void off();
  public void brightness(int brightness);
  public void brightness(int brightness, int transitionSpeed);
  
  public int brightness();
  public boolean isOn();
}
