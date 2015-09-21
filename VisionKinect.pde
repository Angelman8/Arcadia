import SimpleOpenNI.*; 

class VisionKinect implements VisionInterface
{
  SimpleOpenNI context;
  
  private boolean showDepth = false;
  private PImage img;
  private int[] users;
  private int[] usersHistory;
  private int[] userPixels;

  VisionKinect(Arcadia instance) 
  {
    initializeContext(instance);
  }

  VisionKinect(Arcadia instance, boolean _showDepth) 
  {
    this.initializeContext(instance);
    this.showDepth = _showDepth;
  }

  private void initializeContext(Arcadia instance)
  {
    this.context = new SimpleOpenNI(instance);
    this.context.enableDepth();
    this.context.enableUser();
    this.context.setMirror(true);
    this.img = createImage(640, 480, RGB);
    this.img.loadPixels();
    this.setUsers(this.context);
  }

  public int[] getUsers()
  {
    return this.users;
  }
  
  private void setUsers(SimpleOpenNI context)
  {
    this.usersHistory = this.users;
    this.users = context.getUsers();
    
  }
  
  public boolean foundUser()
  {
    if (this.users.length > this.usersHistory.length) {
      println("found user");
      return true;
    } else {
      return false;
    }
  }
  
  public boolean lostUser()
  {
    if (this.users.length < this.usersHistory.length) {
      println("lost user");
      return true;
    } else {
      return false;
    }
  }

  public boolean lostAllUsers()
  {
    if (this.users.length < this.usersHistory.length && this.users.length <= 0) {
      println("no users found");
      return true;
    } else {
      return false;
    }
  }
  
  public void look()
  {
    this.context.update();
    this.setUsers(this.context);
  }

  public void render() 
  { 
    if (!showDepth) {
      return;
    }

    PImage depthImage = context.depthImage();
    depthImage.loadPixels();

    userPixels = context.userMap();

    for (int i = 0; i < userPixels.length; i++) {
      img.pixels[i] = (userPixels[i] > 0) ? color(0, 0, 255) : depthImage.pixels[i];
    }

    img.updatePixels();
    image(img, 0, 0);

    ellipseMode(CENTER);

    for (int i = 0; i < this.users.length; i++) {
      int uid = users[i];

      PVector realCoM = new PVector();
      context.getCoM(uid, realCoM);
      PVector projCoM = new PVector();

      context.convertRealWorldToProjective(realCoM, projCoM);

      fill(255, 0, 0);
      ellipse(projCoM.x, projCoM.y, 10, 10);

      if (context.isTrackingSkeleton(uid)) {
        //HEAD
        PVector realHead = new PVector();
        context.getJointPositionSkeleton(uid, SimpleOpenNI.SKEL_HEAD, realHead);
        PVector projHead = new PVector();
        context.convertRealWorldToProjective(realHead, projHead);

        fill(0, 255, 0);
        ellipse(projHead.x, projHead.y, 10, 10);

        //LEFT HAND
        PVector realLHand = new PVector();
        context.getJointPositionSkeleton(uid, SimpleOpenNI.SKEL_LEFT_HAND, realLHand);
        PVector projLHand = new PVector();
        context.convertRealWorldToProjective(realLHand, projLHand);

        fill(255, 255, 0);
        ellipse(projLHand.x, projLHand.y, 10, 10);

        //LEFT FOOT
        PVector realLFoot = new PVector();
        context.getJointPositionSkeleton(uid, SimpleOpenNI.SKEL_LEFT_FOOT, realLFoot);
        PVector projLFoot = new PVector();
        context.convertRealWorldToProjective(realLFoot, projLFoot);

        fill(255, 255, 255);
        ellipse(projLFoot.x, projLFoot.y, 10, 10);

        //RIGHT HAND
        PVector realRHand = new PVector();
        context.getJointPositionSkeleton(uid, SimpleOpenNI.SKEL_RIGHT_HAND, realRHand);
        PVector projRHand = new PVector();
        context.convertRealWorldToProjective(realRHand, projRHand);

        fill(255, 0, 255);
        ellipse(projRHand.x, projRHand.y, 10, 10);
      }
    }
  }

  void onNewUser(SimpleOpenNI curContext, int userId)
  {
    println("New User - userId: " + userId);
    curContext.startTrackingSkeleton(userId);
    println("People Active: " + this.users.length);
  }

  void onLostUser(SimpleOpenNI curContext, int userId)
  {
    println("Lost User - userId: " + userId);
    println("People Active: " + this.users.length);
  }
}

