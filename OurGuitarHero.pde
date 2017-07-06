notes n1 = new notes(0, -2, 100);
notes n2 = new notes(0, 3, 200);
notes n3 = new notes(0, 2, 300);
notes n4 = new notes(0, 4, 400);
notes n5 = new notes(0, 2, 500);

  
void setup() {
  size(600, 600);
}

void draw() {  
  background(20);
  for (int i = 100; i < 501; i = i + 100) {
    fill(i/2, 50 , 100);
    stroke(i/2, 50, 100);
    line(i, 0, i, height);
  }
  n1.update();
  n2.update();
  n3.update();
  n4.update();
  n5.update();
} 
