class BodyWatson implements BodyInterface
{
  int pointDensity = 100;
  int radius = 140;
  int gravityWell = 234;
  float speed = 0.009;
  float lineStrength = 25;
  boolean awake = true;
  
  ArrayList<PVector> points;
  
  public BodyWatson()
  { 
    this.setPoints(pointDensity);
  }
  
  public BodyWatson(int _pointDensity, int _radius)
  { 
    this.pointDensity = _pointDensity;
    this.radius = _radius;
    this.points = new ArrayList<PVector>();
    this.setPoints(pointDensity);
  }
  
  private void setPoints(int numPoints)
  {
    while (this.points.size() != numPoints) {
      float x = 0;
      float y = 0;
      
      while (dist(x, y, width/2, height/2) > this.radius) {
        x = random(width/2 - this.radius, width/2 + this.radius);
        y = random(height/2 - this.radius, height/2 + this.radius);
      }
      
      if (this.points.size() < numPoints) {
        this.points.add(new PVector(x, y));
      } else if (this.points.size() > numPoints) {
        this.points.remove(points.size() - 1);
      }
    }
  }
  
  public boolean isAwake()
  {
    return this.awake;
  }
  
  public void sleep() 
  {
    this.setPoints(pointDensity / 3);
    this.lineStrength = this.lineStrength * 2;
    this.awake = false;
  }
  
  public void wake() 
  {
    
    this.setPoints(pointDensity);
    this.lineStrength = this.lineStrength / 2;
    this.awake = true;
  }
  
  public void render() {
    fill(225, 255, 245);
    int strength = 0;
    int mod = (strength <= 0) ? -1 : 1;
    
    for (int i = 0; i < points.size() - 1; i++) {
      PVector point = points.get(i);
      ellipse(point.x, point.y, 1, 1);
      
      for (int j = 0; j < points.size() - 1; j++) {
        if (i == j)
          continue;
          
        PVector otherPoint = points.get(j);
          
        float dx = otherPoint.x - point.x;
        float dy = otherPoint.y - point.y;
        float distance = sqrt(dx*dx + dy*dy);
        
        if (distance < gravityWell) {
          if (distance < lineStrength + strength / 1.2 * mod) {
            //stroke(225, 245, 255, 33);
            int colorMod = (int)(dist(point.x, point.y, width/2, height/2) * 0.9 - lineStrength * 0.8);
            stroke(190 - colorMod, 255 - colorMod, 255, 100);
            line(point.x, point.y, otherPoint.x, otherPoint.y);
          }
          
          float angle = atan2(dy, dx);
          float targetX = point.x + cos(angle) * (radius);
          float targetY = point.y + sin(angle) * (radius);
          PVector a = new PVector((targetX - otherPoint.x) * speed, (targetY - otherPoint.y) * speed);
          point.sub(a);
          otherPoint.add(a);
        }
      }
    }
  }
}
