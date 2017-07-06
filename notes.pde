class notes { 
  private float ypos, speed, xpos;
  notes (float y, float s, float x) {  
    ypos = y; 
    speed = s; 
    xpos = x;
  } 
  void update() { 
    fill(ypos/2, 0, xpos/2);
    ypos += speed; 
    if (ypos > height) { 
      ypos = 0;
    } 
    ellipse(xpos, ypos, 30, 30);
  }
} 
