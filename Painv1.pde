
int clickX, clickY, x0, y0, winCount;
boolean tbox;
PImage img;
color red1, white1;
boolean startedDrawing, inDrawingMode;
ArrayList linesX = new ArrayList();
ArrayList linesY = new ArrayList();
boolean reset, redraw;

int tBoxX, tBoxY, tBoxWidth, tBoxHeight;

int okX = 640;
int okY = 10;
int okWidth = 150;
int okHeight = 150;

int cancelX = 10;
int cancelY = 10;
int cancelWidth = 150;
int cancelHeight = 150;


void setup() {
  size(800, 1200);
  winCount = 0;
  img = loadImage("body.png");
  background(img);
  red1 = color(230, 80, 0);
  white1 = color(255,240,255);
  startedDrawing = false;
  inDrawingMode = false;

  ellipseMode(CENTER);
  textAlign(CENTER, CENTER);
  
  tbox = false;
  
  tBoxX = width/2 - 200;
  tBoxY = height/2 - 300;
  tBoxWidth = 450;
  tBoxHeight = 450;
}

void draw() {
  update(mouseX, mouseY);

  fill(red1);
  noStroke();
  ellipse(clickX, clickY, 80, 80);
  
  fill(white1);
  if (tbox) {
    showTBox();
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

void makeWindowOneButton(int i, int btnWidth, int btnHeight) {
   fill(color(100 + i*40,100 + i*15,100));
   rect(tBoxX + i*btnWidth, tBoxY + 200, btnWidth, btnHeight);
   fill(0,0,0);
   textSize(36);
   text(i+1, tBoxX + (i + 0.5)*btnWidth, tBoxY + 200 + btnHeight/2);
}

void showWindowOne() {
  int btnWidth = tBoxWidth/5;
  int btnHeight = btnWidth;
  int offsetY;
  fill(100,100,150);
  noStroke();
  textSize(32);
  text("How bad is your pain?", tBoxX + tBoxWidth/2, tBoxY + 100);
  for (int i = 0; i < 5; i++) {
    makeWindowOneButton(i, btnWidth, btnHeight);
  }
}

void showWindowTwo() {
  fill(100,100,150);
  textSize(32);
  text("What does it feel like?", tBoxX + tBoxWidth/2, tBoxY + 100);
  for (int i = 0; i < 5; i++) {
    noStroke();
   fill(color(100 + i*40,100 + i*15,100));
   rect(tBoxX + 40, tBoxY + i*50 + 150, tBoxWidth-80, 40);
   fill(0,0,255);
   textSize(12);
   text(i, tBoxX + 10, tBoxY + i*50 + 170);
  }
}

void showTBox() {
  stroke(100,100,150);
  strokeWeight(3);
  fill(#ffffff);
  rect(tBoxX, tBoxY, tBoxWidth, tBoxHeight);
  if (winCount == 1) {
    showWindowOne();
  } else if (winCount == 2) {
    showWindowTwo();
  }
}