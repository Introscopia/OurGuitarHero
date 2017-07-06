class notes { 
  float ypos, speed, xpos, clrr, clrg, clrb;//here are the values "yposition, speed of the note, xposition, and the r, g and b values
  notes (float y, float s, float x, float r, float g, float b) {  
    ypos = y; 
    speed = s; 
    xpos = x;
    clrr = r;
    clrg = g;
    clrb = b;
  } 
  void update() { 
    ypos += speed; 
    if (ypos > width) { 
      ypos = 0; 
    } 
    noStroke();
    fill(clrr,clrg,clrb);
    ellipse(xpos, ypos, 30, 30); 
  } 
} 
