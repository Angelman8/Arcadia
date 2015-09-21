class BodyWatson implements BodyInterface
{
  int pointDensity = 100;
  int radius = 150;
  int gravityWell = 500;
  float speed = 0.008;
  float lineStrength = 25;
  PVector[] points;
  boolean awake = true;
  
  public BodyWatson()
  { 
    this.setPoints(pointDensity);
  }
  
  public BodyWatson(int _pointDensity, int _radius)
  { 
    this.pointDensity = _pointDensity;
    this.radius = _radius;
    
    
    this.setPoints(pointDensity);
  }
  
  private void setPoints(int numPoints)
  {
    this.points = new PVector[numPoints];
    for (int i = 0; i < this.points.length-1; i++) {
      float x = 0;
      float y = 0;
      while (dist (x, y, width/2, height/2) > this.radius) {
        x = random(width/2 - this.radius, width/2 + this.radius);
        y = random(height/2 - this.radius, height/2 + this.radius);
      }
      this.points[i] = new PVector(x, y);
    }
  }
  
  public boolean isAwake()
  {
    return this.awake;
  }
  
  public void sleep() {
    this.setPoints(this.pointDensity/3);
    this.lineStrength = this.lineStrength * 2;
    this.awake = false;
  }
  
  public void wake() {
    this.setPoints(this.pointDensity);
    this.lineStrength = this.lineStrength / 2;
    this.awake = true;
  }
  
  public void render() {
    fill(225, 255, 245);
    int strength = 0; //abs((int)(input.mix.get(0) * 200));
    int mod = (strength <= 0) ? -1 : 1;
    
    for (int i = 0; i < points.length-1; i++) {
      ellipse(points[i].x, points[i].y, 1, 1);
      
      for (int j = 0; j < points.length-1; j++) {
        if (i == j)
          continue;
        float dx = points[j].x - points[i].x;
        float dy = points[j].y - points[i].y;
        float distance = sqrt(dx*dx + dy*dy);
        
        if (distance < gravityWell) {
          
          if (distance < lineStrength + strength / 1.2 * mod) {
            stroke(225, 245, 255, 33);
            line(points[i].x, points[i].y, points[j].x, points[j].y);
          }
          float angle = atan2(dy, dx);
          float targetX = points[i].x + cos(angle) * (radius);
          float targetY = points[i].y + sin(angle) * (radius);
          PVector a = new PVector((targetX - points[j].x) * speed, (targetY - points[j].y) * speed);
          points[i].sub(a);
          points[j].add(a);
        }
      }
    }
  }
}
