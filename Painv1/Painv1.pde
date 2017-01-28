
int clickX, clickY, x0, y0, winCount;
boolean tbox;
PImage img;
color red1, white1;

void setup() {
  size(800, 1200);
  winCount = 0;
  img = loadImage("body.png");
  background(img);
  red1 = color(230, 80, 0);
  white1 = color(255,240,255);

  ellipseMode(CENTER);
  
  tbox = false;
}

void draw() {
  update(mouseX, mouseY);

  fill(red1);
  noStroke();
  ellipse(clickX, clickY, 80, 80);
  
  fill(white1);
  if (tbox == true) {
    x0 = width/2 - 200;
    y0 = height/2 - 300;
    stroke(153);
    rect(x0, y0, 450, 450);
    if (winCount == 1) {
      fill(0,0,255);
      textSize(32);
      text("How bad is your pain?", x0 + 60, y0 + 150);
      
      for (int i = 0; i < 10; i++) {
       fill(color(100 + i*40,100 + i*15,100));
       rect(x0 + 2 + i * 45, y0 + 225, 40, 40);
       fill(0,0,255);
       textSize(12);
       text(i + 1, x0+21 + i*45, y0 + 250);
      }
    } else if (winCount == 2) {
      fill(0,0,255);
      textSize(32);
      text("What does it feel like?", x0 + 60, y0 + 100);
      
      for (int i = 0; i < 5; i++) {
       fill(color(100 + i*40,100 + i*15,100));
       rect(x0 + 40, y0 + i*50 + 150, 40, 40);
       fill(0,0,255);
       textSize(12);
       text(i, x0 + 10, y0 + i*50 + 170);
      }
      
    }
  }
}

void update(int x, int y) {
}


void mousePressed() {
  if (tbox == false) {
    tbox = true;
    winCount = 1;
  } else if (winCount < 2) {
    winCount = 2;
  } else {  
    tbox = false;
  }
  clickX = mouseX;
  clickY = mouseY;
  print(second());
}