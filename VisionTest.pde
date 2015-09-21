class VisionTest implements VisionInterface
{
  public int[] getUsers()
  {
    int [] users = new int[(int)random(1, 10)];
    println(users.length);
    for (int i = 0; i < users.length; i++) {
      users[i] = i * 100;
    }
    
    return users;
  }
  
  public boolean foundUser()
  {
    return true;
  }
  
  public boolean lostUser()
  {
    return true;
  }
  
  public boolean lostAllUsers()
  {
    return true;
  }

  public void look()
  {
  }

  public void render()
  {
    for (int x = 0; x <= width; x++) {
      for (int y = 0; y <= height; y++) {
        stroke(color(random(0, 255), random(0, 255), random(0, 255)));
        rect(x, y, 1, 1);
      }
    }
  }
}

