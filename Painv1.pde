
int clickX, clickY, x0, y0, winCount;
boolean tbox;
PImage img;
PImage history;
color defaultPainColor, painColor, white1;
color[] currentPainColor = new color[10]; //color array
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
int cancelWidth = 150; //used to be 100x100
int cancelHeight = 150;

class Entry {
  int painLevel = -1;
  ArrayList linesX = new ArrayList();
  ArrayList linesY = new ArrayList();
}

Entry currentEntry = new Entry();

ArrayList pastEntries = new ArrayList();

void setup() {

  ellipseMode(CENTER);
  textAlign(CENTER, CENTER);

  size(800, 1200);

  frame.setTitle("Pain Apps");
  winCount = 0;
  img = loadImage("edit-figure.jpg");
  image(img, 0, 0);



  showTitleLabel(); //displays title
  showHistory(); //show history button

  defaultPainColor = color(230, 80, 0);
  painColor = defaultPainColor;
  white1 = color(255,240,255);
  startedDrawing = false;
  inDrawingMode = false;

  tbox = false;

  tBoxX = width/2 - 225;
  tBoxY = height/2 - 300;
  tBoxWidth = 450;
  tBoxHeight = 450;
  btnWidth = tBoxWidth/5;
  btnHeight = btnWidth;
  btnY = tBoxY + 200;
  print(currentEntry.linesX);

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
    showTitleLabel();
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
    currentEntry.painLevel = getScaleButton();
    if (currentEntry.painLevel > -1) {
      winCount = 2;
      showTBox();
    }
  } else if (winCount == 2) {
    painLevel = getScaleButton();
    if (painLevel > -1) {
      winCount = 3;
      showTBox();
    }
  } else if (winCount == 3) {  
    pastEntries.add(currentEntry);
    doReset();
  }
}

int getScaleButton() {
  if (tBoxX < mouseX && mouseX < tBoxX + tBoxWidth) {
    //Find how far from the left of the tbox the mouse is, then divide that by the button width
    //to figure out what button it must be in. The 1 is added because we made the scale 1 - 5, and
    //naturally Java starts the indices at 0 and ends at 4
    return 1 + (mouseX - tBoxX)/(btnWidth);
  }
  return -1;
}

color colorScale(int i) {
  if (i == -1) {
    return defaultPainColor;
  } else {
    return color(100 + i*40,100 + i*15,100);
  }
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
  text("How strong is your pain?", tBoxX + tBoxWidth/2, tBoxY + 100);
  for (int i = 0; i < 5; i++) {
    makeWindowOneButton(i);
  }
}

void showWindowTwo() {
  fill(100,100,150);
  textSize(32);
  text("What does your pain feel like?", tBoxX + tBoxWidth/2, tBoxY + 100);
  for (int i = 0; i < 5; i++) {
    noStroke();
   fill(color(100 + i*40,100 + i*15,100));
   rect(tBoxX + 40, tBoxY + i*50 + 150, tBoxWidth-80, 40);
   fill(0,0,255);
   textSize(12);
   text(i, tBoxX + 10, tBoxY + i*50 + 170);
  }
}

void showWindowThree() {
  String [] patternA = new String [3];
  patternA[0] = "Continuous, steady, constant";
  patternA[1] = "Rhythmic, periodic, intermittent";
  patterna[2] = "Brief, momentary, transient";
  fill(100,100,150);
  textSize(32);
  text("How would you describe the \n pattern of your pain?", tBoxX + tBoxWidth/2, tBoxY + 100);
  for (int i = 0; i < 3; i++) {
   noStroke();
   fill(color(100 + i*40,100 + i*15,100));
   rect(tBoxX + 40, tBoxY + i*90 + 160, tBoxWidth-80, 75);
   fill(0,0,255);
   textSize(12);
   text(i, tBoxX + 25, tBoxY + i*90 + 190);
   text(patternA[i], tBoxX + 60, tBoxY + i*90 + 190);
  }
}

void showTBox() { //displays popup window
  stroke(100,100,150);
  strokeWeight(3);
  fill(#ffffff);
  rect(tBoxX, tBoxY, tBoxWidth, tBoxHeight);
  if (winCount == 1) { //question 1
    showWindowOne();
  } else if (winCount == 2) { //question 2
    showWindowTwo();
  } else if (winCount == 3) { // question 3
    showWindowThree();
  }
}

void drawLines() {
  if (startedDrawing) {
    stroke(painColor);
    strokeWeight(15);
    line(pmouseX, pmouseY, mouseX, mouseY);
    currentEntry.linesX.add(mouseX);
    currentEntry.linesY.add(mouseY);
  }
  else {
    startedDrawing = true;
    inDrawingMode = true;
    painColor = colorScale(currentEntry.painLevel);
  }
}

void redrawPainArea() {
  redrawSingleEntry(currentEntry);
  if (pastEntries.size() > 0) {
    for (int i = 0; i < pastEntries.size(); i++) {
      redrawSingleEntry((Entry)pastEntries.get(i));
    }
  }
}

void redrawSingleEntry(Entry e) {
  if (e.linesX.size() == 0) {
    print("none");
    return;
  }
  stroke(colorScale(e.painLevel));
  strokeWeight(15);
  int x0, x1, y0, y1;
  x0 = (int)e.linesX.get(0);
  y0 = (int)e.linesY.get(0);
  for (int i = 1; i < e.linesX.size(); i++) {
    x1 = x0;
    y1 = y0;
    x0 = (int)e.linesX.get(i);
    y0 = (int)e.linesY.get(i);
    line(x0, y0, x1, y1);
  }
}

void doReset() {
    tbox = false;
    startedDrawing = false;
    winCount = 0;
    image(img, 0, 0);
    showTitleLabel();
    painColor = colorScale(painLevel - 1);
    redrawPainArea();
}

void doCancel() {
    startedDrawing = false;
    currentEntry = new Entry();
    painColor = defaultPainColor;
}

void showCancelButton() {
  noStroke();
  fill(255, 0, 0 ); //before: fill(100,100,100) (for gray color)
  rect(cancelX, cancelY, cancelWidth, cancelHeight);
  fill(255,255,255);
  //textSize(72);
  textSize(105);
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

//new method to display title
void showTitleLabel()
{
  //noStroke();
  //fill(255, 255, 255);
  //rect(okX+600, okY, okWidth, okHeight);
  fill(0,0,0);
  textSize(50);
  text("PAIN APPS", (okX+okWidth/2)+570, (okY+okHeight/2)-50);

}

void showHistory()
{
  noStroke();
  fill(255, 255, 255);
  rect(okX+600, okY, okWidth, okHeight);
  fill(0,0,0);
  textSize(50);
  text("PAIN APPS", (okX+okWidth/2)+570, (okY+okHeight/2)-50);
  
  fill(0, 191, 255);
  rect(okX+668, okY+65, okWidth/1.5, okHeight/1.5);

     history = loadImage("history.png");
   history.resize(90,90);
  image(history, 683, 80);

  fill(255,255,255);
  //textSize(35);
  //text("History", (okX+okWidth/2)+600, (okY+okHeight/2)+25);



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

