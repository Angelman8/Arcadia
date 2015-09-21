boolean verbose = true;

Ai arcadia;

void setup() 
{
  size(640, 480);
  arcadia = new Ai();
  arcadia.setBody(new BodyWatson(90, 150));
  arcadia.setEyes(new VisionKinect(this, true));
}

void draw()
{
  background(0);
  arcadia.eyes.look();
  arcadia.body.render();

  if (arcadia.eyes.foundUser()) {
    arcadia.wake();
    if (arcadia.clock.late()) {
      arcadia.lights.on(2);
      arcadia.lights.brightness(2, 30);
    } else if (arcadia.clock.evening()) {
      arcadia.lights.on(2);
    }
  } else if (arcadia.eyes.lostAllUsers()) { 
    arcadia.sleep();
    arcadia.lights.off(1);
    arcadia.lights.off(2);
  }
}

