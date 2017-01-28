
int clickX;
int clickY;
PImage img;
color red1;

void setup() {
  size(800, 1200);
  
  img = loadImage("body.png");
  red1 = color(230, 80, 0);

  ellipseMode(CENTER);
}

void draw() {
  update(mouseX, mouseY);
  background(img);

  fill(red1);
  noStroke();
  ellipse(clickX, clickY, 80, 80);
}

void update(int x, int y) {
  
}

void mousePressed() {
  clickX = mouseX;
  clickY = mouseY;
  print(second());
}