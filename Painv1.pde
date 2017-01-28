
int clickX, clickY, x0, y0, winCount;
boolean tbox;
PImage img;
color defaultPainColor, painColor, white1;
int painLevel = -1;
boolean startedDrawing, inDrawingMode;
ArrayList linesX = new ArrayList();
ArrayList linesY = new ArrayList();
boolean reset, redraw;

int tBoxX, tBoxY, tBoxWidth, tBoxHeight;

int btnWidth, btnHeight, btnY; 

int okX = 10;
int okY = 10;
int okWidth = 150;
int okHeight = 150;

int cancelX = 10;
int cancelY = 170;
int cancelWidth = 100;
int cancelHeight = 100;


void setup() {
  size(800, 1200);
  winCount = 0;
  img = loadImage("body.png");
  image(img, 0, 0);
  defaultPainColor = color(230, 80, 0);
  painColor = defaultPainColor;
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
  btnWidth = tBoxWidth/5;
  btnHeight = btnWidth;
  btnY = tBoxY + 200;

}

void draw() {

    if (mousePressed) {
      if (!tbox && !onCancelButton() && !onOkButton()){
          drawLines();
        }
    }
    else { 
      startedDrawing = false; //When the user stops drawing, this resets
    }
  
  if (inDrawingMode) {
    showCancelButton();
    showOkButton();
  }
  
}

void keyPressed() {
  if (key == 'q') {
    winCount = 1;
    tbox = true;
  }
}

void mousePressed() {
  println(winCount);
  if (onCancelButton()){
      showCancelButton();
      doCancel();
      doReset();
  } else if (onOkButton()){
    winCount = 1;  
    tbox = true;
    showTBox();
  } else if (winCount == 1) {
    painLevel = getScaleButton();
    if (painLevel > -1) {
      winCount = 2;
      showTBox();
    }
  } else if (winCount == 2) {  
    doReset();
  }
}

int getScaleButton() {
  if (tBoxX < mouseX && mouseX < tBoxX + tBoxWidth) {
    return 1 + (mouseX - tBoxX)/(btnWidth);
  }
  return -1;
} 

color colorScale(int i) {
  return color(100 + i*40,100 + i*15,100);
}

void makeWindowOneButton(int i) {
   fill(colorScale(i));
   rect(tBoxX + i*btnWidth, btnY, btnWidth, btnHeight);
   fill(0,0,0);
   textSize(36);
   text(i+1, tBoxX + (i + 0.5)*btnWidth, tBoxY + 200 + btnHeight/2);
}

void showWindowOne() {
  int offsetY;
  fill(100,100,150);
  noStroke();
  textSize(32);
  text("How bad is your pain?", tBoxX + tBoxWidth/2, tBoxY + 100);
  for (int i = 0; i < 5; i++) {
    makeWindowOneButton(i);
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

void drawLines() {
  if (startedDrawing) {
    stroke(painColor);
    strokeWeight(15);
    line(pmouseX, pmouseY, mouseX, mouseY);
    linesX.add(mouseX);
    linesY.add(mouseY);
  }
  else {
    startedDrawing = true;
    inDrawingMode = true;
  }
}

void redrawPainArea() {
  if (linesX.size() == 0) { 
    print("none");
    return; 
  }
  stroke(painColor);
  strokeWeight(15);
  int x0, x1, y0, y1;
  x0 = (int)linesX.get(0);
  y0 = (int)linesY.get(0);
  for (int i = 1; i < linesX.size(); i++) {
    x1 = x0;
    y1 = y0;
    x0 = (int)linesX.get(i);
    y0 = (int)linesY.get(i);
    line(x0, y0, x1, y1);
  }
}

void doReset() {
    tbox = false;
    winCount = 0;
    image(img, 0, 0);
    painColor = colorScale(painLevel - 1);
    redrawPainArea();
}

void doCancel() {
    linesX = new ArrayList();
    linesY = new ArrayList();
    painColor = defaultPainColor;
}

void showCancelButton() {
  noStroke();
  fill(100, 100, 100);
  rect(cancelX, cancelY, cancelWidth, cancelHeight);
  fill(255,255,255);
  textSize(72);
  text("\u2718", cancelX+cancelWidth/2, cancelY+cancelHeight/2-8);
}

void showOkButton() {
  noStroke();
  fill(160, 200, 100);
  rect(okX, okY, okWidth, okHeight);
  fill(255,255,255);
  textSize(136);
  text("\u2713", okX+okWidth/2, okY+okHeight/2-8);
}

boolean onOkButton() {
  if (inDrawingMode && okX < mouseX && mouseX < okX+okWidth && okY < mouseY && mouseY < okY+okHeight) {
    return true;
  }
  return false;
}

boolean onCancelButton() {
  if (inDrawingMode && cancelX < mouseX && mouseX < cancelX+cancelWidth && cancelY < mouseY && mouseY < cancelY+cancelHeight) {
    return true;
  }
  return false;
}