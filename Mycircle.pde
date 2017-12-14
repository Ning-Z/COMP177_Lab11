class MyCircle {
  float cx, cy, radius;
  float dx, dy;
  color fillcolor;
  boolean selected;
  
  MyCircle() {
    cx = random(0, width);
    cy = random(0, height);
    dx = random(-5, 5);
    dy = random(-5, 5);
    radius = random (5, 50);
    fillcolor = color(random(0, 255), random(0, 255), random(0, 255));
    selected = false;
  }
  
  void render() {
    stroke(fillcolor);
    if (selected == true) {
      fill(fillcolor);
    }
    else{
      noFill();
    }
    ellipse(cx, cy, radius, radius);
  }
  
  void update() {
    cx += dx;
    cy += dy;
    if ((cx < 0) || (cx > width)){
      dx = -dx;
    }
    if ((cy < 0) || (cy > height)) {
      dy = -dy;
    }
  }
  
  void isect(int mx, int my) {
    float xsquare = (mx - cx) * (mx - cx);
    float ysquare = (my - cy) * (my - cy);
    float dist = sqrt(xsquare + ysquare);
    
    if (dist < radius) {
      selected = true;
    }
    else {
      selected = false;
    }
  }
}